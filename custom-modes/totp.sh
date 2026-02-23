#!/usr/bin/env bash

CACHE_FILE=/tmp/rofi-totp-cache

if [[ -n "$*" ]]; then
  util totp generate "$@" >/dev/null || notify-send "Failed to generate TOTP" --urgency critical
  exit 0
fi

if [[ ! -f "$CACHE_FILE" ]]; then
  fd . --base-directory ~/.secrets/totp --relative-path -t f |
    rev |
    cut -f2- -d "." |
    rev |
    tee "$CACHE_FILE"
  exit 0
fi

cat "$CACHE_FILE"
