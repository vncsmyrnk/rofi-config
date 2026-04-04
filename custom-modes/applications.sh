#!/usr/bin/env bash

# This leverages the GNOME Window Calls extension to "raise or run" applications listed on the rofi's menu
# More at: https://github.com/vncsmyrnk/gwin

CACHE_FILE=/tmp/rofi-applications-cache

if [[ -n "$*" ]]; then
  gwin raise "$@" >/dev/null &
  exit 0
fi

if [[ ! -f "$CACHE_FILE" ]]; then
  gwin list applications --rofi |
    tee "$CACHE_FILE"
  exit 0
fi

cat "$CACHE_FILE"
