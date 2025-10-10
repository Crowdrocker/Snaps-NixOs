# WehttamSnaps NixOS Configuration - Misterio77 Template Style

This is a complete NixOS configuration for WehttamSnaps, built using the Misterio77 template structure with gaming and streaming optimizations.

## 🚀 Quick Start

### 1. Install NixOS
Download NixOS from: https://nixos.org/download.html

### 2. Clone this configuration
```bash
cd ~
git clone https://github.com/Crowdrocker/nix-config.git
cd nix-config
```

### 3. Install NixOS
```bash
# Mount your partitions to /mnt
sudo nixos-generate-config --root /mnt

# Copy your hardware configuration
cp /mnt/etc/nixos/hardware-configuration.nix ./nixos/

# Edit hardware configuration with your UUIDs
nano ./nixos/hardware-configuration.nix
```

### 4. Install the system
```bash
sudo nixos-install --flake .#snaps-pc --no-root-passwd
```

### 5. After reboot
```bash
# Apply home-manager configuration
home-manager switch --flake .#wehttamsnaps@snaps-pc
```

## 📁 Structure

```
nix-config/
├── flake.nix                    # Main flake configuration
├── nixos/
│   ├── configuration.nix        # System configuration
│   └── hardware-configuration.nix # Hardware-specific settings
├── home-manager/
│   └── home.nix                 # User configuration
├── modules/
│   ├── nixos/                   # System modules
│   └── home-manager/            # User modules
├── pkgs/                        # Custom packages
├── overlays/                    # Package overlays
├── scripts/                     # Utility scripts
└── README.md                    # This file
```

## 🎮 Features

### Gaming
- AMD RX 580 optimization
- Steam, Lutris, Heroic, Bottles
- Gaming mode with performance tuning
- Controller support

### Audio
- Advanced PipeWire routing
- qpwgraph for audio mixing
- Streaming-ready setup

### Development
- Complete toolchain
- Git integration
- Terminal enhancements

### J.A.R.V.I.S. Integration
- CLI assistant
- System monitoring
- Gaming/work mode switching

## 🔧 Usage

### System management
```bash
# Update system
sudo nixos-rebuild switch --flake .#snaps-pc

# Update home-manager
home-manager switch --flake .#wehttamsnaps@snaps-pc

# Update flakes
nix flake update
```

### Custom packages
```bash
# Build custom packages
nix build .#jarvis-cli

# Enter development shell
nix develop
```

### Testing
```bash
# Test NixOS configuration
nixos-rebuild test --flake .#snaps-pc

# Test home-manager
home-manager build --flake .#wehttamsnaps@snaps-pc
```

## 🎨 Customization

### Adding new packages
Add to `home.packages` in `home-manager/home.nix`:
```nix
home.packages = with pkgs; [
  your-package-name
];
```

### Changing themes
Edit `modules/home-manager/themes.nix`:
```nix
gtk.theme = {
  name = "YourTheme";
  package = pkgs.your-theme-package;
};
```

### Adding new modules
Create new files in `modules/nixos/` or `modules/home-manager/` and import them in the respective `default.nix`.

## 📋 Hardware Requirements

- **CPU**: Intel i5-4430 or equivalent
- **GPU**: AMD RX 580 (4GB/8GB)
- **RAM**: 16GB DDR3
- **Storage**: 120GB SSD (OS) + 1TB SSD (games)

## 🆘 Support

- **Discord**: https://discord.gg/nTaknDvdUA
- **GitHub Issues**: Report issues on GitHub
- **Documentation**: Check docs/ directory

## 📝 Notes

- This configuration uses the unstable NixOS channel for latest packages
- AMD GPU optimizations are enabled by default
- Gaming mode can be activated with `jarvis gaming`
- Audio routing is configured for streaming

## 🎉 Next Steps

After installation:
1. Configure your game launch options
2. Set up OBS for streaming
3. Customize audio routing with qpwgraph
4. Join the Discord for support

Welcome to your new gaming workstation! 🎮