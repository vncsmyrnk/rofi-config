#!/usr/bin/env bash

# This leverages the GNOME Window Calls extension to raise opened applications listed on the rofi's menu
# More at: https://github.com/vncsmyrnk/gwin

input="$*"
if [[ -n "$input" ]]; then
  case "$ROFI_RETV" in
  3) gwin close "$input" ;;
  *) gwin switch "$input" >/dev/null & ;;
  esac
  exit 0
fi

gwin list windows --rofi
