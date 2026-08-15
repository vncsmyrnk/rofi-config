#!/usr/bin/env bash

CACHE_FILE=/tmp/rofi-totp-cache

if [[ -n "$*" ]]; then
  oathtool-totp-generate "$@" >/dev/null || notify-send "Failed to generate TOTP" --urgency critical
  exit 0
fi

if [[ ! -f "$CACHE_FILE" ]]; then
  oathtool-totp-list |
    tee "$CACHE_FILE"
  exit 0
fi

cat "$CACHE_FILE"
