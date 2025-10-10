# WehttamSnaps NixOS - Complete Setup Summary

Everything you need to know to build your ultimate gaming/streaming/photography workstation on NixOS.

---

## 🎯 What We've Built

A complete NixOS configuration featuring:

✅ **Base System**
- NixOS Unstable for latest packages
- Home Manager for user environment
- Hyprland window manager
- Noctalia Quickshell for beautiful UI
- GRUB with J.A.R.V.I.S. theme

✅ **Gaming Optimizations**
- AMD RX 580 fully optimized
- Steam with Proton
- GameMode for performance
- MangoHud for monitoring
- All your games configured

✅ **Audio Setup**
- PipeWire with qpwgraph routing
- Separate audio channels (like Voicemeter)
- Professional streaming audio
- J.A.R.V.I.S. sound integration

✅ **Developer Tools**
- Git, VSCode, GitHub Desktop
- Multiple terminals (Kitty, Alacritty)
- Zsh with Starship prompt
- All your dev tools

✅ **Creative Suite**
- GIMP, Inkscape, Krita
- Blender, Audacity
- OBS Studio for streaming
- Photography workflow

---

## 📦 Artifacts Created

I've created **13 comprehensive artifacts** for you:

### Core Configuration Files

1. **flake.nix** - Main NixOS flake configuration
2. **configuration.nix** - System-wide settings
3. **home.nix** - Home Manager user environment
4. **hyprland.nix** - Hyprland window manager config
5. **jarvis.nix** - J.A.R.V.I.S. sound integration
6. **audio.nix** - PipeWire audio system
7. **gaming.nix** - Gaming optimizations

### Scripts & Automation

8. **install.sh** - Complete installation script

### Documentation

9. **Cheat Sheet** - Quick reference for all commands
10. **Audio Routing Guide** - qpwgraph setup (like Voicemeter)
11. **Discord Server Setup** - Complete server structure
12. **Repository Structure** - File organization guide
13. **This Summary** - Overview of everything

---

## 🚀 Quick Start Guide

### Step 1: Install NixOS

1. Download NixOS ISO (Graphical, 64-bit)
2. Boot from USB
3. Use Calamares installer
4. Install to your 120GB SSD
5. Reboot into NixOS

### Step 2: Clone and Setup

```bash
# Install git
nix-shell -p git

# Run the installation script
curl -O https://raw.githubusercontent.com/Crowdrocker/Snaps-NixOs/main/scripts/install.sh
chmod +x install.sh
./install.sh

# Or manually:
git clone https://github.com/Crowdrocker/Snaps-NixOs.git ~/nix-config
cd ~/nix-config
```

### Step 3: Customize

```bash
# Edit configuration
nvim ~/nix-config/hosts/snaps-pc/configuration.nix
nvim ~/nix-config/home-manager/home.nix

# Add your email (search for FIXME)
# Adjust any settings you want
```

### Step 4: Add Assets

```bash
# Copy your J.A.R.V.I.S. sounds
cp ~/Downloads/jarvis-*.mp3 ~/nix-config/assets/sounds/jarvis/

# Copy wallpapers
cp ~/Pictures/wallpaper.png ~/nix-config/assets/wallpapers/wehttamsnaps-main.png

# Copy GRUB background
cp ~/Pictures/grub-bg.png ~/nix-config/assets/grub-theme/background.png
```

### Step 5: Build!

```bash
# Build and activate
sudo nixos-rebuild switch --flake ~/nix-config#snaps-pc

# Reboot
reboot
```

### Step 6: Post-Install

```bash
# After reboot, install Flatpak apps (optional)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.valvesoftware.Steam

# Set up audio routing
qpwgraph

# Configure OBS
obs
```

---

## 🎮 Gaming Setup

### Steam Games

For each game in your library:

1. Right-click game → Properties
2. Launch Options: `gamemoderun mangohud %command%`
3. For specific games, use the options in `/etc/steam-launch-options.txt`

