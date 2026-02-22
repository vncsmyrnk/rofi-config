#!/usr/bin/env bash

# This leverages the GNOME Window Calls extension to "raise or run" applications listed on the rofi's menu
# Extension: https://github.com/ickyicky/window-calls

CACHE_FILE=/tmp/rofi-applications-list-cache

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

if [[ -n "$*" ]]; then
  mapfile -t desktop_filenames_matching_input < <(grep -h "^Name=$*" /usr/share/applications/*.desktop -l)
  for file in "${desktop_filenames_matching_input[@]}"; do
    wm_class=$(basename "$file" | rev | cut -f2- -d "." | rev)
    opened_window_ids=$(
      bustctl_dbus_list_windows |
        jq -r '.data[0]' |
        jq -r --arg wmClass "$wm_class" '.[] | select(.wm_class == $wmClass) | .id'
    )

    if [[ -n "$opened_window_ids" ]]; then
      opened_window_id=$(echo "$opened_window_ids" | tail -n 1)
      bustctl_dbus_activate_window "$opened_window_id"
      exit 0
    fi
  done

  gio launch "${desktop_filenames_matching_input[0]}" >/dev/null &
  exit 0
fi

if [[ ! -f "$CACHE_FILE" ]]; then
  grep -h "^Name=" /usr/share/applications/*.desktop |
    cut -d= -f2- |
    sort -u |
    tee "$CACHE_FILE"
  exit 0
fi

cat "$CACHE_FILE"
