# WehttamSnaps Gaming Guide

Complete guide to gaming on your NixOS setup with AMD RX 580.

## Table of Contents
1. [Overview](#overview)
2. [Steam Setup](#steam-setup)
3. [Game Launch Options](#game-launch-options)
4. [Performance Optimization](#performance-optimization)
5. [Game Modding](#game-modding)
6. [Troubleshooting](#troubleshooting)

---

## Overview

### Your Gaming Hardware

- **CPU**: Intel i5-4430 (4 cores, 4 threads @ 3.0-3.2 GHz)
- **GPU**: AMD RX 580 (8GB VRAM)
- **RAM**: 16GB DDR3
- **Storage**: 1TB SSD for games

### Expected Performance

At 1080p resolution:
- **AAA Games**: 60+ FPS on High settings
- **Esports Titles**: 144+ FPS
- **Older Games**: Maxed out settings

### Gaming Optimizations Enabled

✅ CachyOS kernel for low latency
✅ GameMode for automatic optimizations
✅ AMD GPU fully optimized (RADV driver)
✅ Mesa-git for latest improvements
✅ DXVK async for shader compilation
✅ ZRAM for better memory management
✅ CPU governor set to performance

---

## Steam Setup

### Initial Configuration

1. **Launch Steam**
   ```bash
   steam
   ```
   Or press: `Mod+G` → Select Steam

2. **Login to your account**

3. **Enable Proton for all games**
   - Settings → Compatibility
   - ✅ Enable Steam Play for all other titles
   - Select: **Proton Experimental**

4. **Add game library**
   - Settings → Storage
   - Add library folder: `/run/media/wehttamsnaps/LINUXDRIVE-1/SteamLibrary`

### Install Proton-GE

Proton-GE provides better compatibility and performance:

```bash
# Launch ProtonUp-Qt
protonup-qt
```

1. Click "Add version"
2. Select "Proton-GE"
3. Install latest version
4. Restart Steam

### Enable MangoHud

MangoHud shows FPS and performance metrics:

1. Right-click game → Properties
2. Launch Options: Add `mangohud` before other options
3. Example: `mangohud gamemoderun %command%`

---

## Game Launch Options

### Base Launch Options (AMD RX 580)

For most games, use:
```
RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
```

**What this does:**
- `RADV_PERFTEST=gpl,nggc` - Enables AMD optimizations
- `DXVK_ASYNC=1` - Reduces shader compilation stuttering
- `gamemoderun` - Activates GameMode optimizations
- `%command%` - Steam placeholder for game executable

### Game-Specific Launch Options

#### Cyberpunk 2077
```
RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
```
**Notes**: Use Proton-GE for best performance

#### The Division 1 & 2
```
PROTON_ENABLE_NVAPI=1 DXVK_ASYNC=1 gamemoderun %command%
```
**Notes**: NVAPI needed for proper rendering

#### Fallout 4
```
PROTON_USE_WINED3D=0 DXVK_ASYNC=1 gamemoderun %command%
```
**Notes**: For modding, use steamtinkerlaunch (see modding section)

#### Watch Dogs Series
```
RADV_PERFTEST=gpl DXVK_ASYNC=1 gamemoderun %command%
```

#### The First Descendant
```
PROTON_ENABLE_NVAPI=1 DXVK_ASYNC=1 gamemoderun %command%
```
**Notes**: May require Proton-GE

#### Warframe
```
RADV_PERFTEST=gpl DXVK_ASYNC=1 gamemoderun %command%
```

#### Call of Duty HQ
```
PROTON_ENABLE_NVAPI=1 DXVK_ASYNC=1 gamemoderun %command%
```

### Advanced Launch Options

#### With MangoHud (Performance Overlay)
```
mangohud RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
```

#### With Gamescope (Gaming Compositor)
```
gamescope -w 1920 -h 1080 -f -- RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
```

#### Force Specific Proton Version
```
PROTON_VERSION=GE-Proton8-25 RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
```

---

## Performance Optimization

### Activate Gaming Mode

Press `Mod+Shift+G` to activate gaming mode:
- Plays J.A.R.V.I.S. sound
- Sets CPU governor to performance
- Activates GameMode optimizations
- Sends notification

### Monitor Performance

#### In-Game Overlay (MangoHud)
```bash
# Add to launch options
mangohud %command%
```

Press `Shift+F12` to toggle overlay

#### System Monitor
```bash
# Press Mod+Escape for btop
# Or
btop
```

#### GPU Monitor
```bash
# Press Mod+Shift+Escape for nvtop
# Or
nvtop
```

### Optimize Game Settings

For best performance on RX 580:

**Graphics Settings:**
- Resolution: 1920x1080
- Texture Quality: High
- Shadow Quality: Medium
- Anti-Aliasing: FXAA or TAA
- V-Sync: Off (use FreeSync if available)

**AMD-Specific:**
- Enable FreeSync in monitor settings
- Use Radeon Anti-Lag (enabled by default)

### GPU Control

#### Using CoreCtrl

```bash
corectrl
```

1. Enable performance mode
2. Adjust fan curve
3. Monitor temperatures

#### Using LACT

```bash
sudo systemctl start lactd
lact
```

More detailed GPU control interface

---

## Game Modding

### Nexus Mods App (Recommended)

The official Nexus Mods app now supports Linux:

```bash
# Download from https://www.nexusmods.com/app
# Currently supports Cyberpunk 2077
```

### SteamTinkerLaunch (For Vortex/MO2)

#### Install SteamTinkerLaunch

Already installed in your system!

#### Configure for Fallout 4

1. Right-click Fallout 4 → Properties
2. Launch Options:
   ```
   steamtinkerlaunch %command%
   ```

3. Launch game once to create prefix

4. SteamTinkerLaunch menu will appear:
   - Select "Vortex" or "Mod Organizer 2"
   - Install mod manager
   - Configure mods

#### Supported Games

- Fallout 3, NV, 4
- Skyrim, Skyrim SE
- Oblivion
- Cyberpunk 2077
- The Witcher 3
- And many more...

### Manual Modding

For games without mod manager support:

1. Locate game directory:
   ```bash
   cd ~/.steam/steam/steamapps/common/[GAME_NAME]
   ```

2. Install mods manually to game directory

3. Use Proton prefix for Windows-specific mods:
   ```bash
   cd ~/.steam/steam/steamapps/compatdata/[GAME_ID]/pfx
   ```

---

## Troubleshooting

### Game Won't Launch

**Check Proton logs:**
```bash
# Enable logging
PROTON_LOG=1 steam

# Logs saved to: ~/steam-[APPID].log
```

**Try different Proton version:**
1. Right-click game → Properties → Compatibility
2. Force specific Proton version
3. Try Proton-GE

### Poor Performance

**Check if GameMode is active:**
```bash
gamemoded -s
```

**Verify GPU is being used:**
```bash
glxinfo | grep "OpenGL renderer"
# Should show: AMD Radeon RX 580
```

**Check CPU governor:**
```bash
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
# Should show: performance
```

### Shader Compilation Stuttering

**Solution**: Use DXVK async
```
DXVK_ASYNC=1 %command%
```

**Or**: Let shaders compile first
- Play game for 10-15 minutes
- Stuttering will decrease as shaders compile

### Game Crashes

**Check system logs:**
```bash
journalctl -xe | grep steam
```

**Verify game files:**
1. Right-click game → Properties
2. Local Files → Verify integrity of game files

**Try different Proton version:**
- Some games work better with specific Proton versions
- Check ProtonDB for recommendations

### Audio Issues

**Check PipeWire:**
```bash
systemctl --user status pipewire
```

**Restart audio:**
```bash
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Controller Not Working

**Check if detected:**
```bash
ls /dev/input/js*
```

**Test controller:**
```bash
jstest /dev/input/js0
```

**Steam Input:**
- Settings → Controller → General Controller Settings
- Enable controller support

---

## Performance Tips

### 1. Close Background Applications

Before gaming:
```bash
# Close unnecessary apps
# Keep only essential services running
```

### 2. Use Dedicated Gaming Workspace

Press `Mod+5` to switch to gaming workspace

### 3. Disable Compositor (If Needed)

For maximum performance:
```bash
# Niri is already optimized, but you can use gamescope
gamescope -f -- %command%
```

### 4. Monitor Temperatures

Keep an eye on temps:
```bash
watch -n 1 sensors
```

Ideal temps:
- CPU: < 80°C
- GPU: < 85°C

### 5. Update Drivers Regularly

```bash
cd ~/nixos-config
nix flake update
sudo nixos-rebuild switch --flake .#snaps-pc
```

---

## Game-Specific Guides

### Cyberpunk 2077

**Optimal Settings:**
- Texture Quality: High
- Ray Tracing: Off (RX 580 doesn't support RT)
- FSR: Quality mode
- DLSS: Not available (NVIDIA only)

**Mods:**
- Use Nexus Mods App
- Recommended: Cyber Engine Tweaks

### The Division 2

**Optimal Settings:**
- Resolution: 1920x1080
- Graphics: High
- V-Sync: Off
- Frame Rate Limit: Unlimited

**Tips:**
- Disable DX12 if crashes occur
- Use Proton-GE

### Fallout 4

**Modding:**
- Use SteamTinkerLaunch + Vortex
- Install F4SE through Vortex
- Use Mod Organizer 2 for advanced modding

**Performance:**
- Cap FPS to 60 (physics tied to framerate)
- Use texture optimization mods

---

## Useful Commands

```bash
# List installed games
steam -list

# Launch game directly
steam steam://rungameid/[APPID]

# Check Proton version
steam -version

# Clear shader cache
rm -rf ~/.steam/steam/steamapps/shadercache

# Clear download cache
steam -clearcache

# Verify game files
steam -validate [APPID]
```

---

## Resources

- **ProtonDB**: https://www.protondb.com/ - Game compatibility database
- **Steam Deck Verified**: Games verified for Linux
- **Nexus Mods**: https://www.nexusmods.com/ - Mod repository
- **PCGamingWiki**: https://www.pcgamingwiki.com/ - Game fixes and tweaks

---

## Quick Reference

### Launch Option Templates

**Basic:**
```
RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
```

**With MangoHud:**
```
mangohud RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
```

**With Gamescope:**
```
gamescope -w 1920 -h 1080 -f -- RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
```

**For Modding:**
```
steamtinkerlaunch %command%
```

---

**Happy Gaming! 🎮**

For more help, join the WehttamSnaps Discord: https://discord.gg/nTaknDvdUA