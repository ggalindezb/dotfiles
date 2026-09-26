# Zenbook Duo (UX8406MA) Linux support

Keyboard fixes plus dual-screen handling for the ASUS Zenbook Duo 2024 on Ubuntu/GNOME.

## Install / uninstall

```sh
sudo ./install.sh     # or: pkexec /path/to/install.sh
systemctl --user restart zenbook-duo-user.service
sudo ./uninstall.sh
```

`install.sh` is idempotent: rerun it after editing any file here.

## Files

| File | Installed to | Purpose |
|---|---|---|
| `zenbook-kbd.py` | `/usr/local/lib/zenbook-kbd/` | Keyboard daemon (see below) |
| `zenbook-kbd.service` | `/etc/systemd/system/` | Runs the daemon as root. Settings: `FNLOCK`, `BACKLIGHT` |
| `zenbook-kbd-resume.service` | `/etc/systemd/system/` | Restarts the daemon after resume; it is stopped over sleep so the keyboard stays on USB |
| `duo.sh` | `/usr/local/bin/duo` | Bottom screen on/off with keyboard, rotation, brightness sync, wifi/bt restore |
| `zenbook-duo.service` | `/etc/systemd/system/` | `duo boot` / `duo shutdown` |
| `zenbook-duo-user.service` | `/etc/systemd/user/` (global) | `duo` watcher in each session |
| — | `/usr/lib/systemd/system-sleep/duo` | Symlink: `duo pre` / `duo post` on suspend |
| — | `/etc/sudoers.d/zenbook-duo` | Lets `duo` write the bottom screen's brightness |
| `LICENSE-duo` | not installed | GPL-3.0 license for `duo.sh` |
| `probe.py` | not installed | Diagnostic: dumps raw keyboard reports (`sudo ./probe.py [on\|off]`) |

## Why the keyboard daemon exists

The detachable keyboard (USB `0b05:1b2c`) isn't in the kernel's `hid-asus` ID table, so it
binds to `hid-generic`. That driver never sends the ASUS init handshake (`0x5a "ASUS Tech.Inc."`),
so Fn and Fn-lock do nothing, and it drops the vendor hotkeys (usage page `0xFF31`, report `0x5a`).

`zenbook-kbd.py` does what `hid-asus` would: initialises the keyboard whenever it appears, sets
Fn-lock, re-emits vendor hotkeys through uinput, and drives the keyboard backlight.

| Key | Vendor code | Emitted as |
|---|---|---|
| F4 | `c7` | cycles keyboard backlight (handled in the daemon) |
| F5 / F6 | `10` / `20` | `KEY_BRIGHTNESSDOWN` / `KEY_BRIGHTNESSUP` |
| F8 | `9c` | `KEY_PROG2` (unbound; assign in GNOME) |
| F9 | `7c` | `KEY_MICMUTE` |
| F10 | `7e` | `KEY_EMOJI_PICKER` |
| F11 | `86` | `KEY_PROG1` (MyASUS; unbound) |
| Fn+Esc | `4e` (assumed) | toggles Fn-lock |

F1–F3 (volume) and F7 (Win+P) use standard HID and work without the daemon.
Unknown codes are logged: `journalctl -u zenbook-kbd -b`.

## Dependencies

`python3` (stdlib only), systemd, kernel `uinput` + `hidraw` (built into Ubuntu kernels).
`duo` needs `inotify-tools usbutils mutter-common-bin iio-sensor-proxy`; `install.sh` installs them.

## Origins

`duo.sh` comes from [Fmstrat/zenbook-duo-linux](https://github.com/Fmstrat/zenbook-duo-linux),
commit [`385395d`](https://github.com/Fmstrat/zenbook-duo-linux/commit/385395dccefd28f93532a2e558931eda7374fd24)
(2025-05-08), GPL-3.0 (`LICENSE-duo`). Changes, also listed in its header:

- Removed the keyboard-backlight code. It needed a passwordless-root sudo rule for a script in a
  world-writable `/tmp` directory, and it fought with `zenbook-kbd`.
- `DEFAULT_SCALE=1.5`.

The removed backlight code was originally written by Alesya Huzik for
[alesya-h/zenbook-duo-2024-ux8406ma-linux](https://github.com/alesya-h/zenbook-duo-2024-ux8406ma-linux),
whose `0x5a 0xba 0xc5 0xc4 <level>` backlight command `zenbook-kbd.py` also uses.
The service files and `install.sh` duo section are adapted from Fmstrat's `setup.sh`.
