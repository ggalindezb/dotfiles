#!/usr/bin/env python3
"""Zenbook Duo keyboard probe: init + optional Fn-lock, then log raw reports from every keyboard interface.
Usage: probe.py [on|off]"""
import fcntl, glob, os, select, sys, time

devs = {}
for dev in sorted(glob.glob("/sys/bus/hid/devices/0003:0B05:1B2C.*")):
    if not os.path.isdir(f"{dev}/hidraw"):
        continue
    if os.path.basename(os.path.realpath(f"{dev}/driver")) == "hid-multitouch":
        continue  # touchpad: skip, too noisy
    node = "/dev/" + os.listdir(f"{dev}/hidraw")[0]
    vendor = b"\x06\x31\xff" in open(f"{dev}/report_descriptor", "rb").read()
    devs[os.open(node, os.O_RDWR | os.O_NONBLOCK)] = (node, dev.rsplit(".", 1)[1], vendor)

def set_feature(fd, data):
    buf = bytes(data).ljust(16, b"\x00")
    fcntl.ioctl(fd, (3 << 30) | (len(buf) << 16) | (ord("H") << 8) | 0x06, bytearray(buf))

vfd = next((fd for fd, (_, _, v) in devs.items() if v), None)
if vfd is None:
    sys.exit("ASUS vendor interface not found")
set_feature(vfd, b"\x5aASUS Tech.Inc.\x00")
set_feature(vfd, [0x5a, 0xba, 0xc5, 0xc4])
if len(sys.argv) > 1:
    set_feature(vfd, [0x5a, 0xd0, 0x4e, 1 if sys.argv[1] == "on" else 0])
    print(f"Fn-lock command sent: {sys.argv[1]}")
print("Listening on:", ", ".join(f"{n} (.{i}{' ASUS' if v else ''})" for n, i, v in devs.values()))
print("Don't touch the touchpad. Press Fn alone, then Fn+F1..F12, then F1..F12 without Fn. 25s...")
end = time.time() + 25
while time.time() < end:
    for fd in select.select(list(devs), [], [], 0.5)[0]:
        node, iface, _ = devs[fd]
        print(f".{iface}:", os.read(fd, 64).hex(" "), flush=True)
