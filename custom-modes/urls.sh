#!/usr/bin/env bash

# Opens useful URLs using google chrome
#
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
  google-chrome-stable "${urls["$@"]}" >/dev/null

  { # Focus on the newest chrome instance via GNOME dbus if available
    busctl --user call \
      org.gnome.Shell \
      /org/gnome/Shell/Extensions/Windows \
      org.gnome.Shell.Extensions.Windows \
      List \
      --json=short |
      jq -r '.data[0]' | jq -r 'last(.[] | select(.wm_class == "google-chrome") | .id)' |
      xargs -I{} sh -c 'busctl --user call org.gnome.Shell /org/gnome/Shell/Extensions/Windows org.gnome.Shell.Extensions.Windows Activate u {}'
  } || exit 0 # Fails silently

  exit 0
fi

for description in "${!urls[@]}"; do
  echo "$description"
done
