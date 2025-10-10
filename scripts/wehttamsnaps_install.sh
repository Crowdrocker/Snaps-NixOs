#!/usr/bin/env bash

# WehttamSnaps NixOS Installation Script
# This script sets up your complete NixOS configuration

set -e

BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${PURPLE}"
cat << "EOF"
 __      __      .__     __  __                     _________                           
/  \    /  \ ____| |__ _/  |/  |______    _____    /   _____/ ____ _____  ______  ______
\   \/\/   // __ \ |  \\   __\   \__  \  /     \   \_____  \ /    \\__  \ \____ \/  ___/
 \        /\  ___/|   Y  \  |  |  / __ \|  Y Y  \  /        \   |  \/ __ \|  |_> >___ \ 
  \__/\  /  \___  >___|  /__|  | (____  /__|_|  / /_______  /___|  (____  /   __/____  >
       \/       \/     \/      \/     \/      \/          \/     \/     \/|__|       \/ 
                            NixOS Setup - Gaming & Streaming Workstation
EOF
echo -e "${NC}"

echo -e "${CYAN}=== WehttamSnaps NixOS Installation Script ===${NC}\n"

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}Please do not run as root. Run as your normal user.${NC}"
    exit 1
fi

# Check if on NixOS
if [ ! -f /etc/NIXOS ]; then
    echo -e "${RED}This script must be run on NixOS!${NC}"
    exit 1
fi

# Variables
CONFIG_DIR="$HOME/nix-config"
REPO_URL="https://github.com/Crowdrocker/Snaps-NixOs.git"

echo -e "${BLUE}Step 1: Setting up directory structure${NC}"

# Create config directory
if [ -d "$CONFIG_DIR" ]; then
    echo -e "${CYAN}Config directory already exists. Backing up...${NC}"
    mv "$CONFIG_DIR" "$CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
fi

mkdir -p "$CONFIG_DIR"
cd "$CONFIG_DIR"

echo -e "${BLUE}Step 2: Initializing git repository${NC}"
git init

echo -e "${BLUE}Step 3: Enabling Nix flakes${NC}"
export NIX_CONFIG="experimental-features = nix-command flakes"

echo -e "${BLUE}Step 4: Getting Misterio77 starter template${NC}"
nix flake init -t github:misterio77/nix-starter-config#standard

echo -e "${BLUE}Step 5: Creating directory structure${NC}"

# Create main directories
mkdir -p {hosts/snaps-pc,home-manager/modules,modules/{nixos,home-manager},pkgs,overlays}
mkdir -p assets/{wallpapers,sounds/jarvis,grub-theme}
mkdir -p scripts

echo -e "${BLUE}Step 6: Copying hardware configuration${NC}"
if [ -f /etc/nixos/hardware-configuration.nix ]; then
    cp /etc/nixos/hardware-configuration.nix hosts/snaps-pc/
    echo -e "${GREEN}✓ Hardware configuration copied${NC}"
else
    echo -e "${RED}⚠ Hardware configuration not found. You'll need to generate it.${NC}"
    echo -e "${CYAN}Run: sudo nixos-generate-config --root /mnt${NC}"
fi

echo -e "${BLUE}Step 7: Setting up J.A.R.V.I.S. sounds${NC}"
cat > assets/sounds/jarvis/README.md << 'EOFREADME'
# J.A.R.V.I.S. Sound Pack

Place your J.A.R.V.I.S. sound files here:

- jarvis-startup.mp3
- jarvis-shutdown.mp3
- jarvis-notification.mp3
- jarvis-warning.mp3
- jarvis-gaming.mp3
- jarvis-streaming.mp3

Download from: https://www.101soundboards.com/
Recommended voices:
- 73296-jarvis-v1-paul-bettany-tts-computer-ai-voice
- 1023595-idroid-tts-computer-ai-voice
EOFREADME

echo -e "${BLUE}Step 8: Creating example wallpaper${NC}"
cat > assets/wallpapers/README.md << 'EOFWALLPAPER'
# WehttamSnaps Wallpapers

Place your wallpapers here.

Main wallpaper should be named: wehttamsnaps-main.png

Brand colors:
- Primary: Violet (#8A2BE2) to Cyan (#00FFFF) gradient
- Secondary: Deep Blue (#0066CC), Hot Pink (#FF69B4)
EOFWALLPAPER

echo -e "${BLUE}Step 9: Creating GRUB theme${NC}"
mkdir -p assets/grub-theme
cat > assets/grub-theme/theme.txt << 'EOFGRUB'
# WehttamSnaps GRUB Theme - J.A.R.V.I.S. Edition

title-text: "J.A.R.V.I.S. Boot System"
title-color: "#00FFFF"
title-font: "Terminus Bold 24"

desktop-image: "background.png"
desktop-color: "#0f0f1e"

terminal-box: "terminal_*.png"
terminal-font: "Terminus Regular 16"

+ boot_menu {
    left = 25%
    width = 50%
    top = 30%
    height = 40%
    
    item_color = "#e0e0ff"
    item_font = "Terminus Bold 18"
    selected_item_color = "#00FFFF"
    selected_item_font = "Terminus Bold 18"
    
    icon_width = 32
    icon_height = 32
    item_height = 40
    item_padding = 10
    item_spacing = 5
}
EOFGRUB

echo -e "${CYAN}Note: Add your custom GRUB background.png to assets/grub-theme/${NC}"

echo -e "${BLUE}Step 10: Creating helper scripts${NC}"

# System update script
cat > scripts/update-system.sh << 'EOFUPDATE'
#!/usr/bin/env bash
cd ~/nix-config
git pull
nix flake update
sudo nixos-rebuild switch --flake .#snaps-pc
EOFUPDATE
chmod +x scripts/update-system.sh

# Clean system script
cat > scripts/clean-system.sh << 'EOFCLEAN'
#!/usr/bin/env bash
sudo nix-collect-garbage -d
nix-collect-garbage -d
sudo nixos-rebuild switch --flake ~/nix-config#snaps-pc
EOFCLEAN
chmod +x scripts/clean-system.sh

# Gaming mode script
cat > scripts/gaming-mode.sh << 'EOFGAMING'
#!/usr/bin/env bash
# Toggle gaming optimizations
systemctl --user start gamemode
notify-send "Gaming Mode" "Activated - Maximum Performance"
EOFGAMING
chmod +x scripts/gaming-mode.sh

echo -e "${BLUE}Step 11: Creating README${NC}"

cat > README.md << 'EOFREADME'
# WehttamSnaps NixOS Configuration

Gaming and streaming workstation configuration for NixOS.

## 🎮 System Info

- **User**: wehttamsnaps
- **Hostname**: snaps-pc
- **CPU**: Intel i5-4430
- **GPU**: AMD RX 580
- **RAM**: 16GB DDR3
- **WM**: Hyprland
- **Shell**: Noctalia (Quickshell)

## 🚀 Quick Start

### First Time Setup

```bash
# Clone this repo (if not already)
git clone https://github.com/Crowdrocker/Snaps-NixOs.git ~/nix-config
cd ~/nix-config

# Build and switch
sudo nixos-rebuild switch --flake .#snaps-pc
```

### Update System

```bash
./scripts/update-system.sh
```

### Clean Old Generations

```bash
./scripts/clean-system.sh
```

## 📁 Repository Structure

```
.
├── flake.nix                    # Main flake configuration
├── hosts/
│   └── snaps-pc/
│       ├── configuration.nix    # System configuration
│       └── hardware-configuration.nix
├── home-manager/
│   ├── home.nix                 # Home Manager config
│   └── modules/
│       ├── hyprland.nix         # Hyprland configuration
│       ├── noctalia.nix         # Noctalia shell
│       ├── audio.nix            # PipeWire setup
│       └── jarvis.nix           # J.A.R.V.I.S. integration
├── modules/
│   ├── nixos/
│   │   ├── gaming.nix           # Gaming optimizations
│   │   ├── audio.nix            # System audio
│   │   └── amd-optimizations.nix
│   └── home-manager/
├── assets/
│   ├── wallpapers/              # Wallpaper collection
│   ├── sounds/jarvis/           # J.A.R.V.I.S. sounds
│   └── grub-theme/              # GRUB theme files
└── scripts/                     # Helper scripts
```

## 🎨 Customization

### Colors (WehttamSnaps Brand)
- Primary: Violet to Cyan gradient (#8A2BE2 → #00FFFF)
- Secondary: Deep Blue (#0066CC), Hot Pink (#FF69B4)

### Keybindings (Hyprland)

| Key | Action |
|-----|--------|
| `SUPER + Q` | Open terminal |
| `SUPER + C` | Close window |
| `SUPER + E` | File manager |
| `SUPER + R` | App launcher |
| `SUPER + G` | Toggle gaming mode |
| `SUPER + X` | Power menu |
| `SUPER + W` | Work launcher |
| `SUPER + SHIFT + W` | Game launcher |

## 🎮 Gaming

### Steam Launch Options

See `/etc/steam-launch-options.txt` for game-specific launch options.

### Controllers

Supported out of the box:
- Steam Controller
- Xbox Controllers
- PlayStation Controllers

## 🔊 Audio Routing

Similar to Voicemeter, using PipeWire:

1. Open `qpwgraph`
2. Virtual sinks created:
   - Games
   - Browser
   - Discord
   - Music/Spotify

Route audio streams independently!

## 🤖 J.A.R.V.I.S. Features

- Startup/shutdown sounds
- System notifications with voice
- Temperature warnings
- Gaming mode activation sounds

### Sound Commands

```bash
jarvis-sound startup
jarvis-sound shutdown
jarvis-sound notification
jarvis-sound warning
jarvis-sound gaming
jarvis-sound streaming
```

## 📝 Notes

- Gaming drive auto-mounts to: `/run/media/wehttamsnaps/LINUXDRIVE-1`
- Configs use NixOS unstable for latest gaming support
- ZRAM enabled for better performance with 16GB RAM

## 🔗 Links

- [Twitch](https://twitch.tv/WehttamSnaps)
- [YouTube](https://youtube.com/@WehttamSnaps)
- [GitHub](https://github.com/Crowdrocker)

## 📄 License

MIT License - Feel free to use and modify!
EOFREADME

echo -e "${GREEN}✓ README.md created${NC}"

echo -e "${BLUE}Step 12: Checking flake.nix${NC}"
cat > flake.nix << 'EOFFLAKE'
{
  description = "WehttamSnaps NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.snaps-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/snaps-pc/configuration.nix
        
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = { inherit inputs; };
            users.wehttamsnaps = import ./home-manager/home.nix;
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
      ];
    };
  };
}
EOFFLAKE

echo -e "${BLUE}Step 13: Creating .gitignore${NC}"
cat > .gitignore << 'EOFGITIGNORE'
# Nix build results
result
result-*

# Secrets
secrets.yaml
*.age

# Temporary files
*.swp
*.swo
*~
.DS_Store

# Hardware specific (keep in repo but note it)
# hosts/*/hardware-configuration.nix
EOFGITIGNORE

echo -e "${BLUE}Step 14: Initial git commit${NC}"
git add .
git commit -m "Initial WehttamSnaps NixOS configuration"

echo -e "${GREEN}════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Installation script complete!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════${NC}\n"

echo -e "${CYAN}Next steps:${NC}\n"
echo -e "${BLUE}1.${NC} Review and edit configurations:"
echo -e "   ${CYAN}nvim ~/nix-config/hosts/snaps-pc/configuration.nix${NC}"
echo -e "   ${CYAN}nvim ~/nix-config/home-manager/home.nix${NC}\n"

echo -e "${BLUE}2.${NC} Add your J.A.R.V.I.S. sounds:"
echo -e "   ${CYAN}Place .mp3 files in ~/nix-config/assets/sounds/jarvis/${NC}\n"

echo -e "${BLUE}3.${NC} Add wallpapers:"
echo -e "   ${CYAN}Place images in ~/nix-config/assets/wallpapers/${NC}"
echo -e "   ${CYAN}Rename main wallpaper to: wehttamsnaps-main.png${NC}\n"

echo -e "${BLUE}4.${NC} Update your email in git config:"
echo -e "   ${CYAN}Edit home-manager/home.nix (search for FIXME)${NC}\n"

echo -e "${BLUE}5.${NC} Build your system:"
echo -e "   ${CYAN}sudo nixos-rebuild switch --flake ~/nix-config#snaps-pc${NC}\n"

echo -e "${BLUE}6.${NC} Push to GitHub:"
echo -e "   ${CYAN}git remote add origin https://github.com/Crowdrocker/Snaps-NixOs.git${NC}"
echo -e "   ${CYAN}git branch -M main${NC}"
echo -e "   ${CYAN}git push -u origin main${NC}\n"

echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}     Welcome to WehttamSnaps NixOS - Let's Game!${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}\n"