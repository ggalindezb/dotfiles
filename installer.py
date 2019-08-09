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

CONFIGS = ['bash', 'fish', 'git', 'tlp', 'tmux', 'vim', 'zsh']

def print_info():
    print('=' * 80)
    print('- Runtime info')
    print('=' * 80)
    runtime_info()
    platform_info()
    package_info()

def runtime_info():
    print(f'Runtime: {sys.version}')
    print(f'Arguments: {sys.argv}')
    print()

def platform_info():
    print_subheader('Platform')
    uname = os.uname()

    print(f'OS Type: {uname.sysname}')
    print(f'Kernel: {uname.release}')
    print(f'Architecture: {uname.machine}')
    print()

def package_info():
    print_subheader('Packages')

    for package in CONFIGS:
        if package_installed(package):
            print(f'- {package}: Installed')
        else:
            print(f'- {package}: Missing')
    print()

# Utility functions, should be private

def print_subheader(title):
    print(f'-> {title}')
    print('-' * 20)

def package_installed(name):
    return True if shutil.which(name) else False


print_info()
