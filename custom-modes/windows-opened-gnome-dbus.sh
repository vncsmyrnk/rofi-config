#!/usr/bin/env bash

# This leverages the GNOME Window Calls extension to raise opened applications listed on the rofi's menu
# Extension: https://github.com/ickyicky/window-calls

bustctl_dbus_list_windows() {
  busctl --user call \
    org.gnome.Shell \
    /org/gnome/Shell/Extensions/Windows \
    org.gnome.Shell.Extensions.Windows \
    List \
    --json=short
}

bustctl_dbus_activate_window() {
  busctl --user call \
    org.gnome.Shell \
    /org/gnome/Shell/Extensions/Windows \
    org.gnome.Shell.Extensions.Windows \
    Activate \
    u "$1"
}

input="$*"
if [[ -n "$input" ]]; then
  window_title="${input##*| }"
  window_id=$(bustctl_dbus_list_windows |
    jq -r '.data[0]' |
    jq -r --arg windowTitle "$window_title" 'last(.[] | select(.title == $windowTitle) | .id)')

  bustctl_dbus_activate_window "$window_id"
  exit 0
fi

bustctl_dbus_list_windows |
  jq -r '.data[0]' |
  jq -r '.[] | (.wm_class // "unknown") + " | " + .title' |
  tac |
  sed '1d'
