#!/bin/bash

pass_names_files=$(fd . --base-directory ~/.password-store --relative-path -t f)

if [[ -n "$*" ]]; then
  util pass cp2l -t 1 "$@" >/dev/null || notify-send "Failed to copy password"
  exit 0
fi

for f in $pass_names_files; do
  pass_name=$(echo "$f" | rev | cut -f2- -d "." | rev)
  echo "$pass_name"
done
