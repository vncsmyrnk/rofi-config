#!/bin/bash

if [[ -n "$*" ]]; then
  util totp generate "$@" >/dev/null || notify-send "Failed to generate TOTP" --urgency critical
  exit 0
fi

for file in "$HOME"/.secrets/totp/*; do
  file_basename_noext=$(basename "$file" | rev | cut -f2- -d "." | rev)
  echo "$file_basename_noext"
done
