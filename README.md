# WehttamSnaps NixOS Gaming & Workstation Setup

<p align="center">
  <img src="assets/branding/wehttamsnaps-logo.png" alt="WehttamSnaps Logo" width="200"/>
</p>

<p align="center">
  <strong>A complete NixOS configuration for gaming and productivity</strong>
  <br>
  <em>Built for Matthew (@WehttamSnaps) - Full-time photographer, part-time gamer</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/NixOS-Unstable-blue.svg" alt="NixOS Unstable"/>
  <img src="https://img.shields.io/badge/GPU-AMD%20RX%20580-green.svg" alt="AMD RX 580"/>
  <img src="https://img.shields.io/badge/WM-Niri-purple.svg" alt="Niri WM"/>
  <img src="https://img.shields.io/badge/Shell-Zsh%2BFish-orange.svg" alt="Zsh+Fish"/>
</p>

---

## 🚀 Quick Start

### Prerequisites
- **Hardware**: Intel i5-4430, AMD RX 580, 16GB RAM
- **Storage**: 120GB Linux SSD, 1TB Games SSD
- **OS**: NixOS (Unstable channel recommended)

## 🌿 Branches

This repo uses modular branches to keep things organized:

- `main`: Core NixOS + Home Manager setup
- `wallpapers`: Custom wallpapers for Matugen
- `sounds`: J.A.R.V.I.S. sound pack
- `themes`: Terminal and UI themes
- `widgets`: Quickshell widgets
- `scripts`: Utility scripts
- `docs`: Guides and cheat sheets

Use `install.sh` to pull and apply content from each branch.

### Installation

#### 1. Fresh NixOS Install
```bash
# After fresh NixOS installation
sudo su
git clone https://github.com/Crowdrocker/Snaps-NixOS.git /etc/nixos
cd /etc/nixos
chmod +x install.sh
./install.sh
```

#### 2. Existing System Update
```bash
sudo su
cd /etc/nixos
git pull
./install.sh --update
```

#### 3. Gaming-Only Setup
```bash
./install.sh --gaming
```

#### 4. Work-Only Setup
```bash
./install.sh --work
```

---

## 🎯 Features

### 🎮 Gaming Optimizations
- **AMD GPU Optimizations**: CoreCtrl, LACT, Radeontop
- **Gaming Mode**: Automatic performance tuning
- **Steam Integration**: Gamescope, Gamemode, MangoHUD
- **Game Launchers**: Steam, Lutris, Heroic, Bottles
- **Controller Support**: Xbox, PlayStation, Steam Controller
- **Audio Routing**: PipeWire with qpwgraph for game/chat separation

### 🎬 Streaming Setup
- **OBS Studio** with custom scenes
- **Audio Routing** via qpwgraph (like Voicemeeter)
- **Stream Deck** integration ready
- **Custom keybindings** for streaming shortcuts

### 🤖 J.A.R.V.I.S. Integration
- **Voice Notifications**: System status, alerts
- **Gaming Mode**: Automatic activation
- **Custom Sounds**: Startup, shutdown, warnings
- **System Monitoring**: Temperature, performance
- **CLI Interface**: `jarvis help`

