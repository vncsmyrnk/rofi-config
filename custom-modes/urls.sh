#!/usr/bin/env bash

# Opens useful URLs using google chrome
#
# This script expect URLs to be set at $HOME/Documents/useful-urls with the following format:
# "description1=https://example.com\ndescription2=https://example.com"

USEFUL_URLS_FILE=${USEFUL_URLS_FILE:-~/Documents/useful-urls}
BROWSER=${BROWSER:-"google-chrome-stable"}

declare -A BROWSER_WM_CLASSES=(
  ["google-chrome-stable"]="google-chrome"
)
BROWSER_WM_CLASS="${BROWSER_WM_CLASSES[$BROWSER]:-$BROWSER}"

busctl_dbus_focus_last_window_class() {
  window_id=$(
    busctl --user call \
      org.gnome.Shell \
      /org/gnome/Shell/Extensions/Windows \
      org.gnome.Shell.Extensions.Windows \
      List \
      --json=short |
      jq -r '.data[0]' |
      jq -r --arg wmClass "$1" 'last(.[] | select(.wm_class == $wmClass) | .id)' |
      tail -n 1
  )

  busctl --user call \
    org.gnome.Shell \
    /org/gnome/Shell/Extensions/Windows \
    org.gnome.Shell.Extensions.Windows \
    Activate u "$window_id"
}

input="$*"
if [[ -n "$input" ]]; then
  url_item=$(
    grep -h "^$input=" "$USEFUL_URLS_FILE"
  )
  url="${url_item#*=}"
  "$BROWSER" "$url" >/dev/null &
  busctl_dbus_focus_last_window_class "$BROWSER_WM_CLASS"
  exit 0
fi

awk -F= '{ print $1 }' "$USEFUL_URLS_FILE"
