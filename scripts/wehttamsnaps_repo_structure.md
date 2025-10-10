# WehttamSnaps NixOS - Complete Repository Structure

This is your complete directory structure with all files you need.

```
nix-config/
│
├── flake.nix                          # Main flake configuration
├── flake.lock                         # Locked dependency versions
├── README.md                          # Main documentation
├── LICENSE                            # MIT License
├── .gitignore                         # Git ignore file
│
├── hosts/                             # Host-specific configurations
│   └── snaps-pc/
│       ├── configuration.nix          # Main system config
│       ├── hardware-configuration.nix # Hardware-specific (auto-generated)
│       └── default.nix                # Host entry point
│
├── home-manager/                      # Home Manager configurations
│   ├── home.nix                       # Main home config
│   └── modules/
│       ├── hyprland.nix              # Hyprland window manager
│       ├── terminal.nix              # Terminal configs (kitty, alacritty)
│       ├── audio.nix                 # Audio setup (home-level)
│       ├── jarvis.nix                # J.A.R.V.I.S. integration
│       ├── noctalia.nix              # Noctalia shell setup
│       ├── git.nix                   # Git configuration
│       ├── zsh.nix                   # Zsh shell config
│       └── theme.nix                 # GTK/Qt theming
│
├── modules/                           # Custom NixOS & HM modules
│   ├── nixos/
│   │   ├── gaming.nix                # Gaming optimizations
│   │   ├── audio.nix                 # System audio (PipeWire)
│   │   ├── amd-optimizations.nix     # AMD GPU optimizations
│   │   ├── grub-jarvis.nix           # GRUB bootloader theme
│   │   ├── nvidia.nix                # Nvidia support (optional)
│   │   └── default.nix               # Module exports
│   └── home-manager/
│       └── default.nix               # HM module exports
│
├── pkgs/                              # Custom packages
│   ├── noctalia-shell/               # Noctalia Quickshell
│   │   └── default.nix
│   ├── jarvis-sounds/                # J.A.R.V.I.S. sound package
│   │   └── default.nix
│   └── default.nix                   # Package exports
│
├── overlays/                          # Nixpkgs overlays
│   ├── default.nix                   # Main overlay
│   └── patches/                      # Custom patches
│
├── assets/                            # Non-Nix assets
│   ├── wallpapers/
│   │   ├── wehttamsnaps-main.png    # Main wallpaper
│   │   ├── gaming/                   # Gaming wallpapers
│   │   └── photography/              # Photography wallpapers
│   │
│   ├── sounds/
│   │   └── jarvis/
│   │       ├── jarvis-startup.mp3
│   │       ├── jarvis-shutdown.mp3
│   │       ├── jarvis-notification.mp3
│   │       ├── jarvis-warning.mp3
│   │       ├── jarvis-gaming.mp3
│   │       ├── jarvis-streaming.mp3
│   │       └── README.md
│   │
│   ├── grub-theme/
│   │   ├── theme.txt                # GRUB theme config
│   │   ├── background.png           # GRUB background
│   │   └── icons/                   # GRUB icons
│   │
│   ├── sddm-theme/                   # SDDM login theme
│   │   ├── theme.conf
│   │   └── background.png
│   │
│   └── logos/
│       ├── wehttamsnaps-logo.png
│       └── wehttamsnaps-icon.png
│
├── scripts/                           # Helper scripts
│   ├── install.sh                    # Initial setup script
│   ├── update-system.sh              # System update script
│   ├── clean-system.sh               # Cleanup script
│   ├── gaming-mode.sh                # Toggle gaming mode
│   ├── backup-config.sh              # Backup configuration
│   ├── setup-audio-routing.sh        # Audio routing setup
│   └── README.md                     # Script documentation
│
├── docs/                              # Documentation
│   ├── INSTALL.md                    # Installation guide
│   ├── CHEATSHEET.md                 # Quick reference
│   ├── GAMING.md                     # Gaming setup guide
│   ├── AUDIO.md                      # Audio routing guide
│   ├── CUSTOMIZATION.md              # How to customize
│   ├── TROUBLESHOOTING.md            # Common issues
│   └── DISCORD.md                    # Discord server setup
│
├── .github/                           # GitHub specific
│   ├── workflows/
│   │   └── build.yml                 # CI/CD workflow
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   └── FUNDING.yml                   # Sponsorship info
│
└── examples/                          # Example configurations
    ├── steam-launch-options.txt      # Steam launch options
    ├── mangohud.conf                 # MangoHud config example
    ├── qpwgraph-preset.qpwgraph      # Audio routing preset
    └── keybindings-cheatsheet.pdf    # Printable cheatsheet
```

---

## 📁 Key File Purposes

### Root Level

**flake.nix**
- Main entry point for Nix flakes
- Defines inputs (dependencies)
- Declares NixOS configurations
- Sets up Home Manager integration

**README.md**
- Project overview
- Quick start guide
- Links to detailed docs
- Screenshots and features

### hosts/snaps-pc/

**configuration.nix**
- System-wide configuration
- Boot loader settings
- Hardware support
- System packages
- Services (PipeWire, Steam, etc.)

**hardware-configuration.nix**
- Auto-generated by nixos-generate-config
- File systems
- Boot device
- Kernel modules
- Don't edit manually!

### home-manager/

**home.nix**
- User environment
- User packages
- Environment variables
- Color scheme
- Program configurations

**modules/hyprland.nix**
- Hyprland configuration
- Keybindings
- Window rules
- Animations
- Autostart programs

