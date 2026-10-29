# .dotfiles

Welcome to my personal config. If you know me personally, you know that I absolutely refuse to leave my terminal for
anything other than a web browser and a few electron apps. Terminals have been the fastest input/output interface to
deal with computers through the last few decades and a few generations of evolving technology.

This is the way.

This setup is custom tailored for me. Just like you wouldn't use anyone else's suit, this is not meant for you to clone,
set and forget but rather: I'm sharing what I do on a day to day basis and hopefully we can learn from each other.

## Installation

One run sets up a machine: apt repos and packages (Homebrew on macOS), snaps, Flathub apps, asdf with the
runtimes in `tool-versions`, global npm packages, cargo crates, Nerd Fonts, config symlinks, tmux plugins, the pinned
nvim plugins and GNOME Shell extensions.

```bash
python3 installer.py            # Tool status plus a dry run of every step
python3 installer.py --install  # Do it (asks for sudo when something system-wide is missing)
```

Every step skips whatever is already in place, so re-running is safe. Existing config files are backed up as
`*.bak` before being replaced with symlinks. Pick steps with `--only` / `--skip`, e.g.
`python3 installer.py --install --only packages,links`. Steps, in order:
`repos, packages, snaps, flatpaks, asdf, npm, cargo, fonts, links, tmux, nvim, gnome`.

What gets installed lives in the manifest at the top of `installer.py`.

Git identity lives outside the repo in `~/.gitconfig.local`:

```ini
[user]
	email = you@example.com
	signingkey = <GPG key id>
```

## Tooling

Here's a brief breakdown of the tools that I use.

### Heavy rotation: Day to day basis, several hours

- **neovim**. A rewrite of Vim with Lua as a scripting language and a fast MessagePack API
- **tmux**. Terminal multiplexer. A server modeled, text-based session -> window -> pane viewport segregation
- **ripgrep**. Developer grep. The (currently) fastest clear text, regex based recursive search tool
- **fzf**.
- **z**.

### Day to day, all day, but I don't think too much about them

- **fish**. An exotic shell, full color support and autocompletions with minimal config
- **starship**. Rust based, context sensible prompt
- **delta**. A Levenshtein-based diff tool with syntax highlight

### Frequently used, handy to have around

- **fdfind**. Better `find`, recursively search by filename
- **eza**. Better `ls`, full color support, sane defaults
- **batcat**. Better `cat` with syntax highlight
- **htop**. Better `top` with color support and context tooling integrated
- **ctop**. Container monitor for Docker

### Rarely used, powerful functionality when needed

- **procs**. Better `ps`, color support, smaller featureset
- **dust**. Tree-like storage usage visualization
- **duf**. Better `df`, list mounted storage devices
- **tokei**. Lines of code counter, language sensitive

NOTE: Pending fzf, z, httpie, jq
