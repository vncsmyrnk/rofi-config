#!/usr/bin/env bash

# This leverages the GNOME Window Calls extension to "raise or run" applications listed on the rofi's menu
# More at: https://github.com/vncsmyrnk/gwin

if [[ -n "$*" ]]; then
  gwin raise "$@" >/dev/null &
  exit 0
fi

gwin list applications --rofi
