#!/usr/bin/env python3
#
# Config installer script
# Maintainer:       Gerardo Galindez
# Created:          2019/08/09
# Last Updated:     2026/10/15
#
# A single `--install` run takes a fresh machine to a working setup. Every step
# is idempotent: anything already in place is skipped, so it's safe to re-run.
# Without `--install` it only prints what it would do.

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import urllib.request
from pathlib import Path

LINUX = sys.platform.startswith('linux')
MAC = sys.platform == 'darwin'
# Release codename (e.g. resolute) for repos that publish one suite per Ubuntu release
CODENAME = next((l.split('=', 1)[1].strip().strip('"') for l in Path('/etc/os-release').read_text().splitlines()
                 if l.startswith('VERSION_CODENAME=')), '') if LINUX else ''

# """"""""""""""""""""""""""""""""""""""""""""""""
# -> Manifest
# """"""""""""""""""""""""""""""""""""""""""""""""
APT_PACKAGES = {
    'base': ['build-essential', 'curl', 'wget', 'git', 'gnupg', 'unzip', 'xz-utils', 'fontconfig'],
    'shells': ['fish', 'zsh', 'tmux', 'neovim', 'alacritty', 'starship'],
    'cli': ['fzf', 'ripgrep', 'fd-find', 'bat', 'eza', 'git-delta', 'zoxide', 'direnv', 'httpie',
            'jq', 'htop', 'tree', 'duf', 'ack', 'gh'],
    'fun': ['fortune-mod', 'cowsay', 'lolcat'],
    'virt': ['qemu-system-x86', 'qemu-utils', 'ovmf', 'virt-manager', 'virt-viewer', 'virtinst'],
    'desktop': ['claude-desktop', 'vlc', 'flatpak'],
    'net': ['tailscale'],
}

BREW_FORMULAS = ['fish', 'zsh', 'tmux', 'neovim', 'starship', 'fzf', 'ripgrep', 'fd', 'bat', 'eza',
                 'git-delta', 'zoxide', 'direnv', 'httpie', 'jq', 'htop', 'tree', 'duf', 'ack',
                 'gh', 'asdf', 'fortune', 'cowsay', 'lolcat']
BREW_CASKS = ['alacritty']

# Third party apt repositories, written as deb822 .sources files
# Key sources are URLs, or a path relative to the dotfiles dir for vendored keys.
APT_REPOS = [
    {'name': 'github-cli', 'uri': 'https://cli.github.com/packages/', 'suite': 'stable',
     'keyring': '/etc/apt/keyrings/githubcli-archive-keyring.gpg',
     'key': 'https://cli.github.com/packages/githubcli-archive-keyring.gpg'},
    {'name': 'claude-desktop', 'uri': 'https://downloads.claude.ai/claude-desktop/apt/stable/', 'suite': 'stable',
     'keyring': '/usr/share/keyrings/claude-desktop-archive-keyring.asc',
     'key': 'apt/claude-desktop-archive-keyring.asc'},
    {'name': 'tailscale', 'uri': 'https://pkgs.tailscale.com/stable/ubuntu', 'suite': CODENAME,
     'keyring': '/usr/share/keyrings/tailscale-archive-keyring.gpg',
     'key': f'https://pkgs.tailscale.com/stable/ubuntu/{CODENAME}.noarmor.gpg'},
]

# (snap name, needs --classic, command that means it's already installed)
SNAPS = [
    ('slack', True, 'slack'),
    ('spotify', False, 'spotify'),
]

# Flathub apps, installed per user so they don't need sudo
FLATPAKS = [
    'me.timschneeberger.jdsp4linux',  # JamesDSP
]

# Global npm packages, installed with asdf's node: (package, binary)
NPM_PACKAGES = [('tree-sitter-cli', 'tree-sitter'), ('@ast-grep/cli', 'ast-grep')]

