#!/bin/bash

# Enable COPR repositories
sudo dnf copr enable solopasha/hyprland
sudo dnf copr enable erikreider/SwayNotificationCenter
sudo dnf copr enable errornointernet/packages
sudo dnf copr enable pgdev/ghostty

# Install VS Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
sudo dnf check-update
sudo dnf install code

# Install Hyprland packages
sudo dnf install hyprland hyprpaper hyprcursor hyprshot

# Install Hyprland integration
sudo dnf install waybar rofi-wayland SwayNotificationCenter

# Install Ghostty
sudo dnf install ghostty

# Install CaskaydiaMono Nerd Font
mkdir -p ~/.local/share/fonts/CaskaydiaMonoNerd
font_name="$( curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r '.name' )"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/${font_name}/CascadiaMono.zip" -O ~/.local/share/fonts/CaskaydiaMonoNerd/CascadiaMono.zip
unzip ~/.local/share/fonts/CaskaydiaMonoNerd/CascadiaMono.zip -d ~/.local/share/fonts/CaskaydiaMonoNerd/

# Install Bibata cursor
cursor_name="$( curl -s https://api.github.com/repos/ful1e5/Bibata_Cursor/releases/latest | jq -r '.name' )"
wget "https://github.com/ful1e5/Bibata_Cursor/releases/download/${cursor_name}/Bibata-Modern-Classic.tar.xz" -O ~/.local/share/icons/Bibata-Modern-Classic.tar.xz
tar -xf ~/.local/share/icons/Bibata-Modern-Classic.tar.xz -C ~/.local/share/icons/
cp ~/.local/share/icons/Bibata-Modern-Classic/* ~/.icons/default/

# Install Oh My Posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Install hyprpolkitagent
sudo dnf install hyprpolkitagent

