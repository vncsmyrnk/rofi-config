#!/bin/bash

if [[ -n "$*" ]]; then
  case "$*" in
  "Power off")
    systemctl poweroff
    ;;
  "Reboot")
    systemctl reboot
    ;;
  "Log out")
    gnome-session-quit
    ;;
  esac
  exit 0
fi

echo -e "Power off"
echo -e "Reboot"
echo -e "Log out"
