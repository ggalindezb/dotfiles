#!/usr/bin/env python3
#
# Config installer script
# Maintainer:       Gerardo Galindez
# Created:          2019/08/09
# Last Updated:     2020/02/28

# Roadmap:
# - Check Linux distro
# - Probe for installed stuff
# - Check for arguments, maybe?
# - Create the config directories
# - Move files into their places
# - Install Rust and Rust dependencies

# Commands that need to run in Ubuntu. All of this needs an osx port
# Toolkit
# sudo apt install ack cowsay curl firefox fish fortune git gnupg2 neovim tmux tree zsh

# Gnome tweaks
# sudo apt install chrome-gnome-shell dkms gnome-tweak-tool
# sudo apt remove gnome-shell-extension-ubuntu-dock

# Package manager tasks
# sudo apt update sudo apt upgrade sudo apt autoremove

# Once finished, change shells
# chsh -s /usr/bin/fish

import os
import platform
import sys
import shutil

class Config:
    CONFIGS = ['alacritty', 'fish', 'git', 'nvim', 'tmux']

    def __init__(self):
        self.set_environment_info()
        self.set_configuration_info()

    # Read the OS context and the currently available packages
    def set_environment_info(self):
        uname = os.uname()
        self.os_type = uname.sysname

    # Read the config params
    def set_configuration_info(self):
        return 0

    def package_installed(self, name):
        return True if shutil.which(name) else False

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

config = Config()
config.print_info()
