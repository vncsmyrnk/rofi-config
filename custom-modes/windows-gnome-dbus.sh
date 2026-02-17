#!/usr/bin/env bash

# This leverages the GNOME Window Calls extension to "raise or run" applications listed on the rofi's menu
# Extension: https://github.com/ickyicky/window-calls

if [[ -n "$*" ]]; then
  # Looks for any opened file
  gnome_dbus_windows=$(
    busctl --user call \
      org.gnome.Shell \
      /org/gnome/Shell/Extensions/Windows \
      org.gnome.Shell.Extensions.Windows \
      List \
      --json=short
  )

  mapfile -t desktop_files < <(grep -h "^Name=$*" /usr/share/applications/*.desktop -l)
  for file in "${desktop_files[@]}"; do
    wm_class=$(basename "$file" | rev | cut -f2- -d "." | rev)
    opened_window_ids=$(echo "$gnome_dbus_windows" | jq -r '.data[0]' | jq -r --arg wmClass "$wm_class" '.[] | select(.wm_class == $wmClass) | .id')
    if [[ -n "$opened_window_ids" ]]; then
      opened_window_id=$(echo "$opened_window_ids" | tail -n 1)
      busctl --user call \
        org.gnome.Shell \
        /org/gnome/Shell/Extensions/Windows \
        org.gnome.Shell.Extensions.Windows \
        Activate \
        u "$opened_window_id"
      exit 0
    fi
  done

  # Opens a new instance if not already opened
  gio launch "${desktop_files[0]}" >/dev/null &
  exit 0
fi

grep -h "^Name=" /usr/share/applications/*.desktop | cut -d= -f2- | sort -u
