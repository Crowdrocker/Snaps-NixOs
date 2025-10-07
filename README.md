# WehttamSnaps NixOS Configuration

<div align="center">

![WehttamSnaps Logo](assets/logos/wehttamsnaps-logo.png)

**A complete NixOS setup for gaming, streaming, and photography**

[![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue.svg?style=flat&logo=nixos&logoColor=white)](https://nixos.org)
[![Niri](https://img.shields.io/badge/WM-Niri-purple.svg?style=flat)](https://github.com/YaLTeR/niri)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](LICENSE)

[Features](#features) • [Installation](#installation) • [Documentation](#documentation) • [Screenshots](#screenshots) • [Support](#support)

</div>

---

## 🎯 Overview

This is my personal NixOS configuration featuring:
- **Niri** - Scrollable tiling Wayland compositor
- **Noctalia Shell** - Beautiful Quickshell-based desktop environment
- **J.A.R.V.I.S. Integration** - Custom sound effects and automation
- **Gaming Optimizations** - AMD RX 580 tuned for maximum performance
- **Audio Routing** - Voicemeter-like setup using PipeWire
- **Streaming Ready** - OBS Studio with advanced audio configuration

---

## ✨ Features

### 🎮 Gaming
- **CachyOS Kernel** for maximum gaming performance
- **GameMode** automatic optimizations
- **AMD GPU** fully optimized (RADV, Mesa-git)
- **Steam** with Proton-GE support
- **Lutris, Heroic** for non-Steam games
- **MangoHud** performance overlay
- **Custom launch options** for all games

### 🎨 Desktop Environment
- **Niri Compositor** - Unique scrolling tiling layout
- **Noctalia Shell** - Minimal, beautiful Quickshell interface
- **Modular Configuration** - Easy to customize and maintain
- **WehttamSnaps Branding** - Violet-to-cyan gradient theme
- **Custom Widgets** - Work launcher, gaming launcher, power menu

### 🎵 Audio
- **PipeWire** - Modern audio server
- **Virtual Sinks** - Separate audio channels (game, browser, Discord, Spotify)
- **qpwgraph** - Visual audio routing
- **OBS Integration** - Perfect audio mixing for streaming

### 🤖 J.A.R.V.I.S. Theme
- **Startup Sounds** - Time-based greetings
- **Gaming Mode** - Performance activation with sound
- **Streaming Mode** - OBS launch with sound
- **Notifications** - Custom notification sounds
- **Warnings** - System alert sounds

### 📸 Photography & Design
- **GIMP, Krita, Inkscape** - Professional creative tools
- **Darktable** - RAW photo processing
- **Color-managed workflow** - Accurate color reproduction

### 📡 Streaming
- **OBS Studio** - Professional streaming software
- **Advanced audio routing** - Independent source control
- **Twitch integration** - Ready to stream
- **Custom scenes** - Pre-configured layouts

---

## 🖥️ System Specifications

**My Hardware:**
- **CPU**: Intel i5-4430 (4 cores, 4 threads)
- **GPU**: AMD RX 580 (8GB VRAM)
- **RAM**: 16GB DDR3
- **Storage**:
  - 120GB SSD (NixOS)
  - 1TB SSD (Games/Files)
  - 120GB SSD (Windows dual-boot)

**Optimized for:**
- 1080p gaming
- Single monitor setup
- Streaming at 1080p/60fps
- Photography editing
- General productivity

---

## 📦 Installation

### Quick Start

```bash
# Clone the repository
git clone https://github.com/Crowdrocker/Snaps-NixOs.git ~/nixos-config
cd ~/nixos-config

# Update hardware configuration
sudo nixos-generate-config --show-hardware-config > hosts/snaps-pc/hardware-configuration.nix

# Build and switch
sudo nixos-rebuild switch --flake .#snaps-pc
```

### Detailed Installation

See [INSTALLATION.md](docs/INSTALLATION.md) for complete step-by-step guide.

---

## 📚 Documentation

- **[Installation Guide](docs/INSTALLATION.md)** - Complete setup instructions
- **[Keybindings](docs/KEYBINDINGS.md)** - All keyboard shortcuts
- **[Audio Routing](docs/AUDIO_ROUTING.md)** - PipeWire configuration guide
- **[Gaming Guide](docs/GAMING.md)** - Gaming optimizations and tips
- **[Streaming Guide](docs/STREAMING.md)** - OBS setup and configuration
- **[Customization](docs/CUSTOMIZATION.md)** - Personalize your setup
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions

---

## 🎨 Screenshots

### Desktop
![Desktop Screenshot](screenshots/desktop.png)
*Niri with Noctalia shell and WehttamSnaps theme*

### Gaming
![Gaming Screenshot](screenshots/gaming.png)
*Gaming workspace with MangoHud overlay*

### Streaming
![Streaming Screenshot](screenshots/streaming.png)
*OBS Studio with audio routing*

### Photography
![Photography Screenshot](screenshots/photography.png)
*GIMP workspace for photo editing*

---

## 🗂️ Repository Structure

```
Snaps-NixOs/
├── flake.nix                    # Main flake configuration
├── hosts/                       # Per-machine configurations
│   └── snaps-pc/               # Main PC configuration
├── modules/                     # Reusable NixOS modules
│   ├── gaming/                 # Gaming optimizations
│   ├── audio/                  # Audio configuration
│   ├── desktop/                # Desktop environment
│   ├── streaming/              # Streaming setup
│   └── work/                   # Work applications
├── home/                        # Home-manager configurations
│   └── programs/               # Program-specific configs
│       ├── niri/               # Niri configuration
│       └── quickshell/         # Quickshell widgets
├── scripts/                     # Utility scripts
│   └── jarvis/                 # J.A.R.V.I.S. scripts
├── assets/                      # Static assets
│   ├── wallpapers/             # Wallpaper collection
│   ├── sounds/                 # J.A.R.V.I.S. sounds
│   └── themes/                 # Theme files
└── docs/                        # Documentation
```

---

## 🎮 Gaming Library

Optimized launch options for:
- Cyberpunk 2077
- The Division 1 & 2
- Fallout 4
- Watch Dogs series
- The First Descendant
- And more...

See [Steam Launch Options](modules/gaming/steam.nix) for details.

---

## 🔧 Key Technologies

- **NixOS Unstable** - Reproducible Linux distribution
- **Niri** - Scrollable tiling Wayland compositor
- **Quickshell** - QML-based shell framework
- **PipeWire** - Modern audio/video server
- **CachyOS Kernel** - Performance-optimized kernel
- **Home Manager** - User environment management
- **Chaotic-Nyx** - Bleeding-edge packages

---

## 🎯 Workspaces

| Workspace | Purpose | Applications |
|-----------|---------|--------------|
| 1 | General | Terminal, file manager |
| 2 | Browser | Firefox |
| 3 | Communication | Discord, Twitch |
| 4 | Photography | GIMP, Krita, Inkscape |
| 5 | Gaming | Steam, Lutris, Heroic |
| 6 | Streaming | OBS Studio |
| 9 | Music | Spotify |

---

## ⌨️ Essential Keybindings

| Keybinding | Action |
|------------|--------|
| `Super+Return` | Terminal |
| `Super+D` | App launcher |
| `Super+W` | Work launcher |
| `Super+G` | Gaming launcher |
| `Super+Shift+G` | Gaming mode |
| `Super+Shift+T` | Streaming mode |
| `Super+A` | Audio mixer |
| `Super+Shift+A` | Audio routing |

See [KEYBINDINGS.md](docs/KEYBINDINGS.md) for complete list.

---

## 🤝 Contributing

This is my personal configuration, but feel free to:
- Fork and adapt for your own use
- Submit issues for bugs
- Suggest improvements
- Share your own configurations

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **[NixOS](https://nixos.org/)** - Amazing Linux distribution
- **[Niri](https://github.com/YaLTeR/niri)** - Innovative Wayland compositor
- **[Noctalia](https://github.com/noctalia-dev/noctalia-shell)** - Beautiful shell
- **[JaKooLit](https://github.com/JaKooLit)** - Hyprland inspiration
- **[Chaotic-Nyx](https://github.com/chaotic-cx/nyx)** - Bleeding-edge packages
- **NixOS Community** - Helpful and supportive

---

## 📞 Support

- **Discord**: [WehttamSnaps Community](https://discord.gg/nTaknDvdUA)
- **GitHub Issues**: [Report bugs](https://github.com/Crowdrocker/Snaps-NixOs/issues)
- **Twitch**: [WehttamSnaps](https://twitch.tv/WehttamSnaps)
- **YouTube**: [WehttamSnaps](https://youtube.com/@WehttamSnaps)

---

## 🌟 Star History

If you find this configuration helpful, please consider giving it a star! ⭐

---

<div align="center">

**Made with ❤️ by WehttamSnaps**

*"It just works!"*

</div>