### 🎨 Theming & Branding
- **Color Scheme**: Violet-to-cyan gradient (#8A2BE2 → #00FFFF)
- **TokyoNight Theme**: Dark, modern, developer-friendly
- **Custom Wallpapers**: WehttamSnaps branded
- **Icons**: Tela-circle-dark icon theme
- **Fonts**: Inter, JetBrains Mono, Nerd Fonts

---

## 📁 Repository Structure

```
Snaps-NixOS/
├── flake.nix                    # Main flake configuration
├── install.sh                   # Installation script
├── README.md                    # This file
├── hosts/
│   └── snaps-pc/
│       ├── configuration.nix    # Main system config
│       └── hardware-configuration.nix  # Hardware-specific settings
├── modules/
│   ├── system/
│   │   ├── core.nix            # Core system settings
│   │   ├── networking.nix      # Network configuration
│   │   ├── audio.nix           # Audio setup
│   │   └── printing.nix        # Printer support
│   ├── gaming/
│   │   ├── steam.nix           # Steam configuration
│   │   └── amd-gpu.nix         # AMD GPU optimizations
│   └── graphics/
│       └── niri.nix            # Niri window manager
├── home-manager/
│   ├── home.nix                # Home manager entry point
│   ├── core.nix                # Home packages
│   ├── shell.nix               # Shell configurations
│   ├── terminal.nix            # Terminal setup
│   ├── applications.nix        # Applications
│   ├── gaming.nix              # Gaming apps
│   ├── audio.nix               # Audio apps
│   └── themes.nix              # Theming
├── configs/
│   ├── niri/
│   │   └── config.kdl          # Niri configuration
│   └── quickshell/             # Quickshell configurations
├── scripts/
│   ├── jarvis-cli.sh          # J.A.R.V.I.S. CLI
│   ├── gaming-mode.sh         # Gaming mode script
│   └── work-mode.sh           # Work mode script
├── assets/
│   ├── wallpapers/            # Custom wallpapers
│   ├── themes/                # Custom themes
│   └── sounds/                # J.A.R.V.I.S. sounds
└── docs/
    ├── GAMING.md              # Gaming setup guide
    ├── STREAMING.md           # Streaming setup guide
    ├── AUDIO.md               # Audio routing guide
    └── TROUBLESHOOTING.md     # Troubleshooting guide
```

---

## 🎮 Gaming Setup

### Installed Games & Launch Options

#### Steam Games
| Game | Launch Options | Notes |
|------|----------------|-------|
| **Call of Duty HQ** | `gamemoderun %command% -d3d11` | DX11 mode |
| **Cyberpunk 2077** | `gamemoderun %command% --launcher-skip -skipStartScreen` | Skip intro |
| **Fallout 4** | `gamemoderun %command% -windowed -noborder` | Borderless |
| **The Division** | `gamemoderun %command% -windowed` | Windowed mode |
| **The Division 2** | `gamemoderun %command%` | Native support |
| **Warframe** | `gamemoderun %command% -cluster:public -registry:Public` | Public servers |

#### Game Launchers
- **Steam**: Native + Flatpak
- **Lutris**: Wine gaming
- **Heroic**: Epic Games
- **Bottles**: Windows applications

### Gaming Performance Tips

#### AMD GPU Optimization
```bash
# Enable performance mode
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Check GPU info
radeontop
lact daemon
```

#### Memory Optimization
```bash
# Enable ZRAM
sudo systemctl enable --now zram-generator

# Check memory usage
htop
```

---

## 🎙️ Audio Setup

### PipeWire Configuration
- **Main**: PipeWire with WirePlumber
- **GUI**: pavucontrol, qpwgraph, helvum
- **Routing**: Virtual sinks for game/chat separation

### Audio Routing (like Voicemeeter)
```bash
# Install audio tools
nix-env -iA nixos.qpwgraph nixos.helvum nixos.pavucontrol

# Launch qpwgraph
qpwgraph &
```

### J.A.R.V.I.S. Audio Commands
```bash
# System sounds
jarvis audio volume-up
jarvis audio volume-down
jarvis audio mute

# Game mode audio
jarvis gaming
```

---

## 🔧 Development Environment

### Installed Languages
- **Python**: 3.11+ with pip
- **Node.js**: Latest LTS
- **Rust**: Latest stable
- **Go**: Latest stable
- **C/C++**: GCC, GDB, Valgrind

### Development Tools
- **Git**: Full configuration
- **Helix**: Modern text editor
- **Docker**: Containerization
- **VS Code**: Available via Flatpak

---

## 🎨 Customization

### Changing Themes
```bash
# Available themes
ls /home/$USERNAME/.config/nix-config/themes/

# Apply theme
nixos-rebuild switch --flake .#snaps-pc --argstr theme "tokyonight"
```

### Adding Wallpapers
```bash
# Add to wallpapers branch
git checkout wallpapers
cp new-wallpaper.jpg assets/wallpapers/
git add .
git commit -m "Add new wallpaper"
git push origin wallpapers
```

### Custom Keybindings
Edit: `configs/niri/config.kdl`
```kdl
binds {
    Mod+Shift+g spawn "jarvis gaming"
    Mod+Shift+w spawn "jarvis work"
}
```

---

## 🔄 Updates & Maintenance

### System Updates
```bash
# Update system
./install.sh --update

# Update flakes
nix flake update
nixos-rebuild switch --flake .#snaps-pc
```

### Cleaning Up
```bash
# Clean old generations
sudo nix-collect-garbage -d

# Clean store
sudo nix-store --gc
```

---

## 🐛 Troubleshooting

### Common Issues

#### GPU Not Detected
```bash
# Check GPU
lspci | grep -i vga
radeontop

# Check drivers
lsmod | grep amdgpu
```

#### Audio Issues
```bash
# Restart PipeWire
systemctl --user restart pipewire.service
systemctl --user restart wireplumber.service

# Check audio devices
pactl list short sinks
```

#### Gaming Performance
```bash
# Check CPU governor
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Check GPU temps
sensors
```

### Getting Help
- **Discord**: [WehttamSnaps Discord](https://discord.gg/nTaknDvdUA)
- **Issues**: [GitHub Issues](https://github.com/Crowdrocker/Snaps-NixOS/issues)
- **Wiki**: [GitHub Wiki](https://github.com/Crowdrocker/Snaps-NixOS/wiki)

---

## 📊 System Monitoring

### Quick Commands
```bash
# System info
neofetch
fastfetch

# Resource usage
htop
btop

# GPU monitoring
radeontop
lact gui

# Temperature
sensors
```

### J.A.R.V.I.S. Commands
```bash
# System status
jarvis monitor

# Gaming mode
jarvis gaming

# Work mode
jarvis work

# Application launch
jarvis launch steam
jarvis launch discord
```

---

## 🎯 Performance Benchmarks

### Hardware Specifications
- **CPU**: Intel i5-4430 (4 cores, 4 threads, 3.0-3.2 GHz)
- **GPU**: AMD RX 580 (4GB/8GB VRAM)
- **RAM**: 16GB DDR3-1600
- **Storage**: 1TB SSD (games), 120GB SSD (OS)

### Expected Performance
| Game | Resolution | Settings | FPS |
|------|------------|----------|-----|
| Cyberpunk 2077 | 1080p | Medium | 45-60 |
| The Division 2 | 1080p | High | 60-75 |
| Fallout 4 | 1080p | High | 60-80 |
| Warframe | 1080p | Ultra | 100+ |

---

## 📝 Notes

### Dual-Boot Setup
This configuration supports dual-boot with Windows. The GRUB bootloader will automatically detect Windows installations.

### Hardware Compatibility
- **Tested on**: Dell XPS 9100, custom i5-4430 build
- **GPU**: AMD RX 580 (recommended), GTX 1650 (supported)
- **Storage**: BTRFS filesystem with compression

### Security Features
- **Firewall**: Configured for gaming ports
- **SSH**: Enabled with key-based auth
- **Updates**: Automatic security updates

---

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch
3. **Test** on your hardware
4. **Submit** a pull request

### Branch Structure
- `main`: Stable configuration
- `unstable`: Development branch
- `wallpapers`: Custom wallpapers
- `themes`: Custom themes
- `sounds`: J.A.R.V.I.S. sounds

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **NixOS Community** for amazing documentation
- **AMD** for open-source GPU drivers
- **Niri Developers** for the window manager
- **Noctalia** for the beautiful shell theme
- **J.A.R.V.I.S.** for the inspiration

---

<p align="center">
  <strong>Built with ❤️ by WehttamSnaps</strong>
  <br>
  <em>"All systems operational. Ready for gaming and work."</em>
</p>
