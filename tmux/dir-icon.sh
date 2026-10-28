#!/bin/sh
# Prints an icon for the directory given as $1 (used by window-status-format).
# Linked worktrees resolve to their main checkout, so they share its icon.
d=$1
c=$(git -C "$d" --no-optional-locks rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
case "$c" in */.git) d=${c%/.git} ;; esac

case "$d" in
  "$HOME"/dev/sdl/sdl-mono*)    echo 󰆧 ;;
  "$HOME"/dev/sdl/sdldesktop*)  echo 󰍹 ;;
  "$HOME"/dev/sdl/sdl-hosting*) echo 󰒋 ;;
  "$HOME"/dev/ggalindezb*)      printf "\357\204\240\n" ;;
  "$HOME"/dev/screens*)         echo 󰹑 ;;
  *)                            printf "\357\204\240\n" ;;
esac
