# WehttamSnaps NixOS Installation Guide

Complete step-by-step guide to install and configure your NixOS system.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [NixOS Installation](#nixos-installation)
3. [Repository Setup](#repository-setup)
4. [Configuration](#configuration)
5. [First Boot](#first-boot)
6. [Post-Installation](#post-installation)

---

## Prerequisites

### What You Need
- USB drive (4GB minimum)
- Internet connection
- Your hardware:
  - Intel i5-4430
  - AMD RX 580
  - 16GB RAM
  - 120GB SSD (Linux)
  - 1TB SSD (Games/Files)
  - 120GB SSD (Windows)

### Download NixOS
1. Go to https://nixos.org/download.html
2. Download **NixOS Unstable** ISO (recommended for gaming)
3. Use Rufus (Windows) or `dd` (Linux) to create bootable USB

---

## NixOS Installation

### Step 1: Boot from USB
1. Insert USB drive
2. Restart computer
3. Press F12/F2/DEL to enter boot menu
4. Select USB drive

### Step 2: Start Calamares Installer
NixOS now comes with Calamares installer (easy GUI installer):

1. Select language: **English**
2. Select timezone: **Your timezone**
3. Select keyboard: **US**

### Step 3: Partition Setup

**IMPORTANT**: You have three drives:
- 120GB SSD → Linux (NixOS)
- 1TB SSD → Games/Files
- 120GB SSD → Windows (already installed)

#### Recommended Partitioning for Linux SSD (120GB):

```
/dev/sda (120GB Linux SSD)
├── /dev/sda1  512MB   EFI System Partition  (FAT32)
├── /dev/sda2  110GB   Root partition         (ext4)
└── /dev/sda3  8GB     Swap partition         (swap)
```

#### Games/Files SSD (1TB):
```
/dev/sdb (1TB Games SSD)
└── /dev/sdb1  1TB     LINUXDRIVE-1          (ext4)
```

**In Calamares:**
1. Select "Manual partitioning"
2. Select your 120GB Linux SSD
3. Create partitions as shown above
4. Set mount points:
   - `/dev/sda1` → `/boot` (EFI)
   - `/dev/sda2` → `/` (root)
   - `/dev/sda3` → swap
5. **DO NOT** touch Windows SSD!

### Step 4: User Setup
- Username: `wehttamsnaps`
- Full name: `Matthew`
- Password: (your choice)
- Hostname: `snaps-pc`

### Step 5: Install
1. Review settings
2. Click "Install"
3. Wait 10-15 minutes
4. Reboot when prompted

---

## Repository Setup

### Step 1: Clone Your Configuration

After first boot and login:

```bash
# Install git
nix-shell -p git

# Clone your configuration repository
cd ~
git clone https://github.com/Crowdrocker/Snaps-NixOs.git nixos-config
cd nixos-config
```

### Step 2: Update Hardware Configuration

Your hardware configuration needs to be updated:

```bash
# Generate hardware configuration
sudo nixos-generate-config --show-hardware-config > hosts/snaps-pc/hardware-configuration.nix
```

### Step 3: Edit Configuration

Update the following files with your specific settings:

**hosts/snaps-pc/hardware-configuration.nix:**
- Update device paths for your SSDs
- Verify partition UUIDs

**hosts/snaps-pc/home.nix:**
- Update email in git configuration
- Verify paths

---

## Configuration

### Step 1: Label Your Drives

For easier management, label your drives:

```bash
# Label Linux root partition
sudo e2label /dev/sda2 nixos

# Label boot partition
sudo fatlabel /dev/sda1 boot

# Label games drive
sudo e2label /dev/sdb1 LINUXDRIVE-1
```

### Step 2: Create Required Directories

```bash
# Create gaming drive mount point
sudo mkdir -p /run/media/wehttamsnaps/LINUXDRIVE-1

# Create Steam library directory
mkdir -p /run/media/wehttamsnaps/LINUXDRIVE-1/SteamLibrary

# Create J.A.R.V.I.S. directories
mkdir -p ~/.config/sounds
mkdir -p ~/.config/jarvis
mkdir -p ~/.config/scripts/jarvis
mkdir -p ~/.config/wallpapers
```

### Step 3: Copy J.A.R.V.I.S. Sounds

Copy your J.A.R.V.I.S. sound files to `~/.config/sounds/`:
- jarvis-startup.mp3
- jarvis-shutdown.mp3
- jarvis-notification.mp3
- jarvis-warning.mp3
- jarvis-gaming.mp3
- jarvis-streaming.mp3

### Step 4: Make Scripts Executable

```bash
cd ~/nixos-config
chmod +x scripts/jarvis/*.sh
cp scripts/jarvis/*.sh ~/.config/scripts/jarvis/
```

---

## First Boot

### Step 1: Build Configuration

```bash
cd ~/nixos-config

# Test build (doesn't activate)
sudo nixos-rebuild build --flake .#snaps-pc

# If successful, switch to new configuration
sudo nixos-rebuild switch --flake .#snaps-pc
```

This will:
- Install all packages
- Configure Niri compositor
- Set up gaming optimizations
- Configure audio routing
- Install Noctalia shell

**Note**: First build takes 30-60 minutes!

### Step 2: Reboot

```bash
sudo reboot
```

### Step 3: Login to Niri

At SDDM login screen:
1. Select "Niri" session (top-right corner)
2. Enter password
3. Login

---

## Post-Installation

### Step 1: Verify System

```bash
# Check Niri is running
echo $XDG_CURRENT_DESKTOP  # Should show "niri"

# Check audio
pactl info

# Check GPU
glxinfo | grep "OpenGL renderer"
```

### Step 2: Set Up Audio Routing

```bash
# Run audio routing setup
bash /etc/audio-routing-setup.sh

# Open qpwgraph to configure routing
qpwgraph
```

See [AUDIO_ROUTING.md](AUDIO_ROUTING.md) for detailed guide.

### Step 3: Configure Steam

1. Launch Steam: `Mod+G` (opens game launcher) or `steam` in terminal
2. Login to Steam account
3. Go to Settings → Storage
4. Add library folder: `/run/media/wehttamsnaps/LINUXDRIVE-1/SteamLibrary`
5. Enable Proton:
   - Settings → Compatibility
   - Enable "Enable Steam Play for all other titles"
   - Select "Proton Experimental"

### Step 4: Install Proton-GE

```bash
# Launch ProtonUp-Qt
protonup-qt

# Install latest Proton-GE
# Click "Add version" → Select "Proton-GE" → Install
```

### Step 5: Test Gaming

1. Install a small game from Steam
2. Right-click game → Properties → Launch Options
3. Add: `RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%`
4. Launch game
5. Press `Mod+Shift+G` to activate gaming mode

### Step 6: Configure OBS

1. Launch OBS: `obs`
2. Run auto-configuration wizard
3. Set up audio sources (see AUDIO_ROUTING.md)
4. Configure scenes for streaming

---

## Troubleshooting

### Issue: Niri won't start
**Solution**: Check logs
```bash
journalctl -xe | grep niri
```

### Issue: No audio
**Solution**: Restart PipeWire
```bash
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Issue: Steam won't launch
**Solution**: Check Steam runtime
```bash
steam-runtime
```

### Issue: Games won't start
**Solution**: Check Proton logs
```bash
# Enable logging
PROTON_LOG=1 steam
# Check logs in ~/steam-*.log
```

### Issue: GPU not detected
**Solution**: Verify AMD drivers
```bash
lspci -k | grep -A 3 VGA
# Should show amdgpu driver
```

---

## Next Steps

1. Read [KEYBINDINGS.md](KEYBINDINGS.md) for keyboard shortcuts
2. Read [AUDIO_ROUTING.md](AUDIO_ROUTING.md) for audio setup
3. Read [GAMING.md](GAMING.md) for gaming optimizations
4. Read [CUSTOMIZATION.md](CUSTOMIZATION.md) for personalization

---

## Backup Your Configuration

Always backup your working configuration:

```bash
cd ~/nixos-config
git add .
git commit -m "Working configuration"
git push origin main
```

NixOS also automatically creates generations:
```bash
# List all generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

---

## Getting Help

- NixOS Manual: https://nixos.org/manual/nixos/stable/
- NixOS Discourse: https://discourse.nixos.org/
- Niri Wiki: https://github.com/YaLTeR/niri/wiki
- WehttamSnaps Discord: https://discord.gg/nTaknDvdUA

---

**Congratulations! Your WehttamSnaps NixOS system is ready!** 🎉