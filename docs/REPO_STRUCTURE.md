# WehttamSnaps Repository Structure

## Repository 1: Snaps-NixOs (Main Configuration)

```
Snaps-NixOs/
├── flake.nix                          # Main flake configuration
├── flake.lock                         # Locked dependencies
├── README.md                          # Main documentation
├── LICENSE                            # MIT License
├── .gitignore                         # Git ignore rules
│
├── hosts/                             # Per-machine configurations
│   └── snaps-pc/                      # Your main PC
│       ├── configuration.nix          # System configuration
│       ├── hardware-configuration.nix # Hardware-specific settings
│       └── home.nix                   # Home-manager config
│
├── modules/                           # Reusable NixOS modules
│   ├── gaming/                        # Gaming-related modules
│   │   ├── default.nix               # Gaming module entry
│   │   ├── steam.nix                 # Steam configuration
│   │   ├── lutris.nix                # Lutris setup
│   │   ├── gamemode.nix              # Gamemode configuration
│   │   └── optimizations.nix         # AMD optimizations
│   │
│   ├── audio/                         # Audio configuration
│   │   ├── default.nix               # Audio module entry
│   │   ├── pipewire.nix              # PipeWire setup
│   │   └── routing.nix               # Advanced routing
│   │
│   ├── desktop/                       # Desktop environment
│   │   ├── niri.nix                  # Niri compositor
│   │   ├── noctalia.nix              # Noctalia shell
│   │   └── theming.nix               # Theme configuration
│   │
│   ├── streaming/                     # Streaming setup
│   │   ├── obs.nix                   # OBS Studio
│   │   └── twitch.nix                # Twitch integration
│   │
│   └── work/                          # Work applications
│       ├── photography.nix           # GIMP, Krita, etc.
│       └── design.nix                # Inkscape, etc.
│
├── home/                              # Home-manager configurations
│   ├── wehttamsnaps/                 # Your user config
│   │   ├── default.nix               # Main home config
│   │   ├── shell.nix                 # Shell configuration
│   │   ├── git.nix                   # Git settings
│   │   └── packages.nix              # User packages
│   │
│   └── programs/                      # Program-specific configs
│       ├── niri/                     # Niri configuration
│       │   ├── config.kdl            # Main config
│       │   ├── keybinds.kdl          # Keybindings
│       │   ├── window-rules.kdl      # Window rules
│       │   ├── layout.kdl            # Layout settings
│       │   ├── animations.kdl        # Animations
│       │   ├── startup.kdl           # Autostart
│       │   └── environment.kdl       # Environment vars
│       │
│       ├── quickshell/               # Quickshell/Noctalia
│       │   ├── bar/                  # Custom bar
│       │   ├── widgets/              # Custom widgets
│       │   │   ├── work-launcher.qml
│       │   │   ├── game-launcher.qml
│       │   │   ├── welcome-app.qml
│       │   │   ├── settings-app.qml
│       │   │   └── power-menu.qml
│       │   └── theme.qml             # WehttamSnaps theme
│       │
│       ├── kitty/                    # Terminal config
│       │   └── kitty.conf
│       │
│       ├── rofi/                     # Launcher config
│       │   ├── config.rasi
│       │   └── themes/
│       │       └── wehttamsnaps.rasi
│       │
│       └── dunst/                    # Notifications
│           └── dunstrc
│
├── scripts/                           # Utility scripts
│   ├── install.sh                    # Interactive installer
│   ├── jarvis/                       # J.A.R.V.I.S. scripts
│   │   ├── startup.sh
│   │   ├── shutdown.sh
│   │   ├── gaming-mode.sh
│   │   └── streaming-mode.sh
│   │
│   ├── audio/                        # Audio routing scripts
│   │   ├── setup-routing.sh
│   │   └── create-sinks.sh
│   │
│   └── gaming/                       # Gaming utilities
│       ├── launch-steam.sh
│       └── optimize-game.sh
│
├── assets/                            # Static assets
│   ├── wallpapers/                   # Wallpaper collection
│   ├── sounds/                       # J.A.R.V.I.S. sounds
│   │   ├── jarvis-startup.mp3
│   │   ├── jarvis-shutdown.mp3
│   │   ├── jarvis-notification.mp3
│   │   ├── jarvis-warning.mp3
│   │   ├── jarvis-gaming.mp3
│   │   └── jarvis-streaming.mp3
│   │
│   ├── themes/                       # Theme files
│   │   ├── sddm/                    # SDDM theme
│   │   ├── grub/                    # GRUB theme
│   │   └── gtk/                     # GTK themes
│   │
│   └── logos/                        # Brand assets
│       ├── wehttamsnaps-logo.png
│       └── fastfetch-logo.txt
│
└── docs/                              # Documentation
    ├── INSTALLATION.md               # Install guide
    ├── KEYBINDINGS.md                # Keybindings cheat sheet
    ├── AUDIO_ROUTING.md              # Audio setup guide
    ├── GAMING.md                     # Gaming setup guide
    ├── STREAMING.md                  # Streaming guide
    ├── TROUBLESHOOTING.md            # Common issues
    └── CUSTOMIZATION.md              # Customization guide
```

