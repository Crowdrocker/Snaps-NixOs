# WehttamSnaps NixOS Troubleshooting Guide

Common issues and solutions for your NixOS setup.

## Table of Contents
1. [Installation Issues](#installation-issues)
2. [Boot Issues](#boot-issues)
3. [Niri Issues](#niri-issues)
4. [Audio Issues](#audio-issues)
5. [Gaming Issues](#gaming-issues)
6. [Performance Issues](#performance-issues)
7. [Hardware Issues](#hardware-issues)

---

## Installation Issues

### Issue: Build fails with "error: attribute 'X' missing"

**Cause**: Missing or incorrect configuration

**Solution**:
```bash
# Check flake.lock exists
ls flake.lock

# If missing, create it
nix flake lock

# Try building again
sudo nixos-rebuild switch --flake .#snaps-pc
```

### Issue: "No such file or directory" for hardware-configuration.nix

**Cause**: Hardware configuration not generated

**Solution**:
```bash
# Generate hardware configuration
sudo nixos-generate-config --show-hardware-config > hosts/snaps-pc/hardware-configuration.nix

# Verify it was created
cat hosts/snaps-pc/hardware-configuration.nix
```

### Issue: Build takes forever / appears stuck

**Cause**: First build downloads and compiles many packages

**Solution**:
- This is normal! First build takes 30-60 minutes
- Check progress: `journalctl -f`
- Be patient, subsequent builds are much faster

### Issue: "Permission denied" errors

**Cause**: Running as wrong user or missing sudo

**Solution**:
```bash
# Don't run as root
# Use sudo for system commands only
sudo nixos-rebuild switch --flake .#snaps-pc

# For user commands, don't use sudo
nix flake update
```

---

## Boot Issues

### Issue: System won't boot after installation

**Cause**: Bootloader misconfiguration

**Solution**:
1. Boot from NixOS USB
2. Mount your system:
   ```bash
   sudo mount /dev/sda2 /mnt
   sudo mount /dev/sda1 /mnt/boot
   ```
3. Chroot and reinstall bootloader:
   ```bash
   sudo nixos-enter
   nixos-rebuild switch
   ```

### Issue: "No bootable device" error

**Cause**: EFI boot entry not created

**Solution**:
```bash
# Check EFI entries
efibootmgr -v

# Recreate entry
sudo efibootmgr -c -d /dev/sda -p 1 -L "NixOS" -l '\EFI\nixos\systemd-bootx64.efi'
```

### Issue: Dual-boot not showing Windows

**Cause**: OS-Prober not detecting Windows

**Solution**:
In `configuration.nix`, ensure:
```nix
boot.loader.grub.useOSProber = true;
```

Then rebuild:
```bash
sudo nixos-rebuild switch --flake .#snaps-pc
```

---

## Niri Issues

### Issue: Niri won't start / black screen

**Cause**: Various compositor issues

**Solution 1**: Check logs
```bash
journalctl -xe | grep niri
```

**Solution 2**: Try starting manually
```bash
# From TTY (Ctrl+Alt+F2)
niri
```

**Solution 3**: Check configuration
```bash
# Validate Niri config
niri validate ~/.config/niri/config.kdl
```

### Issue: Keybindings not working

**Cause**: Configuration syntax error or conflict

**Solution**:
```bash
# Check Niri config syntax
niri validate ~/.config/niri/keybinds.kdl

# Reload configuration
# Press: Mod+Shift+R
# Or from terminal:
niri msg reload-config
```

### Issue: Windows not tiling correctly

**Cause**: Window rules or layout configuration

**Solution**:
```bash
# Check window rules
cat ~/.config/niri/window-rules.kdl

# Test with default config
mv ~/.config/niri ~/.config/niri.backup
niri
```

### Issue: Niri crashes randomly

**Cause**: GPU driver issue or memory leak

**Solution**:
```bash
# Check system logs
journalctl -xe

# Update Mesa drivers
cd ~/nixos-config
nix flake update
sudo nixos-rebuild switch --flake .#snaps-pc

# Check GPU status
glxinfo | grep "OpenGL renderer"
```

---

## Audio Issues

### Issue: No audio output

**Cause**: PipeWire not running or misconfigured

**Solution 1**: Restart PipeWire
```bash
systemctl --user restart pipewire pipewire-pulse wireplumber
```

**Solution 2**: Check PipeWire status
```bash
systemctl --user status pipewire
pactl info
```

**Solution 3**: Check output device
```bash
# List sinks
pactl list sinks short

# Set default sink
pactl set-default-sink [SINK_NAME]
```

### Issue: Audio crackling or stuttering

**Cause**: Buffer size too small

**Solution**:
Edit `~/.config/pipewire/pipewire.conf`:
```
default.clock.quantum = 2048
default.clock.min-quantum = 1024
```

Then restart:
```bash
systemctl --user restart pipewire
```

### Issue: Virtual sinks not appearing

**Cause**: Configuration not loaded

**Solution**:
```bash
# Run setup script
bash /etc/audio-routing-setup.sh

# Verify sinks exist
pactl list sinks short | grep audio_sink

# Restart PipeWire
systemctl --user restart pipewire wireplumber
```

### Issue: Application audio not routing correctly

**Cause**: WirePlumber rules not applied

**Solution**:
```bash
# Check WirePlumber status
systemctl --user status wireplumber

# Restart WirePlumber
systemctl --user restart wireplumber

# Manually route application
pactl move-sink-input [ID] [SINK_NAME]
```

### Issue: Microphone not working

**Cause**: Wrong input device or permissions

**Solution**:
```bash
# List sources
pactl list sources short

# Set default source
pactl set-default-source [SOURCE_NAME]

# Test microphone
arecord -f cd test.wav
# Press Ctrl+C to stop
aplay test.wav
```

---

## Gaming Issues

### Issue: Steam won't launch

**Cause**: Missing dependencies or runtime issues

**Solution 1**: Check Steam runtime
```bash
steam-runtime
```

**Solution 2**: Clear Steam cache
```bash
rm -rf ~/.steam/steam/appcache
```

**Solution 3**: Reinstall Steam
```bash
cd ~/nixos-config
# Comment out steam in configuration.nix
sudo nixos-rebuild switch --flake .#snaps-pc
# Uncomment steam
sudo nixos-rebuild switch --flake .#snaps-pc
```

### Issue: Game won't launch

**Cause**: Proton compatibility or missing dependencies

**Solution 1**: Check ProtonDB
- Visit https://www.protondb.com/
- Search for your game
- Check recommended Proton version and fixes

**Solution 2**: Try different Proton version
1. Right-click game → Properties
2. Compatibility → Force specific Proton version
3. Try: Proton Experimental, Proton-GE, or older versions

**Solution 3**: Enable Proton logs
```bash
# Add to launch options
PROTON_LOG=1 %command%

# Check logs
cat ~/steam-[APPID].log
```

### Issue: Game crashes during gameplay

**Cause**: Various (GPU, memory, Proton)

**Solution 1**: Check system logs
```bash
journalctl -xe | grep steam
dmesg | tail -50
```

**Solution 2**: Verify game files
1. Right-click game → Properties
2. Local Files → Verify integrity of game files

**Solution 3**: Reduce graphics settings
- Lower resolution
- Disable ray tracing
- Reduce texture quality

### Issue: Poor FPS / stuttering

**Cause**: Not using GameMode or wrong settings

**Solution 1**: Activate GameMode
```bash
# Press: Mod+Shift+G
# Or add to launch options:
gamemoderun %command%
```

**Solution 2**: Check GPU usage
```bash
# Monitor GPU
nvtop

# Check if GPU is being used
glxinfo | grep "OpenGL renderer"
```

**Solution 3**: Optimize launch options
```bash
# Use recommended options
RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
```

### Issue: Shader compilation stuttering

**Cause**: Shaders compiling on-the-fly

**Solution 1**: Enable DXVK async
```bash
# Add to launch options
DXVK_ASYNC=1 %command%
```

**Solution 2**: Pre-compile shaders
- Play game for 10-15 minutes
- Stuttering will decrease as shaders compile
- Compiled shaders are cached

**Solution 3**: Clear shader cache (if corrupted)
```bash
rm -rf ~/.steam/steam/steamapps/shadercache/[APPID]
```

### Issue: Controller not detected

**Cause**: Permissions or driver issue

**Solution 1**: Check if detected
```bash
ls /dev/input/js*
jstest /dev/input/js0
```

**Solution 2**: Enable Steam Input
- Settings → Controller
- General Controller Settings
- Enable controller support

**Solution 3**: Add user to input group
```bash
sudo usermod -aG input wehttamsnaps
# Logout and login
```

---

## Performance Issues

### Issue: System feels slow

**Cause**: CPU governor or background processes

**Solution 1**: Check CPU governor
```bash
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Should show: performance
# If not, activate gaming mode: Mod+Shift+G
```

**Solution 2**: Check running processes
```bash
htop
# Press F5 to show tree view
# Look for CPU-heavy processes
```

**Solution 3**: Check memory usage
```bash
free -h
# If swap is heavily used, close some applications
```

### Issue: High CPU temperature

**Cause**: Poor cooling or thermal paste

**Solution 1**: Monitor temperatures
```bash
watch -n 1 sensors
```

**Solution 2**: Check fan speeds
```bash
sensors | grep fan
```

**Solution 3**: Improve cooling
- Clean dust from case
- Reapply thermal paste (you already did this!)
- Improve case airflow
- Check fan curves in BIOS

### Issue: High GPU temperature

**Cause**: Poor cooling or high load

**Solution 1**: Monitor GPU temp
```bash
nvtop
# Or
watch -n 1 sensors
```

**Solution 2**: Adjust fan curve
```bash
# Use CoreCtrl
corectrl

# Or LACT
lact
```

**Solution 3**: Reduce GPU load
- Lower game graphics settings
- Cap framerate
- Improve case cooling

---

## Hardware Issues

### Issue: GPU not detected

**Cause**: Driver not loaded or hardware issue

**Solution 1**: Check GPU detection
```bash
lspci | grep VGA
# Should show: AMD RX 580
```

**Solution 2**: Check driver
```bash
lspci -k | grep -A 3 VGA
# Should show: amdgpu driver
```

**Solution 3**: Verify kernel module
```bash
lsmod | grep amdgpu
# Should show amdgpu module loaded
```

### Issue: Monitor not detected

**Cause**: Cable or output configuration

**Solution 1**: Check connected outputs
```bash
niri msg outputs
```

**Solution 2**: Try different cable/port
- Try different HDMI/DisplayPort cable
- Try different GPU output port

**Solution 3**: Update monitor config
Edit `~/.config/niri/config.kdl`:
```kdl
output "HDMI-A-1" {
    mode "1920x1080@60"
}
```

### Issue: USB devices not working

**Cause**: Power management or driver issue

**Solution 1**: Check USB devices
```bash
lsusb
```

**Solution 2**: Disable USB autosuspend
```bash
# Temporary
echo -1 | sudo tee /sys/module/usbcore/parameters/autosuspend

# Permanent: Add to configuration.nix
boot.kernelParams = [ "usbcore.autosuspend=-1" ];
```

### Issue: Network slow or unstable

**Cause**: Driver or configuration issue

**Solution 1**: Check network status
```bash
nmcli device status
ping -c 4 google.com
```

**Solution 2**: Restart NetworkManager
```bash
sudo systemctl restart NetworkManager
```

**Solution 3**: Check for packet loss
```bash
mtr google.com
# Press 'q' to quit
```

---

## General Troubleshooting Steps

### Step 1: Check Logs
```bash
# System logs
journalctl -xe

# Niri logs
journalctl -xe | grep niri

# Steam logs
cat ~/steam-*.log

# Kernel messages
dmesg | tail -50
```

### Step 2: Verify Configuration
```bash
# Check NixOS configuration
sudo nixos-rebuild dry-build --flake .#snaps-pc

# Check Niri configuration
niri validate ~/.config/niri/config.kdl
```

### Step 3: Restart Services
```bash
# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse wireplumber

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Restart display manager
sudo systemctl restart display-manager
```

### Step 4: Rollback Changes
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous
sudo nixos-rebuild switch --rollback

# Or specific generation
sudo nixos-rebuild switch --rollback --generation [NUMBER]
```

### Step 5: Clean and Rebuild
```bash
# Clean old generations
sudo nix-collect-garbage -d

# Update flake
cd ~/nixos-config
nix flake update

# Rebuild
sudo nixos-rebuild switch --flake .#snaps-pc
```

---

## Emergency Recovery

### Boot into Recovery Mode

1. Reboot system
2. At GRUB menu, select "NixOS (recovery)"
3. You'll get a root shell

### Fix Broken System

```bash
# Mount filesystems
mount -o remount,rw /

# Rollback to previous generation
nix-env --rollback --profile /nix/var/nix/profiles/system
/nix/var/nix/profiles/system/bin/switch-to-configuration switch

# Reboot
reboot
```

### Boot from USB

If system won't boot at all:

1. Boot from NixOS USB
2. Mount your system:
   ```bash
   sudo mount /dev/sda2 /mnt
   sudo mount /dev/sda1 /mnt/boot
   ```
3. Chroot into system:
   ```bash
   sudo nixos-enter
   ```
4. Fix configuration and rebuild
5. Reboot

---

## Getting Help

### Before Asking for Help

1. ✅ Check this troubleshooting guide
2. ✅ Search NixOS Discourse
3. ✅ Check GitHub issues
4. ✅ Read relevant documentation

### When Asking for Help

Include:
- **Error message** (full text)
- **What you were doing** when error occurred
- **System logs** (journalctl -xe)
- **Configuration** (relevant parts)
- **NixOS version** (nixos-version)
- **What you've tried** already

### Where to Get Help

- **Discord**: https://discord.gg/nTaknDvdUA
- **GitHub Issues**: https://github.com/Crowdrocker/Snaps-NixOs/issues
- **NixOS Discourse**: https://discourse.nixos.org/
- **Reddit**: r/NixOS

---

## Useful Commands

```bash
# System information
nixos-version
uname -a

# Hardware information
lspci
lsusb
lscpu
free -h

# Check services
systemctl status
systemctl --user status

# Monitor system
htop
btop
nvtop

# Check logs
journalctl -xe
journalctl -f
dmesg

# Network diagnostics
ping google.com
nmcli device status
ip addr

# Disk usage
df -h
du -sh *

# Process management
ps aux
pgrep [name]
pkill [name]
```

---

**Remember**: NixOS is declarative and reproducible. If something breaks, you can always rollback!

For more help, join the Discord: https://discord.gg/nTaknDvdUA