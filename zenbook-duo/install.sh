#!/bin/sh
# Install/refresh Zenbook Duo support. Run as root (sudo or pkexec).
#   zenbook-kbd: keyboard init, Fn-lock, vendor hotkeys, keyboard backlight
#   duo:         bottom screen on/off with keyboard, rotation, screen brightness sync, wifi/bt
set -e
cd "$(dirname "$0")"

TARGET_USER=${SUDO_USER:-$(id -un "${PKEXEC_UID:-0}")}
if [ "$TARGET_USER" = root ]; then
    echo "Run via sudo or pkexec from your user account (needed for the sudoers rule)." >&2
    exit 1
fi

# --- Packages ---------------------------------------------------------------
# zenbook-kbd: python3 (stdlib only). duo: inotifywait, lsusb, gdctl, monitor-sensor.
PKGS="python3-minimal inotify-tools usbutils mutter-common-bin iio-sensor-proxy"
MISSING=""
for p in $PKGS; do
    dpkg -s "$p" >/dev/null 2>&1 || MISSING="$MISSING $p"
done
if [ -n "$MISSING" ]; then
    apt-get update && apt-get install -y $MISSING
fi

# uinput/hidraw are built into Ubuntu kernels; load them if a kernel ships them as modules.
for mod in uinput hidraw; do
    if modinfo -F filename "$mod" 2>/dev/null | grep -q '\.ko'; then
        modprobe "$mod"
        echo "$mod" > "/etc/modules-load.d/zenbook-kbd-$mod.conf"
    fi
done

# --- Sudoers ----------------------------------------------------------------
# duo (runs as the user) needs to write the bottom screen's brightness.
# Also drops rules older duo setup.sh versions appended to /etc/sudoers.
RULE="$TARGET_USER ALL=NOPASSWD:/usr/bin/tee /sys/class/backlight/card1-eDP-2-backlight/brightness"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
grep -vE 'NOPASSWD:.*(/tmp/duo/backlight\.py|card1-eDP-2-backlight/brightness)' /etc/sudoers > "$TMP/sudoers" || true
echo "$RULE" > "$TMP/zenbook-duo"
visudo -cqf "$TMP/sudoers"
visudo -cqf "$TMP/zenbook-duo"
if ! cmp -s "$TMP/sudoers" /etc/sudoers; then
    cp /etc/sudoers /etc/sudoers.bak-zenbook
    install -m440 -o root -g root "$TMP/sudoers" /etc/sudoers
    echo "Cleaned old duo rules from /etc/sudoers (backup: /etc/sudoers.bak-zenbook)"
fi
install -m440 -o root -g root "$TMP/zenbook-duo" /etc/sudoers.d/zenbook-duo
visudo -cq
rm -f /tmp/duo/backlight.py

# --- zenbook-kbd --------------------------------------------------------------
install -Dm755 zenbook-kbd.py /usr/local/lib/zenbook-kbd/zenbook-kbd.py
install -Dm644 zenbook-kbd.service /etc/systemd/system/zenbook-kbd.service

# --- duo ----------------------------------------------------------------------
# Replace via rename so running copies of the script aren't disturbed mid-read.
install -m755 duo.sh /usr/local/bin/duo.new && mv -f /usr/local/bin/duo.new /usr/local/bin/duo
ln -sfn /usr/local/bin/duo /usr/lib/systemd/system-sleep/duo
install -Dm644 zenbook-duo.service /etc/systemd/system/zenbook-duo.service
install -Dm644 zenbook-duo-user.service /etc/systemd/user/zenbook-duo-user.service

# --- Enable -------------------------------------------------------------------
systemctl daemon-reload
systemctl enable zenbook-kbd.service zenbook-duo.service
# reenable: the unit moved from default.target to graphical-session.target
systemctl --global reenable zenbook-duo-user.service
systemctl restart zenbook-kbd.service
sleep 1
systemctl --no-pager status zenbook-kbd.service | head -5
echo
echo "Done. Restart the session handler to pick up the new duo:"
echo "  systemctl --user restart zenbook-duo-user.service"