**modules/jarvis.nix**
- J.A.R.V.I.S. sound integration
- System scripts
- Notification hooks
- Temperature monitoring

### modules/nixos/

**gaming.nix**
- GameMode configuration
- Steam setup
- Vulkan/DXVK
- Kernel parameters
- Performance optimizations

**audio.nix**
- PipeWire configuration
- Virtual sinks
- Audio routing
- Low-latency settings

**amd-optimizations.nix**
- AMD GPU settings
- Mesa drivers
- Vulkan optimizations
- Power management

### scripts/

All helper scripts for:
- System updates
- Cleanup
- Gaming mode toggle
- Audio setup
- Backups

### assets/

All non-code assets:
- Wallpapers
- Sounds
- Themes
- Logos

### docs/

Comprehensive documentation:
- Installation steps
- Usage guides
- Troubleshooting
- Customization help

---

## 🔄 Typical Workflow

### 1. Clone Repository
```bash
git clone https://github.com/Crowdrocker/Snaps-NixOs.git ~/nix-config
cd ~/nix-config
```

### 2. Customize
```bash
# Edit system config
nvim hosts/snaps-pc/configuration.nix

# Edit user config
nvim home-manager/home.nix

# Add wallpapers
cp ~/Pictures/my-wallpaper.png assets/wallpapers/wehttamsnaps-main.png

# Add J.A.R.V.I.S. sounds
cp ~/Downloads/jarvis-*.mp3 assets/sounds/jarvis/
```

### 3. Build System
```bash
sudo nixos-rebuild switch --flake .#snaps-pc
```

### 4. Commit Changes
```bash
git add .
git commit -m "Updated configuration"
git push
```

---

## 🎯 Branching Strategy

### Main Branches

**main**
- Stable, working configuration
- Production-ready
- Protected branch

**dev**
- Development and testing
- Experimental features
- Merge to main when stable

### Feature Branches

Create branches for specific work:

```bash
# Wallpaper collection
git checkout -b wallpapers
# Add wallpapers, test, merge

# Theme changes
git checkout -b theme-update
# Update colors, test, merge

# Gaming optimizations
git checkout -b gaming-tweaks
# Test performance changes, merge

# J.A.R.V.I.S. sounds
git checkout -b jarvis-sounds
# Add new sound files, merge
```

### Branch Naming Convention
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `theme/` - Theme changes
- `assets/` - Asset updates

Example:
```bash
git checkout -b feature/new-quickshell-widget
git checkout -b fix/audio-routing-issue
git checkout -b theme/new-colorscheme
git checkout -b assets/gaming-wallpapers
```

---

## 📦 Separate Repositories (Optional)

You might want to split into multiple repos:

### 1. Main Config Repo
**Crowdrocker/Snaps-NixOs**
- All NixOS configuration
- System and home manager configs
- Modules and overlays

### 2. Wallpaper Repo
**Crowdrocker/WehttamSnaps-Wallpapers**
- Photography-themed wallpapers
- Gaming wallpapers
- Curated collection
- Different resolutions

### 3. Sounds Repo
**Crowdrocker/JarvisAI-Sounds**
- J.A.R.V.I.S. sound pack
- System sounds
- Notification sounds
- Easily shareable

### 4. Themes Repo
**Crowdrocker/WehttamSnaps-Themes**
- GTK themes
- Qt themes
- Cursor themes
- Icon packs

### 5. Scripts Repo
**Crowdrocker/Linux-Gaming-Scripts**
- Gaming optimization scripts
- Audio routing helpers
- Performance monitoring
- Useful for others

Then reference them in your main config:
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    my-wallpapers = {
      url = "github:Crowdrocker/WehttamSnaps-Wallpapers";
      flake = false;
    };
    my-sounds = {
      url = "github:Crowdrocker/JarvisAI-Sounds";
      flake = false;
    };
  };
}
```

---

## 🎨 Asset Organization Tips

### Wallpapers
```
assets/wallpapers/
├── wehttamsnaps-main.png       # Current wallpaper
├── gaming/
│   ├── cyberpunk-1.png
│   ├── division-2.png
│   └── first-descendant-1.png
├── photography/
│   ├── landscape-1.jpg
│   ├── wedding-1.jpg
│   └── abstract-1.jpg
└── animated/
    └── matrix-rain.mp4         # For video wallpapers
```

### Sounds Organization
```
assets/sounds/
├── jarvis/
│   ├── startup/
│   │   ├── jarvis-startup-1.mp3
│   │   └── jarvis-startup-2.mp3
│   ├── shutdown/
│   │   └── jarvis-shutdown.mp3
│   ├── notifications/
│   │   ├── jarvis-notification-1.mp3
│   │   └── jarvis-notification-2.mp3
│   └── gaming/
│       ├── jarvis-gaming-mode.mp3
│       └── jarvis-victory.mp3
└── system/
    ├── boot-sound.mp3
    └── login-sound.mp3
```

---

## 🔐 Secrets Management (Future)

For sensitive data (API keys, passwords):

```
nix-config/
├── secrets/
│   ├── .sops.yaml              # SOPS config
│   ├── secrets.yaml            # Encrypted secrets
│   └── README.md               # How to use
```

Use `sops-nix` for encrypted secrets in your repo.

---

## 📊 File Size Considerations

**Keep Assets Reasonable:**
- Wallpapers: < 5MB each
- Sounds: < 1MB each
- Total repo: < 100MB

**For Large Assets:**
- Use Git LFS (Large File Storage)
- Or host externally and download during build
- Reference URLs instead of committing files

---

This structure keeps everything organized, modular, and easy to maintain! 🎮