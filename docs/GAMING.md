# Gaming Guide - WehttamSnaps NixOS Setup

Comprehensive gaming setup guide for AMD RX 580 with NixOS.

## 🎮 Overview

This setup provides optimal gaming performance for AMD RX 580 with:
- **AMD GPU optimizations** (CoreCtrl, LACT)
- **Gaming mode** with automatic performance tuning
- **Steam integration** with custom launch options
- **Multiple game launchers** (Steam, Lutris, Heroic)
- **Controller support** for all major gamepads

## 🔧 Hardware Setup

### GPU Information
- **Model**: AMD RX 580 (4GB/8GB)
- **Driver**: AMDGPU (open-source)
- **Vulkan**: RADV (AMD's Vulkan driver)
- **OpenGL**: Mesa 23.x+

### Performance Baseline
| Game | Resolution | Settings | Expected FPS |
|------|------------|----------|--------------|
| Cyberpunk 2077 | 1080p | Medium | 45-60 |
| The Division 2 | 1080p | High | 60-75 |
| Fallout 4 | 1080p | High | 60-80 |
| Warframe | 1080p | Ultra | 100+ |

## 🚀 Quick Setup

### 1. Enable Gaming Mode
```bash
# Activate gaming mode
jarvis gaming

# Or manually
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

### 2. Check GPU Status
```bash
# GPU information
radeontop
lact gui
```

### 3. Test Vulkan
```bash
# Vulkan info
vulkaninfo | grep "GPU id"
vkcube
```

## 🎯 Game Launchers

### Steam
**Installation**: Pre-installed via NixOS configuration
**Location**: Applications → Games → Steam

#### Steam Launch Options
```bash
# Global Steam options
STEAM_FORCE_DESKTOPUI_SCALING=1 %command%

# Per-game options (examples)
# Cyberpunk 2077:
gamemoderun %command% --launcher-skip -skipStartScreen

# Fallout 4:
gamemoderun %command% -windowed -noborder

# The Division:
gamemoderun %command% -windowed
```

### Lutris
**Installation**: Pre-installed
**Usage**: Applications → Games → Lutris

### Heroic Games Launcher
**Installation**: Pre-installed
**Usage**: Applications → Games → Heroic

### Bottles
**Installation**: Pre-installed
**Usage**: Applications → Games → Bottles

## 🎮 Game-Specific Configurations

### Cyberpunk 2077
**Settings File**: `~/.local/share/Steam/steamapps/compatdata/1091500/pfx/drive_c/users/steamuser/My Documents/CD Projekt Red/Cyberpunk 2077/UserSettings.json`

**Recommended Settings**:
```json
{
  "streaming": {
    "enabled": false,
    "max_memory_usage": 2048
  },
  "graphics": {
    "preset": "Medium",
    "vsync": false,
    "fps_limit": 60
  }
}
```

### Fallout 4
**Settings File**: `~/.local/share/Steam/steamapps/compatdata/377160/pfx/drive_c/users/steamuser/My Documents/My Games/Fallout4/Fallout4Prefs.ini`

**Recommended Settings**:
```ini
[Display]
iSize W=1920
iSize H=1080
bFull Screen=0
bBorderless=1
iPresentInterval=0
```

### The Division 2
**Settings File**: `~/.local/share/Steam/steamapps/compatdata/365590/pfx/drive_c/users/steamuser/My Documents/My Games/Tom Clancy's The Division 2/Settings.xml`

## 🕹️ Controller Support

### Xbox Controllers
```bash
# Xbox 360/One controllers
lsusb | grep -i xbox
```

### PlayStation Controllers
```bash
# PS4/PS5 controllers
lsusb | grep -i sony
```

### Steam Controller
```bash
# Check Steam controller
lsusb | grep -i steam
```

### Custom Controller Mapping
**Location**: `~/.config/steam-ctlr/`

## 🔧 GPU Optimization

### CoreCtrl
**Launch**: Applications → System → CoreCtrl

#### Recommended Settings
- **Performance Mode**: Gaming
- **Fan Curve**: Aggressive (30°C=25%, 60°C=50%, 80°C=100%)
- **Power Limit**: +50% (if supported)

### LACT
**Launch**: Terminal → `lact gui`

#### Key Settings
```bash
# Check current settings
lact show

# Set performance mode
lact set performance_level auto
lact set power_cap 130
```

### AMD GPU Tuning
```bash
# Enable performance mode
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# GPU performance
echo high | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level
```

## 🎮 Gaming Shortcuts

### Keyboard Shortcuts
- **Gaming Mode**: `Mod+Shift+G`
- **Steam**: `Mod+G`
- **Lutris**: `Mod+Shift+L`
- **Controller Settings**: `Mod+Shift+C`

### J.A.R.V.I.S. Commands
```bash
# Launch games
jarvis launch steam
jarvis launch lutris
jarvis launch cyberpunk
jarvis launch fallout4

# Gaming mode
jarvis gaming
```

## 🎯 Performance Monitoring

### Real-time Monitoring
```bash
# GPU monitoring
radeontop
watch -n 1 cat /sys/class/drm/card0/device/gpu_busy_percent

# System monitoring
htop
nvtop
```

### Performance Tools
- **MangoHUD**: In-game overlay
- **GOverlay**: MangoHUD configuration GUI
- **CoreCtrl**: AMD GPU control
- **LACT**: AMD GPU tuning

### Benchmarking
```bash
# Install benchmarks
nix-env -iA nixos.glmark2
nix-env -iA nixos.unigine-valley

# Run benchmarks
glmark2
```

## 🎮 Game Library

### Installed Games
| Game | Platform | Status | Notes |
|------|----------|--------|-------|
| **Call of Duty HQ** | Steam | ✅ Working | DX11 mode |
| **Cyberpunk 2077** | Steam | ✅ Working | Medium settings |
| **Fallout 4** | Steam | ✅ Working | Proton GE |
| **FarCry 5** | Steam | ✅ Working | Vulkan |
| **Ghost Recon Breakpoint** | Steam | ✅ Working | DXVK |
| **Marvel's Avengers** | Steam | ✅ Working | Proton |
| **Need for Speed Payback** | Steam | ✅ Working | Proton |
| **Rise of the Tomb Raider** | Steam | ✅ Working | DXVK |
| **Shadow of the Tomb Raider** | Steam | ✅ Working | DXVK |
| **The First Descendant** | Steam | ✅ Working | Proton |
| **Tom Clancy's The Division** | Steam | ✅ Working | DXVK |
| **Tom Clancy's The Division 2** | Steam | ✅ Working | Vulkan |
| **Warframe** | Steam | ✅ Working | Native |
| **Watch_Dogs** | Steam | ✅ Working | DXVK |
| **Watch_Dogs 2** | Steam | ✅ Working | DXVK |
| **WatchDogs_Legion** | Steam | ✅ Working | DXVK |

## 🛠️ Troubleshooting

### Common Issues

#### Game Won't Launch
```bash
# Check Proton version
# Try Proton GE
# Verify game files
```

#### Low FPS
```bash
# Check GPU usage
radeontop

# Check CPU governor
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Check VRAM usage
nvtop
```

#### Controller Not Working
```bash
# Check device
lsusb | grep -i controller

# Test input
evtest
```

#### Audio Issues
```bash
# Check audio devices
pactl list short sinks
pactl list short sources
```

### Proton Versions
- **Proton Experimental**: Latest features
- **Proton GE**: Custom build with patches
- **Proton 8.0**: Stable version

## 🔄 Updates & Maintenance

### Game Updates
```bash
# Update Steam
steam --reset

# Update Proton
# Via Steam settings → Steam Play → Proton version
```

### System Updates
```bash
# Update system
./install.sh --update

# Update GPU drivers
nixos-rebuild switch --upgrade
```

## 🎮 Game Modding

### Nexus Mods
**Installation**: Pre-installed via Flatpak
**Location**: Applications → Games → Nexus Mods

### SteamTinkerLaunch
```bash
# Install SteamTinkerLaunch
nix-env -iA nixos.steamtinkerlaunch

# Enable for specific games
# Right-click game → Properties → Compatibility → SteamTinkerLaunch
```

### Mod Organizer 2
```bash
# Install via Lutris
# Add MO2 installer from Lutris
```

## 📊 Performance Tips

### CPU Optimization
```bash
# CPU governor
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# CPU affinity
taskset -c 0-3 game_command
```

### Memory Optimization
```bash
# Check memory
free -h

# Clear cache
sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
```

### GPU Optimization
```bash
# VRAM check
radeontop

# GPU clock
lact set core_clock 1400
lact set memory_clock 2000
```

## 🎯 Quick Commands

### Gaming Mode
```bash
# Activate gaming mode
jarvis gaming

# Check system status
jarvis monitor

# Launch games
jarvis launch steam
```

### Performance Check
```bash
# System info
neofetch
radeontop
htop

# Temperature check
sensors
```

---

<p align="center">
  <strong>🎮 Happy Gaming! 🕹️</strong>
</p>