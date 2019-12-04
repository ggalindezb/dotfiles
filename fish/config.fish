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

# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# -> Aliases [ALI]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
alias ls='ls -lFGpHh'                       # Proper ls, Mac
alias tree='tree -CAh'                      # Color tree
alias rm='rm -rfi'                          # Confirm rm overkill

# Git
alias gst='git status -s -b'                # Brief git status
alias gco='git checkout'                    # Fast switch

# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#-> Boot [BOO]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set -xg LC_ALL en_US.UTF-8
set -xg GPG_TTY (tty)

# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#-> References [REF]
# """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# -> Fish shell docs (2019/08/01) [https://fishshell.com/docs/current/tutorial.html]
