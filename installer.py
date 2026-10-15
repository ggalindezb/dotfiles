#!/usr/bin/env python3
#
# Config installer script
# Maintainer:       Gerardo Galindez
# Created:          2019/08/09
# Last Updated:     2026/07/31

import os
import platform
import sys
import shutil
from pathlib import Path

class Config:
    CORE_APPS = ['alacritty', 'fish', 'git', 'nvim', 'tmux', 'bash', 'zsh']
    CLI_UTILS = ['fzf', 'rg', 'fdfind', 'batcat', 'eza', 'delta', 'zoxide', 'direnv', 'httpie', 'jq', 'htop', 'tree', 'tree-sitter']
    OPTIONAL_TOOLS = ['gh', 'tldr', 'procs', 'ctop', 'docker', 'aws', 'gcloud']

    def __init__(self):
        self.home = Path.home()
        self.dotfiles_dir = Path(__file__).resolve().parent
        self.set_environment_info()

    def set_environment_info(self):
        uname = os.uname()
        self.os_type = uname.sysname

    def package_installed(self, name):
        if shutil.which(name):
            return True
        # Check ~/.asdf/shims and ~/.local/bin
        for p in [self.home / '.asdf' / 'shims', self.home / '.local' / 'bin']:
            if (p / name).exists():
                return True
        return False

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
        print(f'Dotfiles directory: {self.dotfiles_dir}')
        print()

    def platform_info(self):
        self.print_subheader('Platform')
        uname = os.uname()

        print(f'OS Type: {uname.sysname}')
        print(f'Kernel: {uname.release}')
        print(f'Architecture: {uname.machine}')
        print()

    def _print_package_category(self, category_name, package_list):
        print(f'\n  [{category_name}]')
        for package in package_list:
            if self.package_installed(package):
                print(f'    [✓] {package:15} : Installed')
            else:
                print(f'    [✗] {package:15} : Not Installed')

    def package_info(self):
        self.print_subheader('Packages & Tooling Status')
        self._print_package_category('Core Shells & Editors', self.CORE_APPS)
        self._print_package_category('CLI Utilities', self.CLI_UTILS)
        self._print_package_category('Optional Cloud & Dev Tools', self.OPTIONAL_TOOLS)
        print()

    def print_subheader(self, title):
        print(f'-> {title}')
        print('-' * 20)

    def get_symlink_mappings(self):
        fish_config = 'config.fish.linux' if self.os_type == 'Linux' else 'config.fish.mac'
        
        mappings = [
            (self.dotfiles_dir / 'bash' / 'bashrc', self.home / '.bashrc'),
            (self.dotfiles_dir / 'zsh' / 'zshrc', self.home / '.zshrc'),
            (self.dotfiles_dir / 'git' / 'gitconfig', self.home / '.gitconfig'),
            (self.dotfiles_dir / 'tmux' / 'tmux.conf', self.home / '.tmux.conf'),
            (self.dotfiles_dir / 'nvim' / 'init.lua', self.home / '.config' / 'nvim' / 'init.lua'),
            (self.dotfiles_dir / 'nvim' / 'lua', self.home / '.config' / 'nvim' / 'lua'),
            (self.dotfiles_dir / 'fish' / fish_config, self.home / '.config' / 'fish' / 'config.fish'),
            (self.dotfiles_dir / 'fish' / 'functions', self.home / '.config' / 'fish' / 'functions'),
            (self.dotfiles_dir / 'alacritty' / 'alacritty.sakura.toml', self.home / '.config' / 'alacritty' / 'alacritty.toml'),
        ]
        return mappings

    def install(self):
        self.print_subheader('Installing Symlinks')
        mappings = self.get_symlink_mappings()

        for src, dst in mappings:
            if not src.exists():
                print(f'  [!] Source path does not exist: {src}')
                continue

            # Ensure parent directory exists
            dst.parent.mkdir(parents=True, exist_ok=True)

            if dst.is_symlink():
                target = dst.readlink()
                if target == src:
                    print(f'  [=] Symlink already up-to-date: {dst} -> {src}')
                    continue
                else:
                    print(f'  [~] Updating existing symlink: {dst} (was -> {target})')
                    dst.unlink()
            elif dst.exists():
                backup = dst.with_suffix(dst.suffix + '.bak')
                print(f'  [*] Backing up existing file: {dst} -> {backup}')
                if backup.exists():
                    if backup.is_dir() and not backup.is_symlink():
                        shutil.rmtree(backup)
                    else:
                        backup.unlink()
                dst.rename(backup)

            dst.symlink_to(src)
            print(f'  [+] Created symlink: {dst} -> {src}')

        print('\nDone installing dotfiles symlinks!')

if __name__ == '__main__':
    config = Config()
    config.print_info()
    if '--install' in sys.argv or '-i' in sys.argv:
        config.install()
    else:
        print("Run `python3 installer.py --install` to create symlinks.")

