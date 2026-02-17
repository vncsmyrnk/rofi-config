#!/bin/bash

pass_names_files=$(fd . --base-directory ~/.password-store --relative-path -t f)

if [[ -n "$*" ]]; then
  pass -c "$@" >/dev/null || notify-send "Failed to copy password" --urgency critical
  exit 0
fi

for f in $pass_names_files; do
  pass_name=$(echo "$f" | rev | cut -f2- -d "." | rev)
  echo "$pass_name"
done
