# WehttamSnaps NixOS - Quick Start Guide

**Get up and running in 30 minutes!**

---

## 🚀 Super Quick Start (For Experienced Users)

```bash
# 1. Install NixOS Unstable with Calamares
# 2. After first boot:

git clone https://github.com/Crowdrocker/Snaps-NixOs.git ~/nixos-config
cd ~/nixos-config
sudo nixos-generate-config --show-hardware-config > hosts/snaps-pc/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#snaps-pc
sudo reboot

# 3. Login to Niri session
# 4. Press Super+H for welcome app
```

---

## 📋 Step-by-Step Quick Start

### Step 1: Install NixOS (15 minutes)

1. **Download NixOS Unstable ISO**
   - https://nixos.org/download.html
   - Choose "Unstable" channel

2. **Create bootable USB**
   - Windows: Use Rufus
   - Linux: `sudo dd if=nixos.iso of=/dev/sdX bs=4M status=progress`

3. **Boot from USB**
   - Press F12/F2/DEL during boot
   - Select USB drive

4. **Run Calamares installer**
   - Language: English
   - Timezone: Your timezone
   - Keyboard: US
   
5. **Partition disks**
   ```
   120GB SSD (Linux):
   ├── 512MB  /boot (EFI)
   ├── 110GB  /     (ext4)
   └── 8GB    swap
   
   1TB SSD (Games):
   └── 1TB    LINUXDRIVE-1 (ext4)
   ```

6. **User setup**
   - Username: `wehttamsnaps`
   - Hostname: `snaps-pc`
   - Password: (your choice)

7. **Install and reboot**

### Step 2: Clone Configuration (2 minutes)

```bash
# Install git temporarily
nix-shell -p git

# Clone repository
git clone https://github.com/Crowdrocker/Snaps-NixOs.git ~/nixos-config
cd ~/nixos-config
```

### Step 3: Configure Hardware (3 minutes)

```bash
# Generate hardware config
sudo nixos-generate-config --show-hardware-config > hosts/snaps-pc/hardware-configuration.nix

# Edit if needed (update device paths)
vim hosts/snaps-pc/hardware-configuration.nix

# Update email in home.nix
vim hosts/snaps-pc/home.nix
# Change: your-email@example.com to your actual email
```

### Step 4: Build Configuration (30-60 minutes)

```bash
# Build (first time takes long!)
sudo nixos-rebuild switch --flake .#snaps-pc

# Wait for build to complete...
# Go make coffee ☕
```

### Step 5: Reboot and Login (1 minute)

```bash
sudo reboot
```

At login screen:
1. Click session selector (top-right)
2. Select "Niri"
3. Enter password
4. Login

### Step 6: Post-Installation Setup (10 minutes)

```bash
# 1. Set up audio routing
bash /etc/audio-routing-setup.sh

# 2. Copy J.A.R.V.I.S. sounds
mkdir -p ~/.config/sounds
# Copy your sound files to ~/.config/sounds/

# 3. Copy scripts
mkdir -p ~/.config/scripts/jarvis
cp ~/nixos-config/scripts/jarvis/*.sh ~/.config/scripts/jarvis/
chmod +x ~/.config/scripts/jarvis/*.sh

# 4. Add wallpapers
mkdir -p ~/.config/wallpapers
# Copy your wallpapers to ~/.config/wallpapers/
```

### Step 7: Configure Steam (5 minutes)

```bash
# Launch Steam
steam
```

1. Login to Steam
2. Settings → Compatibility
   - ✅ Enable Steam Play for all titles
   - Select: Proton Experimental
3. Settings → Storage
   - Add: `/run/media/wehttamsnaps/LINUXDRIVE-1/SteamLibrary`
4. Install Proton-GE:
   ```bash
   protonup-qt
   ```

### Step 8: Test Everything (5 minutes)

```bash
# Test gaming mode
# Press: Super+Shift+G

# Test audio routing
# Press: Super+Shift+A

# Test launchers
# Press: Super+W (work)
# Press: Super+G (gaming)

# Test terminal
# Press: Super+Return
```

