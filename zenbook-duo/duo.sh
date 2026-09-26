#!/bin/bash

# Source: https://github.com/Fmstrat/zenbook-duo-linux/blob/385395dccefd28f93532a2e558931eda7374fd24/duo.sh
# License: GPL-3.0 (see LICENSE-duo)
# Modified 2026-09-24:
#   - Removed keyboard backlight control (embedded backlight.py, duo-set-kb-backlight, `duo kbb`);
#     zenbook-kbd.py handles the keyboard now.
#   - DEFAULT_SCALE=1.5 (setup.sh used to substitute this at install time).
#   - Debounced keyboard detach (recheck after 5s) so a USB blip after resume doesn't
#     flip the bottom screen on and off.
#   - Wait for Mutter's DisplayConfig before the first monitor check at login.
#   - Pin PATH so gdctl runs under the system python3.
#   - Recheck monitors from the session after resume.

# System tools only: gdctl is `#!/usr/bin/env python3` and needs the distro python3 (for gi),
# not a user-installed one (asdf, pyenv...) that the session PATH may put first.
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Default scale (1-2)
DEFAULT_SCALE=1.5

# Capture Ctrl+C and close any subprocesses such as duo-watch-monitor
trap 'echo "Ctrl+C captured. Exiting..."; pkill -P $$; exit 1' INT

mkdir -p /tmp/duo

# SCALE=$(gdctl show |grep Scale: |sed 's/│//g' |awk '{print $2}' |head -n1)
# if [ -z "${SCALE}" ]; then
#     SCALE=1
# fi
SCALE=${DEFAULT_SCALE}

WIFI_BEFORE=$(nmcli radio wifi)
BLUETOOTH_BEFORE=$(rfkill -n -o SOFT list bluetooth |head -n1)
KEYBOARD_ATTACHED=false
if [ -n "$(lsusb | grep 'Zenbook Duo Keyboard')" ]; then
    KEYBOARD_ATTACHED=true
fi
MONITOR_COUNT=$(gdctl show | grep 'Logical monitor #' | wc -l)
function duo-set-status() {
    echo "
        BLUETOOTH_BEFORE=${BLUETOOTH_BEFORE}
        WIFI_BEFORE=${WIFI_BEFORE}
        KEYBOARD_ATTACHED=${KEYBOARD_ATTACHED}
        MONITOR_COUNT=${MONITOR_COUNT}
    " > /tmp/duo/status
}
duo-set-status

BRIGHTNESS=0
function duo-sync-display-backlight() {
    . /tmp/duo/status
    if [ "${KEYBOARD_ATTACHED}" = false ]; then
        CUR_BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/brightness)
        if [ "${CUR_BRIGHTNESS}" != "${BRIGHTNESS}" ]; then
            BRIGHTNESS=${CUR_BRIGHTNESS}
            echo "$(date) - DISPLAY - Setting brightness to $(echo ${BRIGHTNESS} |sudo tee /sys/class/backlight/card1-eDP-2-backlight/brightness)"
        fi
    fi
}

function duo-watch-display-backlight() {
    while true; do
        inotifywait -e modify /sys/class/backlight/intel_backlight/brightness >/dev/null 2>&1
        duo-sync-display-backlight
    done
}

function duo-watch-wifi() {
    while read -r LINE; do
        sleep 1
        . /tmp/duo/status
        if [ "${KEYBOARD_ATTACHED}" = true ]; then
            if [[ "${LINE}" = *"<true>"* ]]; then
                WIFI_BEFORE=enabled
            else
                WIFI_BEFORE=disabled
            fi
            echo "$(date) - NETWORK - WIFI: ${WIFI_BEFORE}"
            duo-set-status
        fi
    done < <(gdbus monitor -y -d org.freedesktop.NetworkManager | grep --line-buffered WirelessEnabled)
}

function duo-watch-bluetooth() {
    while read -r LINE; do
        sleep 1
        . /tmp/duo/status
        if [ "${KEYBOARD_ATTACHED}" = true ]; then
            if [[ "${LINE}" = *"<true>"* ]]; then
                BLUETOOTH_BEFORE=unblocked
            else
                BLUETOOTH_BEFORE=blocked
            fi
            echo "$(date) - NETWORK - Bluetooth: ${BLUETOOTH_BEFORE}"
            duo-set-status
        fi
    done < <(gdbus monitor -y -d org.bluez | grep --line-buffered "'Powered':")
}

