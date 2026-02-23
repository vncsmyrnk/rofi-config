#!/usr/bin/env bash

# This leverages the GNOME Window Calls extension to raise opened applications listed on the rofi's menu
# Extension: https://github.com/ickyicky/window-calls

CACHE_FILE=/tmp/rofi-opened-applications-list-cache

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
  window_title="${input#*| }"
  window_id=$(
    grep -h ";$window_title$" "$CACHE_FILE" |
      cut -d ';' -f1
  )

  bustctl_dbus_activate_window "$window_id"
  exit 0
fi

bustctl_dbus_list_windows |
  jq -r '.data[0]' |
  jq -r '.[] | (.id | tostring) + ";" + (.wm_class // "unknown") + ";" + .title' |
  tac |
  sed '1d' |
  tee "$CACHE_FILE" |
  awk -F ';' '{ print $2 " | " $3}'
