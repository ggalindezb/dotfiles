# Fish shell configuration file
#
# Maintainer:	      Gerardo Galindez
# Original File:    2012/09/10 [bashrc]
# Created:          2017/04/06
# Last Updated:     2019/12/04
# File Location:    ~/.config/fish/config.fish
# Sections:
#    -> General                    [GEN]
#    -> Aliases                    [ALI]
#    -> Boot                       [BOO]
#    -> References                 [REF]

# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# -> General [GEN]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# rvm default                                 # Load RVM
status --is-interactive; and source (rbenv init -|psub)
direnv hook fish | source

# Homebrew sbin
# set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# -> Aliases [ALI]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# alias ls='ls -lFGpHh'                       # Proper ls, Mac
# alias ls='-lFpHh'                           # Proper ls, Linux
alias tree='tree -CAh'                      # Color tree
abbr --add - 'cd -'                           # cd back

# Git
abbr --add gst 'git status -s -b'           # Brief git status
abbr --add gco 'git checkout'               # Fast switch
abbr --add gcb 'git checkout -b'            # Branching
abbr --add gcm 'git commit -m '             # Fast commit
abbr --add gp 'git push'                    # Push, needs upstream set
abbr --add gts 'git tag -s v -m'            # Tag a version

# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#-> Boot [BOO]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set -xg LC_ALL en_US.UTF-8
set -xg GPG_TTY (tty)

# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#-> References [REF]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# -> Fish shell docs (2019/08/01) [https://fishshell.com/docs/current/tutorial.html]
