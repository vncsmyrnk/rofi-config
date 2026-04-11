#!/usr/bin/env bash

# This expectes a profile, lists commands and executes or switch-client if
# already running
#
# More at https://github.com/vncsmyrnk/shell-utils

PROCS_FILE=${USEFUL_URLS_FILE:-~/Documents/Procfile}

mapfile -t windows < <(util jobs list || true)

input="$*"
if [[ -n "$input" ]]; then
  case "$input" in
  "Kill all")
    util jobs kill --all >/dev/null 2>&1
    ;;
  *)
    if [[ " ${windows[*]} " =~ $input ]]; then
      util jobs attach "$input"
      exit 0
    fi
    util jobs run "$input" "$ROFI_INFO"
    ;;
  esac
  exit 0
fi

windows_str="${windows[*]}"
while IFS= read -r line; do
  name=$(cut -d':' -f1 <<<"$line")
  cmd=$(cut -d':' -f2- <<<"$line")
  active_append=""
  if [[ " $windows_str " =~ " $name " ]]; then
    active_append=" (running)"
  fi
  echo -e "$name\x00info\x1f$cmd\x1fdisplay\x1f$name$active_append"
done <"$PROCS_FILE"

echo "Kill all"
