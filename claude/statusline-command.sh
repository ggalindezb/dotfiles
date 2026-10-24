#!/usr/bin/env bash
# Status line modeled on the Starship catppuccin-powerline prompt (catppuccin_mocha).
input=$(cat)

IFS=$'\x1f' read -r model ctx effort cost cache warm expires five seven dur added removed < <(echo "$input" | jq -r '[
  (.model.display_name // ""),
  (.context_window.used_percentage // ""),
  (.effort.level // ""),
  (.cost.total_cost_usd // ""),
  (.prompt_cache.hit_ratio // ""),
  (.prompt_cache.warm | if . == null then "" else . end),
  (.prompt_cache.expires_at // ""),
  (.rate_limits.five_hour.used_percentage // ""),
  (.rate_limits.seven_day.used_percentage // ""),
  (.cost.total_duration_ms // ""),
  (.cost.total_lines_added // ""),
  (.cost.total_lines_removed // "")
] | map(tostring) | join("\u001f")')

# Catppuccin mocha colors as "r;g;b"
CRUST="17;17;27"
PEACH="250;179;135"
BLUE="137;180;250"
GREEN="166;227;161"
SAPPHIRE="116;199;236"
MAUVE="203;166;247"
PINK="245;194;231"
TEAL="148;226;213"
SKY="137;220;235"
MAROON="235;160;172"
DARK_PURPLE="88;56;128"

SEP=$''
LCAP=$''
prev=""
out=""

# seg <bg> <text>: draws a powerline segment, joining to the previous background
seg() {
  local bg="$1" text="$2"
  if [ -z "$prev" ]; then
    out+="\033[38;2;${bg}m${LCAP}"
  else
    out+="\033[38;2;${prev};48;2;${bg}m${SEP}"
  fi
  out+="\033[38;2;${CRUST};48;2;${bg}m${text}"
  prev="$bg"
}

# Model family only, e.g. "Opus" from "Opus 5.5 (1M context)"
[ -n "$model" ] && seg "$GREEN" " ${model%% *} "
[ -n "$effort" ] && seg "$PINK" " ${effort} "
[ -n "$ctx" ] && seg "$SAPPHIRE" " ctx $(printf '%.0f' "$ctx")% "
[ -n "$cost" ] && seg "$TEAL" " \$$(printf '%.2f' "$cost") "
# Cache hit ratio
[ -n "$cache" ] && seg "$SKY" " cache $(awk -v r="$cache" 'BEGIN { printf "%.0f", r * 100 }')% "

# Cache state: warm with its expiry time, or cold
if [ "$warm" = "true" ]; then
  text="warm"
  [ -n "$expires" ] && text+=" until $(date -d "@${expires%.*}" +%H:%M)"
  seg "$PEACH" " ${text} "
elif [ "$warm" = "false" ]; then
  seg "$BLUE" " cold "
fi
if [ -n "$five" ] || [ -n "$seven" ]; then
  plan=""
  [ -n "$five" ] && plan+="5h $(printf '%.0f' "$five")%"
  [ -n "$five" ] && [ -n "$seven" ] && plan+=" "
  [ -n "$seven" ] && plan+="7d $(printf '%.0f' "$seven")%"
  seg "$MAROON" " ${plan} "
fi
if [ -n "$dur" ]; then
  mins=$(( ${dur%.*} / 60000 ))
  seg "$DARK_PURPLE" " $(( mins / 60 ))h$(( mins % 60 ))m "
fi
[ -n "$added" ] && seg "$MAUVE" " +${added} -${removed:-0} "

out+="\033[0m\033[38;2;${prev}m${SEP}\033[0m"
printf "%b" "$out"
