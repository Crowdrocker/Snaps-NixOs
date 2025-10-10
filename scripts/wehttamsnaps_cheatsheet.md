# WehttamSnaps NixOS Cheat Sheet 🎮

Quick reference guide for your WehttamSnaps NixOS gaming/streaming workstation.

---

## 🚀 System Management

### Building & Updating

```bash
# Apply configuration changes
sudo nixos-rebuild switch --flake ~/nix-config#snaps-pc

# Update packages
cd ~/nix-config
nix flake update
sudo nixos-rebuild switch --flake .#snaps-pc

# Test changes without switching
sudo nixos-rebuild test --flake ~/nix-config#snaps-pc

# Build without activating
sudo nixos-rebuild build --flake ~/nix-config#snaps-pc
```

### Rollbacks

```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Boot into specific generation
sudo nixos-rebuild switch --switch-generation 123
```

### Cleanup

```bash
# Remove old generations (older than 7 days)
sudo nix-collect-garbage -d

# User profile cleanup
nix-collect-garbage -d

# Optimize nix store
nix-store --optimize

# Full cleanup
sudo nix-collect-garbage -d && nix-collect-garbage -d && nix-store --optimize
```

---

## ⌨️ Hyprland Keybindings

### Window Management

| Key | Action |
|-----|--------|
| `SUPER + Q` | Open Kitty terminal |
| `SUPER + C` | Close active window |
| `SUPER + M` | Exit Hyprland |
| `SUPER + V` | Toggle floating |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + P` | Toggle pseudo-tiling |
| `SUPER + J` | Toggle split |

### Navigation

| Key | Action |
|-----|--------|
| `SUPER + H/J/K/L` | Focus left/down/up/right |
| `SUPER + Arrow Keys` | Focus in direction |
| `SUPER + SHIFT + H/J/K/L` | Move window left/down/up/right |
| `SUPER + CTRL + H/J/K/L` | Resize window |

### Workspaces

| Key | Action |
|-----|--------|
| `SUPER + 1-9` | Switch to workspace 1-9 |
| `SUPER + SHIFT + 1-9` | Move window to workspace |
| `SUPER + S` | Toggle special workspace |
| `SUPER + SHIFT + S` | Move to special workspace |

### Applications

| Key | Action |
|-----|--------|
| `SUPER + R` | Fuzzel launcher |
| `SUPER + E` | Thunar file manager |
| `SUPER + B` | Firefox browser |
| `SUPER + D` | Discord |

### Gaming & Custom

| Key | Action |
|-----|--------|
| `SUPER + G` | Toggle gaming mode |
| `SUPER + SHIFT + G` | Launch Steam with Gamescope |
| `SUPER + W` | Work launcher (Quickshell) |
| `SUPER + SHIFT + W` | Game launcher (Quickshell) |
| `SUPER + X` | J.A.R.V.I.S. power menu |

### Media & Screenshots

| Key | Action |
|-----|--------|
| `Print` | Screenshot selection |
| `SUPER + Print` | Screenshot full screen |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioPlay` | Play/pause |

---

## 🎮 Gaming Commands

### Steam Launch Options

Copy-paste these into Steam game properties → Launch Options:

```bash
# Standard gaming (most games)
gamemoderun mangohud %command%

# With AMD optimizations
RADV_PERFTEST=gpl,nggc AMD_VULKAN_ICD=RADV gamemoderun mangohud %command%

# For games with issues
PROTON_USE_WINED3D=0 gamemoderun %command%

# With async shader compilation
DXVK_ASYNC=1 gamemoderun mangohud %command%
```

### Game-Specific

**Cyberpunk 2077:**
```bash
gamemoderun mangohud DXVK_ASYNC=1 RADV_PERFTEST=gpl %command%
```

**Fallout 4 (with mods):**
```bash
steamtinkerlaunch %command%
```

**The Division 1 & 2:**
```bash
PROTON_USE_WINED3D=0 gamemoderun mangohud %command%
```

### Gaming Mode

```bash
# Toggle gaming mode
~/.local/bin/toggle-gaming-mode.sh

# Or use keybind: SUPER + G

# Check if active
systemctl --user status gamemode
```

### Performance Monitoring

```bash
# GPU monitoring
nvtop

# System monitoring
btop

# Temperatures
sensors

# MangoHud in-game overlay
# Already active with launch options above
```

---

## 🔊 Audio Management (PipeWire)

### Basic Controls

```bash
# GUI volume control
pavucontrol

# Graph-based routing (like Voicemeter)
qpwgraph

# Alternative graph tool
helvum

# Command line volume
wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
```

### Audio Routing Setup