## Repository 2: Hypr-Snaps (Backup/Reference)

```
Hypr-Snaps/
├── README.md                          # Documentation
├── .gitignore
│
├── hyprland/                          # Hyprland configs
│   ├── hyprland.conf                 # Main config
│   ├── animations.conf               # Animations
│   ├── binds.conf                    # Keybindings
│   ├── environment.conf              # Environment
│   ├── general.conf                  # General settings
│   ├── monitors.conf                 # Monitor setup
│   ├── window_rules.conf             # Window rules
│   │
│   ├── scripts/                      # Utility scripts
│   │   ├── screenshot.sh
│   │   └── wallpaper.sh
│   │
│   └── appearance/                   # Visual settings
│       ├── decorations.conf
│       └── themes/
│           ├── light_theme.conf
│           └── dark_theme.conf
│
├── waybar/                            # Waybar config
│   ├── config.jsonc
│   └── style.css
│
├── rofi/                              # Rofi launcher
│   ├── config.rasi
│   └── themes/
│       └── wehttamsnaps.rasi
│
├── kitty/                             # Terminal
│   └── kitty.conf
│
└── alacritty/                         # Alternative terminal
    └── alacritty.yml
```

## Branch Strategy

### Main Repository Branches:

1. **main** - Stable, tested configuration
2. **dev** - Development and testing
3. **wallpapers** - Wallpaper collection
4. **themes** - Theme variants
5. **sounds** - J.A.R.V.I.S. sound packs
6. **experimental** - Experimental features

### Branch Usage:

```bash
# Main development
git checkout main          # Stable config
git checkout dev           # Test new features

# Asset branches
git checkout wallpapers    # Add new wallpapers
git checkout themes        # Theme development
git checkout sounds        # Sound pack updates

# Merge workflow
git checkout dev
# Make changes
git commit -m "Add gaming widget"
git checkout main
git merge dev              # Merge when stable
```

## GitHub Desktop Usage

**YES, GitHub Desktop is perfectly fine!** It's actually great for beginners.

### Workflow with GitHub Desktop:

1. **Clone Repository**
   - File → Clone Repository
   - Enter: `https://github.com/Crowdrocker/Snaps-NixOs.git`

2. **Switch Branches**
   - Click "Current Branch" dropdown
   - Select branch or create new

3. **Make Changes**
   - Edit files in your editor
   - GitHub Desktop shows changes automatically

4. **Commit Changes**
   - Review changes in GitHub Desktop
   - Write commit message
   - Click "Commit to main"

5. **Push to GitHub**
   - Click "Push origin"
   - Changes uploaded to GitHub

6. **Pull Updates**
   - Click "Fetch origin"
   - Click "Pull origin" if updates available

### Tips:
- Commit frequently with clear messages
- Use branches for experiments
- Push regularly to backup your work
- GitHub Desktop handles Git complexity for you