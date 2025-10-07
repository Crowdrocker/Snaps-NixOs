#!/bin/bash
# WehttamSnaps NixOS Setup Script

echo "🚀 Setting up WehttamSnaps NixOS configuration..."

# Create directories
mkdir -p ~/.config/niri
mkdir -p ~/.config/quickshell/widgets
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/sounds/jarvis
mkdir -p ~/.local/share/icons
mkdir -p ~/.config/qpwgraph

# Copy config files (you'll need to create these from above)
echo "📁 Copying configuration files..."
# cp niri-config.kdl ~/.config/niri/config.kdl
# cp keybinds.kdl ~/.config/niri/keybinds.kdl
# ... etc for all config files

# Make scripts executable
chmod +x ~/.local/bin/*.sh

# Download J.A.R.V.I.S. sounds (place your sounds here)
echo "🔊 Downloading J.A.R.V.I.S. sounds..."
# wget -O ~/.local/share/sounds/jarvis/jarvis-startup.mp3 [your-sound-url]
# wget -O ~/.local/share/sounds/jarvis/jarvis-shutdown.mp3 [your-sound-url]

echo "✅ Setup complete! Run 'sudo nixos-rebuild switch' to apply changes."
