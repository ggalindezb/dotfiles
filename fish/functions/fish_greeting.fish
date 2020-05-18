function fish_greeting
  curl 'wttr.in/?0Q' 2> /dev/null  # Weather report
  fortune | cowsay                 # Better greet
end

