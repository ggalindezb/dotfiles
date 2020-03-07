# Fish shell configuration file
#
# Maintainer:	      Gerardo Galindez
# Original File:    2012/09/10 [bashrc]
# Created:          2017/04/06
# Last Updated:     2020/03/01
# File Location:    ~/.config/fish/config.fish
# Sections:
#    -> General                    [GEN]
#    -> Boot                       [BOO]
#    -> Hooks                      [HOK]
#    -> Aliases                    [ALI]
#    -> References                 [REF]

# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# -> General [GEN]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Homebrew sbin
# set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#-> Boot [BOO]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set -xg LC_ALL en_US.UTF-8
set -xg GPG_TTY (tty)

# Autostart tmux
# If status is-interactive
# and not set -q TMUX
#     exec tmux
# end

# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# -> Hooks [HOK]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# rvm default                                                # Load RVM
status --is-interactive; and source (rbenv init -|psub)    # Load rbenv
direnv hook fish | source                                  # Load direnv

# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# -> Aliases [ALI]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
alias tree='tree -CAh'                      # Color tree
abbr --add - 'cd -'                         # cd back

# Git
abbr --add gst 'git status -s -b'           # Brief git status
abbr --add gco 'git checkout'               # Fast switch
abbr --add gcb 'git checkout -b'            # Branching
abbr --add gcm 'git commit -m '             # Fast commit
abbr --add gp 'git push'                    # Push, needs upstream set
abbr --add gts 'git tag -s v -m'            # Tag a version

# [OS X/Linux] -l Long listing
# [OS X/Linux] -F Classify, append indicator
# [OS X]       -G Color output
# [Linux]      --color Color output
# [OS X/Linux] -H Follow symlinks
# [OS X/Linux] -h Human readable
if test uname = "Linux"
  abbr --add ls 'ls -lFHh --color'
else
  abbr --add ls 'ls -lFGpHh'
end

alias tree='tree -CAh'       # Color tree
alias gst='git status -s -b' # Brief git status

# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#-> References [REF]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# -> Fish shell docs (2019/08/01) [https://fishshell.com/docs/current/tutorial.html]
