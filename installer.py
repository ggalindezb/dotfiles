#!/usr/bin/env python3
#
# Config installer script
# Maintainer:       Gerardo Galindez
# Created:          2019/08/09
# Last Updated:     2020/02/28

# Roadmap:
# - Check if Linux or OS X using uname
# - Probe for installed stuff
# - Check for arguments, maybe?
# - Create the config directories
# - Move files into their places

# Commands that need to run in Ubuntu. All of this needs an osx port
# Toolkit
# sudo apt install ack cowsay curl firefox fish fortune git gnupg2 guake guake neovim terminator timelimit tlp tmux tree zsh

# Gnome tweaks
# sudo apt install chrome-gnome-shell dkms gnome-tweak-tool
# sudo apt remove gnome-shell-extension-ubuntu-dock

# Package manager tasks
# sudo apt update sudo apt upgrade sudo apt autoremove

# DisplayLink driver, missing actual driver download
# sudo ./displaylink-driver-5.2.14.run

# Chrome install, probably not needed here
# wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
# echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
# sudo apt-get update
# sudo apt-get install google-chrome-stable


# Once finished, change shells
# chsh -s /usr/bin/fish

import os
import platform
import sys
import shutil

class Config:
    CONFIGS = ['bash', 'fish', 'git', 'tlp', 'tmux', 'vim', 'zsh']

    def __init__(self):
        set_environment_info()
        set_configuration_info()

    # Read the OS context and the currently available packages
    def set_environment_info():
        uname = os.uname()
        self.os_type = uname.sysname

    # Read the config params
    def set_configuration_info():
        return 0;

    def print_info(self):
        print('=' * 80)
        print('- Runtime info')
        print('=' * 80)
        self.runtime_info()
        self.platform_info()
        self.package_info()

    def runtime_info(self):
        print(f'Runtime: {sys.version}')
        print(f'Arguments: {sys.argv}')
        print()

    def platform_info(self):
        self.print_subheader('Platform')
        uname = os.uname()

        print(f'OS Type: {uname.sysname}')
        print(f'Kernel: {uname.release}')
        print(f'Architecture: {uname.machine}')
        print()

    def package_info(self):
        self.print_subheader('Packages')

        for package in self.CONFIGS:
            if self.package_installed(package):
                print(f'- {package}: Installed')
            else:
                print(f'- {package}: Missing')
        print()

    def print_subheader(self, title):
        print(f'-> {title}')
        print('-' * 20)

    def package_installed(self, name):
        return True if shutil.which(name) else False


config = Config()
config.print_info()