function duo-watch-lock() {
    while read -r LINE; do
        sleep 1
        echo "$(date) - DEBUG - ${LINE}"
        . /tmp/duo/status
        if [ "${KEYBOARD_ATTACHED}" = true ]; then
            if [[ "${LINE}" = *"<true>"* ]]; then
                BLUETOOTH_BEFORE=unblocked
            else
                BLUETOOTH_BEFORE=blocked
            fi
            echo "$(date) - NETWORK - Bluetooth: ${BLUETOOTH_BEFORE}"
            duo-set-status
            duo-check-monitor
        fi
    done < <(gdbus monitor -y -d org.freedesktop.login1 | grep --line-buffered "LockedHint")
}

function duo-check-monitor() {
    . /tmp/duo/status
    KEYBOARD_ATTACHED=false
    if [ -n "$(lsusb | grep 'Zenbook Duo Keyboard')" ]; then
        KEYBOARD_ATTACHED=true
    else
        # The docked keyboard can drop off USB for ~3s after resume; don't treat that as a detach.
        sleep 5
        if [ -n "$(lsusb | grep 'Zenbook Duo Keyboard')" ]; then
            echo "$(date) - MONITOR - Keyboard briefly disconnected, ignoring"
            KEYBOARD_ATTACHED=true
        fi
    fi
    MONITOR_COUNT=$(gdctl show | grep 'Logical monitor #' | wc -l)
    duo-set-status
    echo "$(date) - MONITOR - WIFI before: ${WIFI_BEFORE}, Bluetooth before: ${BLUETOOTH_BEFORE}"
    echo "$(date) - MONITOR - Keyboard attached: ${KEYBOARD_ATTACHED}, Monitor count: ${MONITOR_COUNT}"
    if [ ${KEYBOARD_ATTACHED} = true ]; then
        echo "$(date) - MONITOR - Keyboard attached"
        if [ "${WIFI_BEFORE}" = enabled ]; then
            echo "$(date) - MONITOR - Turning on WIFI"
            nmcli radio wifi on
        fi
        if [ "${BLUETOOTH_BEFORE}" = unblocked ]; then
            echo "$(date) - MONITOR - Turning on Bluetooth"
            rfkill unblock bluetooth
        else
            echo "$(date) - MONITOR - Turning off Bluetooth"
            rfkill block bluetooth
        fi
        if ((${MONITOR_COUNT} > 1)); then
            echo "$(date) - MONITOR - Disabling bottom monitor"
            gdctl set --logical-monitor --primary --scale ${SCALE} --monitor eDP-1
            NEW_MONITOR_COUNT=$(gdctl show | grep 'Logical monitor #' | wc -l)
            if ((${NEW_MONITOR_COUNT} == 1)); then
                MESSAGE="Disabled bottom display"
            else
                MESSAGE="ERROR: Bottom display still on"
            fi
            notify-send -a "Zenbook Duo" -t 1000 --hint=int:transient:1 -i "preferences-desktop-display" "${MESSAGE}"
        fi
    else
        echo "$(date) - MONITOR - Keyboard detached"
        if [ "${WIFI_BEFORE}" = enabled ]; then
            echo "$(date) - MONITOR - Turning on WIFI"
            nmcli radio wifi on
        fi
        echo "$(date) - MONITOR - Turning on Bluetooth"
        rfkill unblock bluetooth
        if ((${MONITOR_COUNT} < 2)); then
            echo "$(date) - MONITOR - Enabling bottom monitor"
            gdctl set --logical-monitor --primary --scale ${SCALE} --monitor eDP-1 --logical-monitor --scale ${SCALE} --monitor eDP-2 --below eDP-1
            NEW_MONITOR_COUNT=$(gdctl show | grep 'Logical monitor #' | wc -l)
            if ((${NEW_MONITOR_COUNT} == 2)); then
                MESSAGE="Enabled bottom display"
            else
                MESSAGE="ERROR: Bottom display still off"
            fi
            notify-send -a "Zenbook Duo" -t 1000 --hint=int:transient:1 -i "preferences-desktop-display" "${MESSAGE}"
        fi
    fi
}

