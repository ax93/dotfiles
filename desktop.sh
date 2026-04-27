#!/usr/bin/env bash

set -euo pipefail

packages=(
  # xorg
  xorg-server
  xorg-xinit
  xorg-xrandr
  xorg-xsetroot

  # desktop
  i3-wm
  polybar
  rofi
  picom
  feh

  # terminal & editor
  alacritty
  neovim

  # file manager
  yazi

  # display manager
  lightdm
  lightdm-gtk-greeter
  accountsservice

  # audio
  pipewire
  pipewire-pulse
  pipewire-alsa
  pipewire-jack
  wireplumber

  # fonts
  ttf-dejavu
  noto-fonts

  # utilities
  polkit
  xdg-utils
  git
  stow
  gettext
)

dotfiles_repo="https://github.com/ax93/dotfiles"
dotfiles_dir="$HOME/dotfiles"

sudo pacman -Sy --needed --noconfirm "${packages[@]}"

sudo systemctl enable lightdm.service
systemctl --user enable wireplumber.service
sudo usermod -aG video,input "$USER"

[[ ! -d "$dotfiles_dir" ]] && git clone "$dotfiles_repo" "$dotfiles_dir"
 
cd "$dotfiles_dir"
stow --restow alacritty i3 picom polybar rofi yazi lightdm theme bash

sudo install -m 644 "$HOME/.config/lightdm/lightdm-gtk-greeter.conf" /etc/lightdm/lightdm-gtk-greeter.conf

chmod +x "$HOME/.config/theme/build.sh"
"$HOME/.config/theme/build.sh"
chmod +x "$HOME/.config/polybar/launch.sh"

echo "ready"
