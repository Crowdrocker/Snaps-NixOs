#!/usr/bin/env bash

echo "🌟 Welcome to WehttamSnaps Setup!"

# Clone main config
git clone https://github.com/Crowdrocker/Snaps-NixOs.git ~/Documents/nix-config
cd ~/Documents/nix-config

# Enable flakes
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

# Apply system + home config
nix flake update
sudo nixos-rebuild switch --flake .#snaps-pc
home-manager switch --flake .#wehttamsnaps@snaps-pc

# Pull wallpapers
git checkout wallpapers
mkdir -p ~/.config/wallpapers
cp wallpapers/* ~/.config/wallpapers/

# Pull sounds
git checkout sounds
mkdir -p ~/.local/share/sounds/jarvis
cp sounds/* ~/.local/share/sounds/jarvis/

# Pull themes
git checkout themes
mkdir -p ~/.config/themes
cp themes/* ~/.config/themes/

# Pull widgets
git checkout widgets
mkdir -p ~/.config/noctalia/widgets
cp widgets/*.qml ~/.config/noctalia/widgets/

# Pull scripts
git checkout scripts
mkdir -p ~/.local/bin
cp scripts/*.sh ~/.local/bin/
chmod +x ~/.local/bin/*

echo "✅ Setup complete! Reboot and enjoy your WehttamSnaps workstation."