---

## ⌨️ Essential Keybindings

| Key | Action |
|-----|--------|
| `Super+Return` | Terminal |
| `Super+D` | App launcher |
| `Super+W` | Work launcher |
| `Super+G` | Gaming launcher |
| `Super+H` | Welcome app |
| `Super+Shift+G` | Gaming mode |
| `Super+Shift+T` | Streaming mode |
| `Super+A` | Audio mixer |
| `Super+Shift+A` | Audio routing |
| `Super+1-9` | Switch workspace |
| `Super+Q` | Close window |
| `Super+F` | Fullscreen |

---

## 🎮 Quick Gaming Setup

### Add Steam Launch Options

For each game:
1. Right-click game → Properties
2. Launch Options:
   ```
   RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
   ```

### Your Games (Pre-configured)

See `modules/gaming/steam.nix` for launch options for:
- Cyberpunk 2077
- The Division 1 & 2
- Fallout 4
- Watch Dogs series
- The First Descendant
- And more...

---

## 🎵 Quick Audio Setup

### Create Virtual Sinks

```bash
bash /etc/audio-routing-setup.sh
```

### Route Applications

Press `Super+Shift+A` to open qpwgraph:
1. Connect Steam → Game Audio
2. Connect Firefox → Browser Audio
3. Connect Discord → Discord Audio
4. Connect Spotify → Spotify Audio
5. Connect each sink to your speakers

### Configure OBS

1. Launch OBS
2. Add audio sources:
   - Game Audio (game_audio_sink.monitor)
   - Browser Audio (browser_audio_sink.monitor)
   - Discord Audio (discord_audio_sink.monitor)
   - Spotify Audio (spotify_audio_sink.monitor)

---

## 🤖 J.A.R.V.I.S. Setup

### Add Sound Files

Place these files in `~/.config/sounds/`:
- jarvis-startup.mp3
- jarvis-shutdown.mp3
- jarvis-notification.mp3
- jarvis-warning.mp3
- jarvis-gaming.mp3
- jarvis-streaming.mp3

### Test Sounds

```bash
# Test startup
~/.config/scripts/jarvis/startup.sh

# Test gaming mode
# Press: Super+Shift+G

# Test streaming mode
# Press: Super+Shift+T
```

---

## 🔧 Quick Troubleshooting

### No Audio?
```bash
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Niri Won't Start?
```bash
journalctl -xe | grep niri
```

### Steam Won't Launch?
```bash
steam-runtime
```

### GPU Not Working?
```bash
lspci -k | grep -A 3 VGA
# Should show: amdgpu driver
```

### Build Failed?
```bash
# Check error message
# Usually missing hardware-configuration.nix or wrong device paths
```

---

## 📚 Full Documentation

For detailed guides, see:
- **Installation**: `docs/INSTALLATION.md`
- **Keybindings**: `docs/KEYBINDINGS.md`
- **Audio Routing**: `docs/AUDIO_ROUTING.md`
- **Gaming**: `docs/GAMING.md`
- **Setup Summary**: `SETUP_SUMMARY.md`

---

## 🆘 Need Help?

- **Discord**: https://discord.gg/nTaknDvdUA
- **GitHub Issues**: https://github.com/Crowdrocker/Snaps-NixOs/issues
- **NixOS Discourse**: https://discourse.nixos.org/

---

## ✅ Quick Checklist

- [ ] NixOS installed
- [ ] Configuration cloned
- [ ] Hardware config updated
- [ ] System built and rebooted
- [ ] Logged into Niri
- [ ] Audio routing set up
- [ ] Steam configured
- [ ] Proton-GE installed
- [ ] J.A.R.V.I.S. sounds added
- [ ] Tested gaming mode
- [ ] Tested streaming mode

---

**You're all set! Enjoy your WehttamSnaps NixOS setup!** 🎉

**"It just works!"**