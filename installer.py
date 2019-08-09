#!/usr/bin/env python3
#
# Installer script
#
# Maintainer:	Gerardo Galindez
# Created:          2019/08/09

# Roadmap:
# - Check if Linux or OS X using uname
# - Probe for installed stuff
# - Check for arguments, maybe?
# - Create the config directories
# - Move files into their places

import os
import platform
import sys
import shutil

class Config:
    CONFIGS = ['bash', 'fish', 'git', 'tlp', 'tmux', 'vim', 'zsh']

    def __init__(self):
        uname = os.uname()
        self.os_type = uname.sysname

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
