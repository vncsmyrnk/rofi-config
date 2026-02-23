#!/usr/bin/env bash

CACHE_FILE=/tmp/rofi-pass-cp2l-cache

if [[ -n "$*" ]]; then
  util pass cp2l -t 1 "$@" >/dev/null || notify-send "Failed to copy password" --urgency critical
  exit 0
fi

if [[ ! -f "$CACHE_FILE" ]]; then
  fd . --base-directory ~/.password-store --relative-path -t f |
    rev |
    cut -f2- -d "." |
    rev |
    tee "$CACHE_FILE"
  exit 0
fi

cat "$CACHE_FILE"
