#!/bin/bash
# Prints an icon for the command given as $1 (used by window-status-format).
case "$1" in
  claude)                        echo $'\U000F06A9' ;;  # robot
  ssh|mosh|winps|rdp)            echo $'\U000F08C0' ;;  # ssh
  nvim|vim|vi)                   echo $'' ;;      # neovim
  fish|bash|zsh|sh)              echo $'' ;;      # terminal
  git|lazygit|tig)               echo $'' ;;      # git
  node|npm|pnpm|npx)             echo $'' ;;      # node
  python|python3|ipython|uv)     echo $'' ;;      # python
  docker|lazydocker)             echo $'' ;;      # docker
  dotnet)                        echo $'' ;;      # dotnet
  mysql|psql|sqlite3)            echo $'' ;;      # database
  htop|btop|top)                 echo $'\U000F035B' ;;  # chip
  man|less|bat|batcat)           echo $'' ;;      # book
  *)                             echo $'' ;;      # gear
esac
