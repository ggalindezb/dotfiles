#!/bin/sh
# Remove everything install.sh set up. Run as root. Packages are left installed.
systemctl disable --now zenbook-kbd.service zenbook-duo.service
systemctl --global disable zenbook-duo-user.service
rm -f /etc/systemd/system/zenbook-kbd.service /etc/systemd/system/zenbook-duo.service \
      /etc/systemd/user/zenbook-duo-user.service
rm -rf /usr/local/lib/zenbook-kbd /etc/modules-load.d/zenbook-kbd-*.conf
rm -f /usr/local/bin/duo /usr/lib/systemd/system-sleep/duo /etc/sudoers.d/zenbook-duo
systemctl daemon-reload
echo "Log out and back in to stop running duo session handlers."
