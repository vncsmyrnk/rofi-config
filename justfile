os := `cat /etc/os-release | grep "^NAME=" | cut -d "=" -f2 | tr -d '"'`

default:
  just --list

install-window-calls-extension:
  curl -L https://extensions.gnome.org/extension-data/window-callsdomandoman.xyz.v20.shell-extension.zip -o /tmp/window-call-extension.zip
  gnome-extensions install /tmp/window-call-extension.zip
  gnome-extensions enable window-calls@domandoman.xyz

install-rofi:
  #!/usr/bin/env bash
  if [ "{{os}}" = "Arch Linux" ]; then
    yay -S --needed rofi
  fi

install: install-rofi install-window-calls-extension config

config:
  @rm -rf "{{home_dir()}}/.config/rofi"
  mkdir -p "{{home_dir()}}/.config/rofi"
  stow -t "{{home_dir()}}/.config/rofi" .

unset-config:
  stow -D -t "{{home_dir()}}/.config/rofi" .