# Built with asdf's rust: (crate, binary)
# Fish completions the tools don't install themselves: (command, generator). A generator is the command that
# prints them, or the name of an Installer method that builds them. dust and bandwhich have nothing to build from
FISH_COMPLETIONS = [
    ('asdf', ['asdf', 'completion', 'fish']),
    ('tree-sitter', ['tree-sitter', 'complete', '--shell', 'fish']),
    ('ast-grep', ['ast-grep', 'completions', 'fish']),
    ('procs', ['procs', '--gen-completion-out', 'fish']),
    ('http', 'httpie_completions'),     # Shipped in httpie's repo, not in the package
    ('https', 'https_completions'),
    ('claude', 'commander_completions'),  # No generator, built from its --help
]

CARGO_CRATES = [('du-dust', 'dust'), ('procs', 'procs'), ('tokei', 'tokei'), ('bandwhich', 'bandwhich')]

# Nerd Fonts release archive name -> file prefix once installed
NERD_FONTS = {
    '0xProto': '0xProtoNerdFont',
    'FiraCode': 'FiraCodeNerdFont',
    'Hack': 'HackNerdFont',
    'RobotoMono': 'RobotoMonoNerdFont',
    'SourceCodePro': 'SauceCodeProNerdFont',
    'SpaceMono': 'SpaceMonoNerdFont',
}
NERD_FONTS_URL = 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/{name}.tar.xz'

# GNOME Shell extensions from extensions.gnome.org, and bundled ones to turn off
GNOME_EXTENSIONS = [
    'hidetopbar@mathieu.bidon.ca',          # Hide Top Bar
    'azwallpaper@azwallpaper.gitlab.com',   # Wallpaper Slideshow
    'caffeine@patapon.info',                # Caffeine
    'tilingshell@ferrarodomenico.com',      # Tiling Shell
]
GNOME_EXTENSIONS_DISABLED = [
    'tiling-assistant@ubuntu.com',          # Conflicts with Tiling Shell
]

# Mostly for ssh to the other boxes. Twingate runs on top for work and owns DNS, so Tailscale keeps its hands off it
TAILSCALE_FLAGS = ['--accept-dns=false', '--ssh', '--accept-routes']

ASDF_RELEASE_URL = 'https://github.com/asdf-vm/asdf/releases/latest/download/'
TPM_REPO = 'https://github.com/tmux-plugins/tpm'

# Only used by the status report
STATUS = {
    'Core Shells & Editors': ['alacritty', 'ghostty', 'claude', 'fish', 'git', 'nvim', 'tmux', 'bash', 'zsh', 'starship'],
    'CLI Utilities': ['fzf', 'rg', 'fdfind', 'batcat', 'eza', 'delta', 'zoxide', 'direnv', 'http', 'jq',
                      'htop', 'tree', 'duf', 'dust', 'procs', 'tokei', 'tree-sitter', 'ast-grep', 'shellcheck',
                      'yq', 'sd'],
    'Dev Tools': ['cargo', 'asdf', 'node', 'gh'],
}


