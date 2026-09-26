#!/usr/bin/python3
"""Userspace stand-in for hid-asus on the ASUS Zenbook Duo (UX8406) keyboard.

The kernel binds this keyboard to hid-generic, which never sends the ASUS init
handshake and drops the vendor (usage page 0xFF31, report 0x5a) hotkeys. This
daemon initialises the keyboard whenever it appears and re-emits those hotkeys
through a uinput device so the desktop handles them.

Env: FNLOCK=off (default; top row = hotkeys, Fn = F1-F12) or FNLOCK=on.
     BACKLIGHT=0-3 keyboard backlight level set on connect (default 1).
"""
import fcntl, glob, os, struct, sys, time

REPORT_ID = 0x5A
FNLOCK = os.environ.get("FNLOCK", "off") == "on"
BACKLIGHT = int(os.environ.get("BACKLIGHT", "1"))

# Vendor code -> Linux input key code (linux/input-event-codes.h)
KEYMAP = {
    0x10: 224,  # F5  KEY_BRIGHTNESSDOWN
    0x20: 225,  # F6  KEY_BRIGHTNESSUP
    0x7C: 248,  # F9  KEY_MICMUTE
    0x7E: 585,  # F10 KEY_EMOJI_PICKER
    0x86: 148,  # F11 KEY_PROG1 (MyASUS)
    0x9C: 149,  # F8  KEY_PROG2 (screen swap; bind it in GNOME if wanted)
    0x6B: 530,  # KEY_TOUCHPAD_TOGGLE
}
BACKLIGHT_KEYS = {0xC7: "cycle", 0xC4: "up", 0xC5: "down"}  # handled here, not by the desktop
FNLOCK_KEY = 0x4E  # Fn+Esc on other ASUS keyboards


def log(*a):
    print(*a, flush=True)


def ioc(direction, nr, size):
    return (direction << 30) | (size << 16) | (ord("U") << 8) | nr


class VirtualKeyboard:
    def __init__(self):
        self.fd = os.open("/dev/uinput", os.O_WRONLY | os.O_NONBLOCK)
        fcntl.ioctl(self.fd, ioc(1, 100, 4), 1)  # UI_SET_EVBIT EV_KEY
        for code in KEYMAP.values():
            fcntl.ioctl(self.fd, ioc(1, 101, 4), code)  # UI_SET_KEYBIT
        setup = struct.pack("HHHH80sI", 0x03, 0x0B05, 0x1B2C, 1, b"Zenbook Duo Keyboard Hotkeys", 0)
        fcntl.ioctl(self.fd, ioc(1, 3, len(setup)), setup)  # UI_DEV_SETUP
        fcntl.ioctl(self.fd, 0x5501)  # UI_DEV_CREATE

    def tap(self, code):
        for value in (1, 0):
            os.write(self.fd, struct.pack("llHHi", 0, 0, 0x01, code, value))  # EV_KEY
            os.write(self.fd, struct.pack("llHHi", 0, 0, 0x00, 0, 0))  # EV_SYN


def find_vendor_hidraw():
    for dev in glob.glob("/sys/bus/hid/devices/*:0B05:*"):
        try:
            if b"\x06\x31\xff" in open(f"{dev}/report_descriptor", "rb").read():
                return "/dev/" + os.listdir(f"{dev}/hidraw")[0]
        except OSError:
            continue
    return None


def set_feature(fd, data):
    buf = bytearray(bytes(data).ljust(16, b"\x00"))
    fcntl.ioctl(fd, (3 << 30) | (len(buf) << 16) | (ord("H") << 8) | 0x06, buf)  # HIDIOCSFEATURE


def set_fnlock(fd, on):
    set_feature(fd, [REPORT_ID, 0xD0, 0x4E, int(on)])


def set_backlight(fd, level):
    set_feature(fd, [REPORT_ID, 0xBA, 0xC5, 0xC4, level])


def serve(path, kbd):
    global FNLOCK
    fd = os.open(path, os.O_RDWR)
    try:
        set_feature(fd, [REPORT_ID, *b"ASUS Tech.Inc.", 0])
        set_feature(fd, [REPORT_ID, 0xBA, 0xC5, 0xC4])  # enable backlight control
        set_fnlock(fd, FNLOCK)
        backlight = BACKLIGHT
        set_backlight(fd, backlight)
        log(f"initialised {path} (fnlock {'on' if FNLOCK else 'off'})")
        while True:
            report = os.read(fd, 64)
            if len(report) < 2 or report[0] != REPORT_ID or report[1] == 0:
                continue
            code = report[1]
            if code in KEYMAP:
                kbd.tap(KEYMAP[code])
            elif code in BACKLIGHT_KEYS:
                action = BACKLIGHT_KEYS[code]
                backlight = (backlight + 1) % 4 if action == "cycle" else \
                    min(3, backlight + 1) if action == "up" else max(0, backlight - 1)
                set_backlight(fd, backlight)
            elif code == FNLOCK_KEY:
                FNLOCK = not FNLOCK
                set_fnlock(fd, FNLOCK)
                log(f"fnlock {'on' if FNLOCK else 'off'}")
            else:
                log(f"unmapped vendor code 0x{code:02x}")
    finally:
        os.close(fd)


def main():
    kbd = VirtualKeyboard()
    while True:
        path = find_vendor_hidraw()
        if path:
            try:
                serve(path, kbd)
            except OSError as e:
                log(f"lost {path}: {e}")
        time.sleep(2)


if __name__ == "__main__":
    sys.exit(main())