### Performance Tips

```bash
# Check GPU is recognized
vulkaninfo | grep -i driver  # Should show "radv"

# Monitor performance
nvtop  # GPU monitoring
btop   # System monitoring

# Check temperatures
sensors

# Toggle gaming mode
SUPER + G
```

---

## 🔊 Audio Setup

### Quick Setup

1. Open `qpwgraph`
2. Applications auto-route to virtual sinks
3. Adjust volumes in `pavucontrol`
4. Save patchbay: File → Store Patchbay

### For Streaming

1. Route mic to Discord AND OBS
2. Route game audio to OBS
3. Lower Discord volume for stream
4. Test recording before going live

See the **Audio Routing Guide** artifact for detailed steps!

---

## ⌨️ Essential Keybindings

| Key | Action |
|-----|--------|
| `SUPER + Q` | Terminal |
| `SUPER + R` | App launcher |
| `SUPER + E` | File manager |
| `SUPER + B` | Browser |
| `SUPER + G` | Gaming mode |
| `SUPER + X` | Power menu |
| `SUPER + W` | Work launcher |
| `SUPER + SHIFT + W` | Game launcher |
| `Print` | Screenshot |

See **Cheat Sheet** artifact for complete list!

---

## 📝 Daily Workflow

### Starting Your Day

```bash
# Check for updates
cd ~/nix-config
git pull
nix flake update

# Apply updates
sudo nixos-rebuild switch --flake .#snaps-pc
```

### Making Changes

```bash
# Edit config
nvim ~/nix-config/home-manager/home.nix

# Test changes (doesn't activate)
sudo nixos-rebuild test --flake ~/nix-config#snaps-pc

# Apply changes
sudo nixos-rebuild switch --flake ~/nix-config#snaps-pc

# Commit to git
git add .
git commit -m "Added new package"
git push
```

### Cleanup

```bash
# Remove old generations
sudo nix-collect-garbage -d
nix-collect-garbage -d

# Optimize store
nix-store --optimize
```

---

## 🛠️ Troubleshooting

### System Won't Boot
- Reboot and select previous generation in GRUB
- Fix the issue in your config
- Rebuild

### Package Not Found
```bash
# Search online
https://search.nixos.org/packages

# Or in terminal
nix search nixpkgs <package-name>
```

### Audio Issues
```bash
# Restart audio stack
systemctl --user restart pipewire wireplumber
```

### Gaming Performance
```bash
# Verify GPU driver
vulkaninfo | grep -i driver

# Check if gamemode is running
systemctl --user status gamemode

# Monitor temps
sensors
```

---

## 🎨 Customization

### Change Colors

Edit `home-manager/home.nix`:

```nix
colorScheme.palette = {
  base0A = "YOUR_PRIMARY_COLOR";
  base0B = "YOUR_SECONDARY_COLOR";
  # ...
};
```

### Add Packages

Edit `home-manager/home.nix`:

```nix
home.packages = with pkgs; [
  your-new-package
];
```

Then rebuild!

### Modify Keybindings

Edit `home-manager/modules/hyprland.nix` in the `bind = [` section.

---

## 📚 All Documentation

I've created comprehensive guides for you:

1. **Cheat Sheet** - Quick reference, print this!
2. **Audio Guide** - Complete qpwgraph setup
3. **Discord Guide** - Server structure and setup
4. **Repo Structure** - How everything is organized
5. **This Summary** - Overview and quick start

---

## 🔗 Your Repositories

### Main Config Repo
**https://github.com/Crowdrocker/Snaps-NixOs**
- All NixOS configuration
- Modules and overlays
- Scripts and docs

### Hyprland Dotfiles (Optional separate repo)
**https://github.com/Crowdrocker/Hypr-Snaps**
- Pure Hyprland configs
- For non-NixOS users
- Modular structure

