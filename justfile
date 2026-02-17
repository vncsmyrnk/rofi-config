default:
  just --list

install: config

config:
  @rm -rf {{home_dir()}}/.config/rofi
  mkdir -p {{home_dir()}}/.config/rofi
  stow -t {{home_dir()}}/.config/rofi .
  dconf load / < gnome/keybindings.conf


unset-config:
  stow -D -t {{home_dir()}}/.config/rofi .
