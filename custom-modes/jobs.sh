#!/usr/bin/env bash

# This expectes a profile, lists commands and executes or switch-client if
# already running
#
# More at https://github.com/vncsmyrnk/shell-utils

PROCS_FILE=${PROCS_FILE:-~/Documents/Procfile}
LABEL_RUNNING_SUFIX=" (running)"

mapfile -t windows < <(util jobs list || true)

input="$*"
if [[ -n "$input" ]]; then
  case "$ROFI_RETV" in
  3) util jobs kill "$input" ;;
  *)
    case "$input" in
    "Kill all")
      util jobs kill --all >/dev/null 2>&1
      ;;
    *)
      if [[ " ${windows[*]} " == *" $input "* ]]; then
        util jobs attach "$input"
        exit 0
      fi
      util jobs run "$input" "$ROFI_INFO"
      ;;
    esac
    ;;
  esac
  exit 0
fi

running=()
while IFS= read -r w; do
  name=$(cut -d':' -f1 <<<"${w//\\/\\\\}")
  cmd=$(cut -d':' -f2- <<<"${w//\\/\\\\}")
  label_suffix=""
  if [[ " ${windows[*]} " == *" $name "* ]]; then
    running+=("$name")
    label_suffix="$LABEL_RUNNING_SUFIX"
  fi
  echo -e "$name\x00info\x1f$cmd\x1fdisplay\x1f$name$label_suffix"
done <"$PROCS_FILE"

while IFS= read -r w; do
  if [[ " ${running[*]} " == *" $w "* ]]; then
    continue
  fi
  echo -e "$w\x00info\x1f$cmd\x1fdisplay\x1f$w$LABEL_RUNNING_SUFIX"
done < <(util jobs list)

echo "Kill all"