### Discord Server
**https://discord.gg/nTaknDvdUA**
- Community hub
- Gaming groups
- Linux help
- Photography showcase

---

## 🌟 Next Steps

### Immediate (Day 1)

- [ ] Install NixOS
- [ ] Run installation script
- [ ] Copy hardware-configuration.nix
- [ ] Add your assets (sounds, wallpapers)
- [ ] First rebuild
- [ ] Test gaming

### Short Term (Week 1)

- [ ] Set up audio routing
- [ ] Configure OBS for streaming
- [ ] Test all your games
- [ ] Customize colors/theme
- [ ] Set up Discord server
- [ ] Create first backup

### Medium Term (Month 1)

- [ ] Create custom Quickshell widgets
- [ ] Add more J.A.R.V.I.S. sounds
- [ ] Build wallpaper collection
- [ ] Document your setup
- [ ] Share on Reddit/YouTube
- [ ] Help others with NixOS

### Long Term

- [ ] Contribute to NixOS community
- [ ] Create tutorial videos
- [ ] Develop custom packages
- [ ] Perfect your workflow
- [ ] Inspire other photographers to use Linux!

---

## 💡 Pro Tips

1. **Git is your friend** - Commit often, your config is precious
2. **Test first** - Use `nixos-rebuild test` before `switch`
3. **Read errors** - Nix errors are verbose but helpful
4. **Join communities** - NixOS Discourse, r/NixOS, r/unixporn
5. **Document changes** - Comment your config files
6. **Backup hardware-configuration.nix** - It's hardware-specific
7. **Use branches** - Test big changes in separate branches
8. **Share your setup** - Help others learn from your experience

---

## 🎓 Learning Resources

- **NixOS Manual:** https://nixos.org/manual/nixos/stable/
- **Nix Pills:** https://nixos.org/guides/nix-pills/
- **Home Manager:** https://nix-community.github.io/home-manager/
- **Hyprland Wiki:** https://wiki.hyprland.org/
- **r/NixOS:** https://reddit.com/r/NixOS
- **NixOS Discourse:** https://discourse.nixos.org/

---

## 📞 Support & Community

**Your Channels:**
- 📺 Twitch: twitch.tv/WehttamSnaps
- 🎥 YouTube: youtube.com/@WehttamSnaps
- 💻 GitHub: github.com/Crowdrocker
- 💬 Discord: discord.gg/nTaknDvdUA

**Get Help:**
- Your Discord #nixos-help channel
- r/NixOS subreddit
- NixOS Discourse
- Hyprland Discord

---

## 🎉 You're Ready!

You now have:
- ✅ Complete NixOS configuration
- ✅ Gaming optimizations for RX 580
- ✅ Professional audio routing
- ✅ Beautiful Hyprland + Noctalia setup
- ✅ J.A.R.V.I.S. integration
- ✅ Streaming-ready OBS
- ✅ All documentation
- ✅ Installation scripts
- ✅ Support community

**Your system will:**
- Just work™
- Be fully reproducible
- Roll back on failures
- Look absolutely stunning
- Game like a beast
- Stream professionally

---

## 🙏 Final Notes

This setup is designed specifically for your hardware (i5-4430, RX 580, 16GB RAM) and workflow (gaming, streaming, photography). Every optimization is tailored to your needs.

**Remember:**
- NixOS has a learning curve, but it's worth it
- Your entire system is now declarative and reproducible
- You can always roll back if something breaks
- The community is super helpful
- Have fun and experiment!

**Most importantly:** This is YOUR system. Customize it, break it, fix it, make it yours. That's the beauty of Linux!

---

**Welcome to the WehttamSnaps NixOS Experience!** 🎮📸🐧

*Now go forth and game, stream, and create amazing content!*

---

**Created by Matt (WehttamSnaps)**
*Full-time photographer, part-time Linux enthusiast, full-time gamer*

Questions? Join the Discord or open an issue on GitHub!