function fish_greeting
  curl 'wttr.in/?0Q' 2> /dev/null | lolcat # Weather report
  fortune | cowsay | lolcat                # Better greet
end

