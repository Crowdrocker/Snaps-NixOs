# WehttamSnaps NixOS Configuration

A complete NixOS setup for streaming and gaming using the Niri window manager.

## 🚀 Features

- **Niri Window Manager** with modular KDL configuration
- **Quickshell** with custom work/gaming launchers
- **J.A.R.V.I.S. AI Voice Integration**
- **AMD Gaming Optimizations** with CachyOS kernel
- **PipeWire Audio Routing** (Voicemeter alternative)
- **Custom Violet-Cyan Color Scheme**
- **Gaming & Streaming Workflows**

## 🛠️ Installation

1. Clone this repository:
```bash
git clone https://github.com/Crowdrocker/Snaps-NixOS.git
cd Snaps-NixOS
Run the installation script:

chmod +x install.sh
./install.sh
Apply NixOS configuration:

sudo nixos-rebuild switch
📁 Structure
nixos/ - System configuration files
home/ - User configuration (Niri, scripts, Quickshell)
wallpapers/ - Brand wallpapers
sounds/ - J.A.R.V.I.S. sound pack
themes/ - SDDM and GTK themes
🎮 Gaming Setup
Includes optimizations for:

Cyberpunk 2077
The Division 2
Fallout series
And many more...
🔊 Audio Routing
Uses PipeWire + qpwgraph for advanced audio routing:

Game Audio → Virtual Sink
Discord Audio → Virtual Sink
Music → Virtual Sink
All combined for streaming
🤖 J.A.R.V.I.S. Integration
Startup/shutdown greetings
Gaming/streaming mode announcements
System status reports
Custom sound triggers
🔧 Customization
Edit the configuration files in home/niri/ and home/quickshell/widgets/ to match your preferences.

📞 Support
Join our Discord: https://discord.gg/nTaknDvdUA



### **Install Script for Snaps-NixOS**
```bash
#!/bin/bash
# Snaps-NixOS Installation Script

set -e

echo "🚀 Setting up WehttamSnaps NixOS Configuration..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Please do not run as root${NC}"
    exit 1
fi

# Create directory structure
echo -e "${YELLOW}Creating directory structure...${NC}"
mkdir -p ~/.config/niri
mkdir -p ~/.config/quickshell/widgets
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/sounds/jarvis
mkdir -p ~/.local/share/icons
mkdir -p ~/.config/qpwgraph
mkdir -p ~/Pictures/wallpapers

# Copy Niri configuration
echo -e "${YELLOW}Copying Niri configuration...${NC}"
cp -r home/niri/* ~/.config/niri/

# Copy Quickshell widgets
echo -e "${YELLOW}Copying Quickshell widgets...${NC}"
cp -r home/quickshell/widgets/* ~/.config/quickshell/widgets/

# Copy scripts and make executable
echo -e "${YELLOW}Installing scripts...${NC}"
cp home/scripts/* ~/.local/bin/
chmod +x ~/.local/bin/*.sh

# Copy wallpapers
echo -e "${YELLOW}Copying wallpapers...${NC}"
cp wallpapers/* ~/Pictures/wallpapers/ 2>/dev/null || true

# Copy sounds (if they exist)
echo -e "${YELLOW}Setting up J.A.R.V.I.S. sounds...${NC}"
cp sounds/jarvis/* ~/.local/share/sounds/jarvis/ 2>/dev/null || true

# Set up NixOS configuration
echo -e "${YELLOW}Setting up NixOS configuration...${NC}"
sudo cp nixos/configuration.nix /etc/nixos/
sudo cp nixos/hardware-configuration.nix /etc/nixos/ 2>/dev/null || echo "hardware-configuration.nix not found, generate manually"

# Install required packages for scripts
echo -e "${YELLOW}Installing required packages...${NC}"
sudo nix-env -iA nixos.mpv nixos.pulseaudio

# Set up audio routing
echo -e "${YELLOW}Setting up audio routing...${NC}"
bash ~/.local/bin/audio-setup.sh

echo -e "${GREEN}✅ Setup complete!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Review /etc/nixos/configuration.nix"
echo "2. Run: sudo nixos-rebuild switch"
echo "3. Add your J.A.R.V.I.S. sound files to ~/.local/share/sounds/jarvis/"
echo "4. Configure qpwgraph for audio routing"
echo "5. Customize wallpapers and themes"