function duo-watch-monitor() {
    while true; do
        echo "$(date) - MONITOR - Waiting for USB event"
        inotifywait -e attrib /dev/bus/usb/*/ >/dev/null 2>&1
        duo-check-monitor
    done
}

function duo-cli() {
    . /tmp/duo/status
    case "${1}" in
    pre|hibernate|shutdown)
        echo "$(date) - ACPI - $@"
    ;;
    post|thaw|boot)
        echo "$(date) - ACPI - $@"
        duo-check-monitor
    ;;
    left-up)
        echo "$(date) - ROTATE - Left-up"
        if [ ${KEYBOARD_ATTACHED} = true ]; then
            gdctl set --logical-monitor --primary --scale ${SCALE} --monitor eDP-1 --transform 90
        else
            gdctl set --logical-monitor --primary --scale ${SCALE} --monitor eDP-1 --transform 90 --logical-monitor --scale ${SCALE} --monitor eDP-2 --left-of eDP-1 --transform 90
        fi

        ;;
    right-up)
        echo "$(date) - ROTATE - Right-up"
        if [ ${KEYBOARD_ATTACHED} = true ]; then
            gdctl set --logical-monitor --primary --scale ${SCALE} --monitor eDP-1 --transform 270
        else
            gdctl set --logical-monitor --primary --scale ${SCALE} --monitor eDP-1 --transform 270 --logical-monitor --scale ${SCALE} --monitor eDP-2 --right-of eDP-1 --transform 270
        fi
        ;;
    bottom-up)
        echo "$(date) - ROTATE - Bottom-up"
        if [ ${KEYBOARD_ATTACHED} = true ]; then
            gdctl set --logical-monitor --primary --scale ${SCALE} --monitor eDP-1 --transform 180
        else
            gdctl set --logical-monitor --primary --scale ${SCALE} --monitor eDP-1 --transform 180 --logical-monitor --scale ${SCALE} --monitor eDP-2 --above eDP-1 --transform 180
        fi
        ;;
    normal)
        echo "$(date) - ROTATE - Normal"
        if [ ${KEYBOARD_ATTACHED} = true ]; then
            gdctl set --logical-monitor --primary --scale ${SCALE} --monitor eDP-1
        else
            gdctl set --logical-monitor --primary --scale ${SCALE} --monitor eDP-1 --logical-monitor --scale ${SCALE} --monitor eDP-2 --below eDP-1
        fi
        ;;
    *)
        echo "$(date) - UNKNOWN - $@"
        ;;
    esac
}

function duo-watch-rotate() {
    echo "$(date) - ROTATE - Watching"
    monitor-sensor --accel |
        stdbuf -oL grep "Accelerometer orientation changed:" |
        stdbuf -oL awk '{print $4}' |
        xargs -I '{}' stdbuf -oL "$0" '{}' 2>/dev/null
}

function duo-wait-display-config() {
    # At login this can start before Mutter's DisplayConfig is on the bus; gdctl would then
    # report 0 monitors and the bottom screen would be left however Mutter restores it.
    for _ in $(seq 60); do
        if gdctl show >/dev/null 2>&1; then
            sleep 2  # let Mutter finish applying its stored layout
            return
        fi
        sleep 1
    done
    echo "$(date) - MONITOR - Timed out waiting for Mutter DisplayConfig"
}

function duo-watch-resume() {
    # Mutter may restore its stored two-screen layout on resume, and the system-sleep hook runs
    # as root outside the session, so recheck from here once the session is back.
    while read -r LINE; do
        if [[ "${LINE}" = *"(false,)"* ]]; then
            sleep 3
            echo "$(date) - MONITOR - Resumed"
            duo-check-monitor
        fi
    done < <(gdbus monitor -y -d org.freedesktop.login1 -o /org/freedesktop/login1 | grep --line-buffered PrepareForSleep)
}

function main() {
    duo-wait-display-config
    duo-check-monitor
    duo-watch-monitor &
    duo-watch-rotate &
    duo-watch-display-backlight &
    duo-watch-wifi &
    duo-watch-resume &
    duo-watch-bluetooth
}

if [ -z "${1}" ]; then
    main | tee -a /tmp/duo/duo.log
else
    duo-cli $@ | tee -a /tmp/duo/duo.log
    if [ "${USER}" = root ]; then
        chmod a+w /tmp/duo /tmp/duo/duo.log /tmp/duo/status
    fi
fi