Virtual sinks are auto-created:
- **Games** - Route game audio here
- **Browser** - Browser audio
- **Discord** - Voice chat
- **Music** - Spotify/music players

**To route audio:**
1. Open `qpwgraph`
2. Connect output from application to desired sink
3. Connect sink to your speakers/headphones
4. Save the configuration

### Troubleshooting Audio

```bash
# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check status
systemctl --user status pipewire

# List audio devices
wpctl status
```

---

## 🤖 J.A.R.V.I.S. Commands

```bash
# Play sounds manually
jarvis-sound startup
jarvis-sound shutdown
jarvis-sound notification
jarvis-sound warning
jarvis-sound gaming
jarvis-sound streaming

# Power menu
~/.local/bin/jarvis-power-menu.sh
# Or: SUPER + X

# Check temperatures
~/.local/bin/check-temps.sh
```

---

## 📝 Configuration Files

### Main Config Locations

```bash
# NixOS system config
~/nix-config/hosts/snaps-pc/configuration.nix

# Home Manager config
~/nix-config/home-manager/home.nix

# Hyprland config
~/nix-config/home-manager/modules/hyprland.nix

# Gaming optimizations
~/nix-config/modules/nixos/gaming.nix
```

### Quick Edits

```bash
# Edit system config
nvim ~/nix-config/hosts/snaps-pc/configuration.nix

# Edit home config
nvim ~/nix-config/home-manager/home.nix

# Edit Hyprland
nvim ~/nix-config/home-manager/modules/hyprland.nix

# After editing, rebuild:
sudo nixos-rebuild switch --flake ~/nix-config#snaps-pc
```

---

## 🛠️ Troubleshooting

### System Won't Boot

1. Reboot and select previous generation from GRUB
2. Fix the issue in configs
3. Rebuild

### Package Not Found

```bash
# Search for package
nix search nixpkgs <package-name>

# Or online
https://search.nixos.org/packages
```

### Build Failures

```bash
# Clean build cache
sudo nix-store --gc

# Update flake inputs
cd ~/nix-config
nix flake update

# Try again
sudo nixos-rebuild switch --flake .#snaps-pc
```

### Audio Issues

```bash
# Restart audio stack
systemctl --user restart pipewire wireplumber

# Check if services running
systemctl --user status pipewire
systemctl --user status wireplumber
```

### Gaming Performance Issues

```bash
# Check if gamemode is active
gamemoded -s

# Monitor GPU
nvtop

# Check temperatures
sensors

# Verify RADV driver
vulkaninfo | grep -i driver
# Should show: driverName = radv
```

---

## 📦 Package Management

### Installing Software

```bash
# Add to home.packages in home-manager/home.nix
home.packages = with pkgs; [
  package-name
];

# Then rebuild
sudo nixos-rebuild switch --flake ~/nix-config#snaps-pc
```

### Flatpak (Alternative)

```bash
# Add Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install app
flatpak install flathub com.example.App

# Update flatpaks
flatpak update
```

### Temporary Shell

```bash
# Try package without installing
nix-shell -p package-name

# Use specific package version
nix-shell -p 'python39.withPackages(ps: [ ps.numpy ])'
```

---

## 🎨 Customization

### Change Colors

Edit `home-manager/home.nix`:

```nix
colorScheme.palette = {
  base0A = "8a2be2";  # Your primary color
  base0B = "00ffff";  # Your secondary color
  # etc...
};
```

### Add Wallpapers

```bash
# Add wallpaper
cp your-wallpaper.png ~/nix-config/assets/wallpapers/wehttamsnaps-main.png

# Rebuild
sudo nixos-rebuild switch --flake ~/nix-config#snaps-pc
```

### Modify Keybindings

Edit `home-manager/modules/hyprland.nix` in the `bind = [` section.

---

## 🔗 Useful Links

- **NixOS Manual:** https://nixos.org/manual/nixos/stable/
- **Home Manager:** https://nix-community.github.io/home-manager/
- **Hyprland Wiki:** https://wiki.hyprland.org/
- **Package Search:** https://search.nixos.org/
- **WehttamSnaps Repo:** https://github.com/Crowdrocker/Snaps-NixOs

---

## 💡 Pro Tips

1. **Always commit before rebuilding** - Git is your safety net!
2. **Test changes** - Use `nixos-rebuild test` first
3. **Keep backups** - Your config is in git, hardware-config is precious
4. **Use flakes** - They make everything reproducible
5. **Read error messages** - Nix errors are verbose but helpful
6. **Join communities** - NixOS Discourse, Reddit r/NixOS
7. **Document your changes** - Future you will thank you

---

**Created by Matt (WehttamSnaps)** 
*Streaming & Gaming on Linux*