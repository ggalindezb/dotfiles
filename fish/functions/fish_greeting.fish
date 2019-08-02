function fish_greeting
  timelimit -T 1 curl 'wttr.in/?0Q' 2> /dev/null  # Weather report
  fortune | cowsay -f apt                         # Better greet
end

