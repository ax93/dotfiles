#!/usr/bin/env bash

set -euo pipefail

dotfiles_repo="https://github.com/ax93/dotfiles"
dotfiles_dir="$HOME/dotfiles"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mapfile -t packages < <(grep -vE '^\s*(#|$)' "$script_dir/packages.txt")

sudo pacman -Syu --needed --noconfirm "${packages[@]}"

# Services
sudo systemctl enable --now systemd-timesyncd
sudo systemctl enable NetworkManager.service
sudo systemctl enable lightdm.service
systemctl --user enable wireplumber.service || true
sudo usermod -aG video,input "$USER"

mkdir -p "$HOME/.config"

[[ ! -d "$dotfiles_dir" ]] && git clone "$dotfiles_repo" "$dotfiles_dir"
cd "$dotfiles_dir"

stow_pkgs=(alacritty i3 picom polybar rofi lightdm theme bash)

echo "Stowing dotfiles..."
for pkg in "${stow_pkgs[@]}"; do
    # Back up real files that would conflict
    stow -n -v "$pkg" 2>&1 | grep "existing target" | awk '{print $NF}' | while read -r conflict; do
        target_path="$HOME/$conflict"
        if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
            echo "Backup: $target_path -> $target_path.bak"
            mv "$target_path" "$target_path.bak"
        fi
    done
    stow -R "$pkg"
done

# LightDM greeter config lives at /etc, not in $HOME
if [ -f "$HOME/.config/lightdm/lightdm-gtk-greeter.conf" ]; then
    sudo install -m 644 "$HOME/.config/lightdm/lightdm-gtk-greeter.conf" /etc/lightdm/lightdm-gtk-greeter.conf
fi

# Make all dotfile shell scripts executable
find "$HOME/.config" -type f -name "*.sh" -exec chmod +x {} \;

# Generate configs from .tmpl files using current palette
"$HOME/.config/theme/build.sh"

echo ""
echo "Setup complete. Reboot or run: sudo systemctl start lightdm"
