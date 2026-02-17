#!/usr/bin/env bash

# This script expect URLs to be set at $HOME/Documents/useful-urls with the following format:
# "description1=https://example.com\ndescription2=https://example.com"

useful_urls_file="$HOME/Documents/useful-urls"
if [[ ! -f "$useful_urls_file" ]]; then
  exit 1
fi

declare -A urls
while IFS= read -r line; do
  url_name=$(echo "$line" | cut -d = -f1)
  url=$(echo "$line" | cut -d = -f2)
  urls["$url_name"]="$url"
done <"$useful_urls_file"

if [[ -n "$*" ]]; then
  xdg-open "${urls["$@"]}" >/dev/null
  exit 0
fi

for description in "${!urls[@]}"; do
  echo "$description"
done
