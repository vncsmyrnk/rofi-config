#!/usr/bin/env bash

# This leverages the GNOME Window Calls extension to raise opened applications listed on the rofi's menu
# More at: https://github.com/vncsmyrnk/gwin

if [[ -n "$*" ]]; then
  gwin switch "$@" >/dev/null &
  exit 0
fi

gwin list windows --rofi
