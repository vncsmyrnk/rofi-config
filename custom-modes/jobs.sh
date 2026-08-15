#!/usr/bin/env bash

# This expectes a profile, lists commands and executes or switch-client if
# already running
#
# More at https://github.com/vncsmyrnk/shell-utils

input="$*"
if [[ -n "$input" ]]; then
  case "$ROFI_RETV" in
  3) tmux-job-kill "$input" ;;
  *)
    case "$input" in
    "Kill all")
      tmux-job-kill-all >/dev/null 2>&1
      ;;
    *)
      tmux-job-run "$input"
      ;;
    esac
    ;;
  esac
  exit 0
fi

while IFS=" " read -r name running; do
  label_suffix=
  if [[ "$running" = true ]]; then
    label_suffix=" (running)"
  fi
  echo -e "$name\x00meta\x1f$label_suffix\x1fdisplay\x1f$name$label_suffix"
done < <(tmux-job-list | awk 'NR > 1')

echo "Kill all"
