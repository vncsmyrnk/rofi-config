#!/usr/bin/env bash

# This leverages the GNOME Window Calls extension to raise opened applications listed on the rofi's menu
# Extension: https://github.com/ickyicky/window-calls

if [[ -n "$*" ]]; then
  window_title=$(echo "$*" | cut -d \| -f2 | cut -c2-)
  window_id=$(busctl --user call \
    org.gnome.Shell \
    /org/gnome/Shell/Extensions/Windows \
    org.gnome.Shell.Extensions.Windows \
    List \
    --json=short |
    jq -r '.data[0]' | jq -r --arg windowTitle "$window_title" 'last(.[] | select(.title == $windowTitle) | .id)')

  busctl --user call \
    org.gnome.Shell \
    /org/gnome/Shell/Extensions/Windows \
    org.gnome.Shell.Extensions.Windows \
    Activate \
    u "$window_id"
  exit 0
fi

busctl --user call \
  org.gnome.Shell \
  /org/gnome/Shell/Extensions/Windows \
  org.gnome.Shell.Extensions.Windows \
  List \
  --json=short |
  jq -r '.data[0]' | jq -r '.[] | (.wm_class // "unknown") + " | " + .title'
