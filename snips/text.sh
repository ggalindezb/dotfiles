<stream source> 2>&1 | tee log/live.log
tail -f log/live.log | grep --line-buffered <search term>
