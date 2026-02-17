default:
  just --list

install: config

config:
  @rm -f {{home_dir()}}/.config/rofi
  mkdir -p {{home_dir()}}/.config/rofi
  stow -t {{home_dir()}}/.config/rofi .

unset-config:
  stow -D -t {{home_dir()}}/.config/rofi .