class Installer:
    STEPS = ['repos', 'packages', 'snaps', 'flatpaks', 'asdf', 'npm', 'cargo', 'completions', 'fonts', 'links', 'tmux', 'nvim', 'gnome',
             'tailscale']

    def __init__(self, dry_run):
        self.dry_run = dry_run
        self.home = Path.home()
        self.dotfiles_dir = Path(__file__).resolve().parent
        self.local_bin = self.home / '.local' / 'bin'
        self.failures = []

    # """"""""""""""""""""""""""""""""""""""""""""""""
    # -> Helpers
    # """"""""""""""""""""""""""""""""""""""""""""""""
    def which(self, name):
        if shutil.which(name):
            return True
        for p in [self.home / '.asdf' / 'shims', self.home / '.asdf' / 'bin', self.local_bin,
                  self.home / '.cargo' / 'bin', Path('/snap/bin')]:
            if (p / name).exists():
                return True
        return False

    def run(self, cmd, check=True, **kwargs):
        print(f'    $ {" ".join(str(c) for c in cmd)}')
        if self.dry_run:
            return True
        result = subprocess.run([str(c) for c in cmd], **kwargs)
        if result.returncode != 0 and check:
            self.failures.append(' '.join(str(c) for c in cmd))
        return result.returncode == 0

    def sudo(self, cmd, **kwargs):
        return self.run(['sudo'] + cmd, **kwargs)

    def download(self, url, dst):
        print(f'    $ download {url}')
        if not self.dry_run:
            urllib.request.urlretrieve(url, dst)

    def print_subheader(self, title):
        print(f'\n-> {title}')
        print('-' * 20)

    # """"""""""""""""""""""""""""""""""""""""""""""""
    # -> Status
    # """"""""""""""""""""""""""""""""""""""""""""""""
    def print_info(self):
        print('=' * 80)
        print('- Runtime info')
        print('=' * 80)
        uname = os.uname()
        print(f'Runtime: {sys.version.split()[0]}')
        print(f'Dotfiles directory: {self.dotfiles_dir}')
        print(f'Platform: {uname.sysname} {uname.release} {uname.machine} ({uname.nodename})')
        self.print_subheader('Packages & Tooling Status')
        for category, names in STATUS.items():
            print(f'\n  [{category}]')
            for name in names:
                mark = '✓' if self.which(name) else '✗'
                print(f'    [{mark}] {name}')

    # """"""""""""""""""""""""""""""""""""""""""""""""
    # -> Steps
    # """"""""""""""""""""""""""""""""""""""""""""""""
    def step_repos(self):
        if not LINUX:
            return print('  [-] Not on apt, skipping')
        sources_dir = Path('/etc/apt/sources.list.d')
        existing = ''.join(f.read_text() for f in sources_dir.iterdir() if f.suffix in ('.list', '.sources'))
        for repo in APT_REPOS:
            if Path(repo['keyring']).exists() and repo['uri'].rstrip('/') in existing:
                print(f'  [=] {repo["name"]}')
                continue
            print(f'  [+] {repo["name"]}')
            self.sudo(['mkdir', '-p', '-m', '755', Path(repo['keyring']).parent])
            if repo['key'].startswith('https://'):
                with tempfile.TemporaryDirectory() as tmp:
                    key = Path(tmp) / 'key'
                    self.download(repo['key'], key)
                    self.sudo(['install', '-m', '644', key, repo['keyring']])
            else:
                self.sudo(['install', '-m', '644', self.dotfiles_dir / repo['key'], repo['keyring']])
            sources = (f'Types: deb\nURIs: {repo["uri"]}\nSuites: {repo["suite"]}\nComponents: main\n'
                       f'Signed-By: {repo["keyring"]}\n')
            self.sudo(['tee', sources_dir / f'{repo["name"]}.sources'], input=sources, text=True,
                      stdout=subprocess.DEVNULL)

    def step_packages(self):
        if MAC:
            return self.brew_packages()
        if not LINUX:
            return print('  [-] Unsupported platform, skipping')
        wanted = [p for group in APT_PACKAGES.values() for p in group]
        query = subprocess.run(['dpkg-query', '-W', '-f', '${Package} ${db:Status-Status}\n'],
                               capture_output=True, text=True).stdout
        installed = {l.split()[0] for l in query.splitlines() if l.endswith(' installed')}
        missing = [p for p in wanted if p not in installed]
        if not missing:
            return print(f'  [=] All {len(wanted)} apt packages installed')
        print(f'  [+] Missing: {" ".join(missing)}')
        self.sudo(['apt-get', 'update'])
        self.sudo(['apt-get', 'install', '-y'] + missing)

    def brew_packages(self):
        if not self.which('brew'):
            self.run(['/bin/bash', '-c',
                      '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'])
        self.run(['brew', 'install'] + BREW_FORMULAS)
        self.run(['brew', 'install', '--cask'] + BREW_CASKS)

    def step_snaps(self):
        if not LINUX or not self.which('snap'):
            return print('  [-] No snapd, skipping')
        for name, classic, command in SNAPS:
            if self.which(command):
                print(f'  [=] {name}')
                continue
            print(f'  [+] {name}')
            self.sudo(['snap', 'install', name] + (['--classic'] if classic else []))

    def step_flatpaks(self):
        if not LINUX or not self.which('flatpak'):
            return print('  [-] No flatpak, skipping')
        self.run(['flatpak', 'remote-add', '--user', '--if-not-exists', 'flathub',
                  'https://dl.flathub.org/repo/flathub.flatpakrepo'])
        installed = subprocess.run(['flatpak', 'list', '--user', '--app', '--columns=application'],
                                   capture_output=True, text=True).stdout.split()
        for app in FLATPAKS:
            if app in installed:
                print(f'  [=] {app}')
                continue
            print(f'  [+] {app}')
            self.run(['flatpak', 'install', '--user', '--noninteractive', 'flathub', app])

    def asdf_command(self):
        for candidate in [shutil.which('asdf'), self.home / '.asdf' / 'bin' / 'asdf', self.local_bin / 'asdf']:
            if candidate and Path(candidate).exists():
                return candidate
        return None

    def step_asdf(self):
        asdf = self.asdf_command()
        if asdf:
            print(f'  [=] asdf ({asdf})')
        elif LINUX:
            machine = {'x86_64': 'amd64', 'aarch64': 'arm64'}[os.uname().machine]
            print('  [+] asdf')
            tag = self.latest_release_tag(ASDF_RELEASE_URL)
            asdf = self.local_bin / 'asdf'
            with tempfile.TemporaryDirectory() as tmp:
                archive = Path(tmp) / 'asdf.tar.gz'
                self.download(f'{ASDF_RELEASE_URL}asdf-{tag}-linux-{machine}.tar.gz', archive)
                if not self.dry_run:
                    self.local_bin.mkdir(parents=True, exist_ok=True)
                    with tarfile.open(archive) as tar:
                        tar.extract('asdf', self.local_bin, filter='data')
        else:
            asdf = 'asdf'  # Installed by brew in the packages step

        # Plugins call back into `asdf` by name, which may not be on PATH yet on a fresh machine
        env = {**os.environ, 'PATH': os.pathsep.join([str(Path(asdf).parent), str(self.home / '.asdf' / 'shims'),
                                                      os.environ.get('PATH', '')])}
        tool_versions = self.dotfiles_dir / 'tool-versions'
        plugins = [l.split()[0] for l in tool_versions.read_text().splitlines() if l.strip()]
        listed = subprocess.run([asdf, 'plugin', 'list'], capture_output=True, text=True).stdout.split() \
            if Path(asdf).exists() else []
        for plugin in plugins:
            if plugin not in listed:
                self.run([asdf, 'plugin', 'add', plugin], env=env)
        # ~/.tool-versions is symlinked by the later links step, so read the repo copy directly
        self.run([asdf, 'install'], cwd=tool_versions.parent,
                 env={**env, 'ASDF_DEFAULT_TOOL_VERSIONS_FILENAME': tool_versions.name})

    def asdf_tool(self, tool):
        """asdf, run options and the bin dir of the tool's version (None until it's installed)"""
        asdf = self.asdf_command() or 'asdf'  # Not there yet on a fresh machine's dry run
        # Same as the asdf step: ~/.tool-versions isn't linked yet, so pick versions from the repo copy
        kwargs = {'cwd': self.dotfiles_dir, 'env': {**os.environ, 'ASDF_DEFAULT_TOOL_VERSIONS_FILENAME': 'tool-versions'}}
        where = subprocess.run([asdf, 'where', tool], capture_output=True, text=True, **kwargs) \
            if Path(asdf).exists() else None
        bin_dir = Path(where.stdout.strip()) / 'bin' if where and where.returncode == 0 else None
        # `asdf exec` doesn't put the tool on PATH, and npm and cargo builds call `node`/`rustc` by name
        if bin_dir:
            kwargs['env']['PATH'] = os.pathsep.join([str(bin_dir), kwargs['env'].get('PATH', '')])
        return asdf, kwargs, bin_dir

    def step_npm(self):
        asdf, kwargs, node_bin = self.asdf_tool('nodejs')
        missing = [package for package, binary in NPM_PACKAGES if not (node_bin and (node_bin / binary).exists())]
        if not missing:
            return print(f'  [=] All {len(NPM_PACKAGES)} npm packages installed')
        print(f'  [+] Missing: {" ".join(missing)}')
        # Packages like tree-sitter-cli fetch their binary in an install script, which newer npm won't run unless allowed
        self.run([asdf, 'exec', 'npm', 'install', '-g', f'--allow-scripts={",".join(missing)}'] + missing, **kwargs)
        self.run([asdf, 'reshim', 'nodejs'], **kwargs)

    def step_cargo(self):
        # asdf's rust keeps CARGO_HOME in its install dir, so crates land next to cargo and need a reshim
        asdf, kwargs, rust_bin = self.asdf_tool('rust')
        missing = [crate for crate, binary in CARGO_CRATES if not (rust_bin and (rust_bin / binary).exists())]
        if not missing:
            return print(f'  [=] All {len(CARGO_CRATES)} crates installed')
        print(f'  [+] Missing: {" ".join(missing)}')
        self.run([asdf, 'exec', 'cargo', 'install', '--locked'] + missing, **kwargs)
        self.run([asdf, 'reshim', 'rust'], **kwargs)

    def latest_release_tag(self, latest_download_url):
        # /releases/latest/download/ redirects to /releases/download/<tag>/
        latest = latest_download_url.replace('/latest/download/', '/latest')
        with urllib.request.urlopen(urllib.request.Request(latest, method='HEAD')) as response:
            return response.url.rstrip('/').rsplit('/', 1)[-1]

    def step_completions(self):
        # Regenerated on every run so they follow tool upgrades. Not versioned, they depend on the installed version
        completions_dir = self.home / '.config' / 'fish' / 'completions'
        env = {**os.environ, 'PATH': os.pathsep.join([str(self.local_bin), str(self.home / '.asdf' / 'shims'),
                                                      os.environ.get('PATH', '')])}
        for command, generator in FISH_COMPLETIONS:
            if not self.which(command):
                print(f'  [-] {command} not installed, skipping')
                continue
            dst = completions_dir / f'{command}.fish'
            source = ' '.join(generator) if isinstance(generator, list) else generator
            if self.dry_run:
                print(f'  [+] {dst} ({source})')
                continue
            try:
                if isinstance(generator, list):
                    result = subprocess.run(generator, capture_output=True, text=True, env=env, cwd=self.home)
                    text = result.stdout if result.returncode == 0 else ''
                else:
                    text = getattr(self, generator)(command, env)
            except Exception as error:  # A download or parse failing shouldn't stop the others
                print(f'  [!] {command}: {error}')
                text = ''
            if 'complete ' not in text:
                print(f'  [!] {command}: {source} gave no completions')
                self.failures.append(f'completions: {command}')
                continue
            if dst.exists() and dst.read_text() == text:
                print(f'  [=] {dst}')
                continue
            completions_dir.mkdir(parents=True, exist_ok=True)
            dst.write_text(text)
            print(f'  [+] {dst}')

    def httpie_completions(self, command, env):
        version = subprocess.run([command, '--version'], capture_output=True, text=True, env=env).stdout.strip()
        url = f'https://raw.githubusercontent.com/httpie/cli/{version}/extras/httpie-completion.fish'
        with urllib.request.urlopen(url) as response:
            return response.read().decode()

    def https_completions(self, command, env):
        # Fish autoloads by command name, so https needs its own file pointing at http's
        return 'complete -c https -w http\n'

    def commander_completions(self, command, env):
        """Fish completions from a Commander.js --help: top level flags and subcommands"""
        help_text = subprocess.run([command, '--help'], capture_output=True, text=True, env=env).stdout
        lines, out, section = help_text.splitlines(), [], None

        def describe(i, rest):
            # Descriptions wrap onto deeper indented lines; join them, then keep the first sentence
            parts = [rest.strip()]
            for following in lines[i + 1:]:
                if not following.startswith('    '):
                    break
                parts.append(following.strip())
            desc = re.split(r'(?<!e\.g)(?<!i\.e)\.\s', ' '.join(p for p in parts if p), maxsplit=1)[0].rstrip('.')
            desc = desc if len(desc) <= 80 else desc[:79].rstrip() + '…'
            return desc.replace('\\', '\\\\').replace("'", "\\'")

        for i, line in enumerate(lines):
            if line and not line.startswith(' '):
                section = line.rstrip(':')
                continue
            if section == 'Options':
                m = re.match(r'  (?:-(\w), )?((?:--[\w-]+(?:, )?)+)((?: [<\[][^>\]]*[>\]])*)(.*)$', line)
                if not m:
                    continue
                short, longs, value, rest = m.groups()
                flags = ''.join(f' -l {name}' for name in re.findall(r'--([\w-]+)', longs))
                flags = (f' -s {short}' if short else '') + flags + (' -r' if value.startswith(' <') else '')
                out.append(f"complete -c {command}{flags} -d '{describe(i, rest)}'")
            elif section == 'Commands':
                m = re.match(r'  ([\w-]+(?:\|[\w-]+)*)((?: [<\[][^>\]]*[>\]])*)(.*)$', line)
                if not m:
                    continue
                names, _, rest = m.groups()
                for name in names.split('|'):
                    out.append(f"complete -c {command} -n __fish_use_subcommand -f -a {name} -d '{describe(i, rest)}'")
        return '\n'.join(out) + '\n' if out else ''

    def step_fonts(self):
        fonts_dir = self.home / 'Library' / 'Fonts' if MAC else self.home / '.local' / 'share' / 'fonts' / 'NerdFonts'
        installed = [f.name for f in fonts_dir.glob('*')] if fonts_dir.exists() else []
        changed = False
        for name, prefix in NERD_FONTS.items():
            if any(f.startswith(prefix) for f in installed):
                print(f'  [=] {name}')
                continue
            print(f'  [+] {name}')
            changed = True
            with tempfile.TemporaryDirectory() as tmp:
                archive = Path(tmp) / f'{name}.tar.xz'
                self.download(NERD_FONTS_URL.format(name=name), archive)
                if not self.dry_run:
                    fonts_dir.mkdir(parents=True, exist_ok=True)
                    with tarfile.open(archive) as tar:
                        tar.extractall(fonts_dir, filter='data')
        if changed and LINUX:
            self.run(['fc-cache', '-f', fonts_dir])

    def get_symlink_mappings(self):
        fish_config = 'config.fish.mac' if MAC else 'config.fish.linux'
        mappings = [
            (self.dotfiles_dir / 'bash' / 'bashrc', self.home / '.bashrc'),
            (self.dotfiles_dir / 'zsh' / 'zshrc', self.home / '.zshrc'),
            (self.dotfiles_dir / 'git' / 'gitconfig', self.home / '.gitconfig'),
            (self.dotfiles_dir / 'tmux' / 'tmux.conf', self.home / '.tmux.conf'),
            (self.dotfiles_dir / 'tmux' / 'dir-icon.sh', self.home / '.config' / 'tmux' / 'dir-icon.sh'),
            (self.dotfiles_dir / 'tmux' / 'cmd-icon.sh', self.home / '.config' / 'tmux' / 'cmd-icon.sh'),
            (self.dotfiles_dir / 'tool-versions', self.home / '.tool-versions'),
            (self.dotfiles_dir / 'nvim' / 'init.lua', self.home / '.config' / 'nvim' / 'init.lua'),
            (self.dotfiles_dir / 'nvim' / 'lua', self.home / '.config' / 'nvim' / 'lua'),
            (self.dotfiles_dir / 'fish' / fish_config, self.home / '.config' / 'fish' / 'config.fish'),
            (self.dotfiles_dir / 'fish' / 'functions', self.home / '.config' / 'fish' / 'functions'),
            (self.dotfiles_dir / 'alacritty' / 'alacritty.sakura.toml', self.home / '.config' / 'alacritty' / 'alacritty.toml'),
            (self.dotfiles_dir / 'ghostty' / 'config', self.home / '.config' / 'ghostty' / 'config'),
            (self.dotfiles_dir / 'claude' / 'settings.json', self.home / '.claude' / 'settings.json'),
            (self.dotfiles_dir / 'claude' / 'statusline-command.sh', self.home / '.claude' / 'statusline-command.sh'),
            (self.dotfiles_dir / 'ssh' / 'config', self.home / '.ssh' / 'config'),
        ]
        host = os.uname().nodename
        # Per-device Ghostty overrides, picked up by `config-file = ?local`
        ghostty_host = self.dotfiles_dir / 'ghostty' / 'hosts' / host
        if ghostty_host.exists():
            mappings.append((ghostty_host, self.home / '.config' / 'ghostty' / 'local'))
        # Each device has its own whole Starship prompt; there's no include to share a base
        starship_host = self.dotfiles_dir / 'starship' / 'hosts' / f'{host}.toml'
        if starship_host.exists():
            mappings.append((starship_host, self.home / '.config' / 'starship.toml'))
        return mappings

    def step_links(self):
        for src, dst in self.get_symlink_mappings():
            if not src.exists():
                print(f'  [!] Source path does not exist: {src}')
                continue
            if dst.is_symlink() and dst.readlink() == src:
                print(f'  [=] {dst}')
                continue
            if self.dry_run:
                print(f'  [+] {dst} -> {src}')
                continue

            dst.parent.mkdir(parents=True, exist_ok=True)
            if dst.is_symlink():
                print(f'  [~] Updating existing symlink: {dst} (was -> {dst.readlink()})')
                dst.unlink()
            elif dst.exists():
                backup = dst.with_suffix(dst.suffix + '.bak')
                print(f'  [*] Backing up existing file: {dst} -> {backup}')
                if backup.is_dir() and not backup.is_symlink():
                    shutil.rmtree(backup)
                elif backup.exists() or backup.is_symlink():
                    backup.unlink()
                dst.rename(backup)

            dst.symlink_to(src)
            print(f'  [+] {dst} -> {src}')

        # ssh ignores a config others can write to, and git doesn't keep modes, so set them on every run
        if not self.dry_run:
            (self.home / '.ssh').chmod(0o700)
            (self.dotfiles_dir / 'ssh' / 'config').chmod(0o600)

    def step_tmux(self):
        tpm = self.home / '.tmux' / 'plugins' / 'tpm'
        if not tpm.exists():
            self.run(['git', 'clone', '--depth=1', TPM_REPO, tpm])
        self.run([tpm / 'bin' / 'install_plugins'], stdout=subprocess.DEVNULL)

    def step_nvim(self):
        # Install plugins at the versions pinned in nvim/lazy-lock.json
        self.run(['nvim', '--headless', '+Lazy! restore', '+qa'])

    def step_gnome(self):
        if not LINUX or 'GNOME' not in os.environ.get('XDG_CURRENT_DESKTOP', '') or not self.which('gnome-extensions'):
            return print('  [-] Not in a GNOME session, skipping')

        def listed(*flags):
            return subprocess.run(['gnome-extensions', 'list', *flags], capture_output=True, text=True).stdout.split()

        for uuid in GNOME_EXTENSIONS_DISABLED:
            if uuid in listed('--enabled'):
                print(f'  [-] Disabling {uuid}')
                self.run(['gnome-extensions', 'disable', uuid])

        # Ask the running shell to install, it loads the extension right away instead of on the next login.
        # GNOME asks for confirmation of each one. The reply sometimes gets lost even though the install went
        # through, so success is judged by the enable pass below.
        installed = listed()
        for uuid in GNOME_EXTENSIONS:
            if uuid in installed:
                continue
            print(f'  [+] {uuid} (confirm the GNOME dialog)')
            self.run(['gdbus', 'call', '--session', '--timeout', '600', '--dest', 'org.gnome.Shell',
                      '--object-path', '/org/gnome/Shell',
                      '--method', 'org.gnome.Shell.Extensions.InstallRemoteExtension', uuid], check=False)

        enabled = listed('--enabled')
        for uuid in GNOME_EXTENSIONS:
            if uuid in enabled:
                print(f'  [=] {uuid}')
            else:
                self.run(['gnome-extensions', 'enable', uuid])

    def step_tailscale(self):
        if not LINUX or not self.which('tailscale'):
            return print('  [-] No tailscale, skipping')
        user = os.environ.get('USER', '')

        def query(*args):
            return json.loads(subprocess.run(['tailscale', *args], capture_output=True, text=True).stdout or '{}')

        if query('debug', 'prefs').get('OperatorUser') == user:
            print(f'  [=] operator {user}')
        else:
            # Lets this user run tailscale without sudo, including the commands below
            print(f'  [+] operator {user}')
            self.sudo(['tailscale', 'set', f'--operator={user}'])

        if query('status', '--json').get('BackendState') == 'Running':
            print(f'  [=] logged in, applying {" ".join(TAILSCALE_FLAGS)}')
            self.run(['tailscale', 'set'] + TAILSCALE_FLAGS)
        else:
            print('  [+] login (open the URL it prints)')
            self.run(['tailscale', 'up'] + TAILSCALE_FLAGS)

    def install(self, steps):
        for step in steps:
            self.print_subheader(step.capitalize())
            try:
                getattr(self, f'step_{step}')()
            except Exception as error:  # Keep going, report at the end
                print(f'  [!] {error}')
                self.failures.append(f'{step}: {error}')

        print('\n' + '=' * 80)
        if self.dry_run:
            print('Dry run, nothing was changed. Run `python3 installer.py --install` to apply.')
        elif self.failures:
            print('Finished with failures:')
            for failure in self.failures:
                print(f'  [!] {failure}')
            sys.exit(1)
        else:
            print('All done! Open a new terminal to pick up the shell config.')


def parse_steps(value):
    steps = [s.strip() for s in value.split(',') if s.strip()]
    unknown = set(steps) - set(Installer.STEPS)
    if unknown:
        raise argparse.ArgumentTypeError(f'unknown step(s): {", ".join(sorted(unknown))}')
    return steps


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Install packages, tools and config symlinks.',
                                     epilog=f'Steps, in order: {", ".join(Installer.STEPS)}')
    parser.add_argument('-i', '--install', action='store_true', help='apply changes (default is a dry run)')
    parser.add_argument('--only', type=parse_steps, help='comma separated steps to run')
    parser.add_argument('--skip', type=parse_steps, default=[], help='comma separated steps to skip')
    args = parser.parse_args()
    sys.stdout.reconfigure(line_buffering=True)  # Keep our output in order with the commands'

    steps = [s for s in (args.only or Installer.STEPS) if s not in args.skip]
    installer = Installer(dry_run=not args.install)
    installer.print_info()
    installer.install(steps)
