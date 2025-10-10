# Streaming Guide - WehttamSnaps NixOS Setup

Complete streaming setup guide for OBS Studio with advanced audio routing.

## 🎬 Overview

This setup provides professional streaming capabilities with:
- **OBS Studio** with custom scenes
- **Advanced audio routing** via qpwgraph
- **Multi-source mixing** (game, mic, music, alerts)
- **Stream keybindings** and shortcuts
- **Custom overlays** and branding

## 🚀 Quick Setup

### 1. Install OBS Studio
```bash
# OBS Studio is pre-installed
# Launch: Applications → Multimedia → OBS Studio
# Or: obs &
```

### 2. Audio Setup
```bash
# Ensure audio routing is configured
qpwgraph &
```

### 3. Launch Streaming Mode
```bash
# Activate streaming mode
jarvis streaming

# Or manually
obs &
```

## 🎙️ Audio Routing for Streaming

### Virtual Audio Devices
```bash
# Create streaming audio sink
pactl load-module module-null-sink sink_name=stream_mix sink_properties=device.description="Stream Mix"

# Create monitor sink
pactl load-module module-null-sink sink_name=monitor_mix sink_properties=device.description="Monitor Mix"

# Create chat sink
pactl load-module module-null-sink sink_name=chat_mix sink_properties=device.description="Chat Audio"
```

### Audio Routing Diagram
```
[Game Audio] ──┐
               ├── [Stream Mix] ─── [OBS Audio Input]
[Microphone] ──┤
               ├── [Monitor Mix] ── [Headphones]
[Music] -------┤
               ├── [Chat Mix] ───── [Discord/Chat]
[System] ------┘
```

## 📹 OBS Studio Configuration

### Scene Setup

#### Scene 1: Gaming
```
Sources:
├── Game Capture (Primary)
├── Webcam (Bottom-right corner)
├── Alerts (Top-center)
├── Chat Box (Left side)
└── Stream Info (Top-right)
```

#### Scene 2: Just Chatting
```
Sources:
├── Webcam (Center)
├── Chat Box (Right side)
├── Recent Followers (Left side)
├── Stream Info (Top)
└── Background (Animated/Static)
```

#### Scene 3: BRB/AFK
```
Sources:
├── BRB Message (Center)
├── Music Visualizer
├── Chat Box (Bottom)
└── Social Media Links
```

#### Scene 4: Starting Soon
```
Sources:
├── Countdown Timer
├── Background Video
├── Social Media Links
├── Recent Donations
└── Stream Schedule
```

### Audio Sources

#### Primary Audio Sources
1. **Desktop Audio** (Game sounds, system audio)
2. **Microphone** (Voice commentary)
3. **Music** (Background music)
4. **Alerts** (Followers, donations, subs)

#### Audio Routing in OBS
```
OBS Audio Sources:
├── Desktop Audio → Stream Mix
├── Mic/Aux → Microphone
├── Music → Music Source
├── Alerts → Alert Source
└── Chat → Chat Source
```

### Stream Settings

#### Video Settings
```yaml
Base (Canvas) Resolution: 1920x1080
Output (Scaled) Resolution: 1280x720
FPS: 60
```

#### Output Settings
```yaml
Encoder: x264 (CPU)
Bitrate: 6000 kbps
Keyframe Interval: 2
Preset: veryfast
Profile: high
```

#### Audio Settings
```yaml
Sample Rate: 48 kHz
Channels: Stereo
Desktop Audio: Stream Mix
Mic/Aux: Microphone
```

## 🎛️ Audio Configuration

### OBS Audio Routing

#### 1. Desktop Audio Setup
```bash
# Route desktop audio to OBS
# In OBS → Settings → Audio
# Desktop Audio: Stream Mix
```

#### 2. Microphone Setup
```bash
# Microphone settings in OBS
# Filters:
# - Noise Suppression (-30dB)
# - Noise Gate (-35dB open, -40dB close)
# - Compressor (3:1 ratio, -18dB threshold)
```

#### 3. Music Setup
```bash
# Music source routing
# Create music sink for Spotify
pactl load-module module-null-sink sink_name=music_source sink_properties=device.description="Music Source"
```

#### 4. Alert Sounds
```bash
# Alert audio routing
# Create alert sink
pactl load-module module-null-sink sink_name=alert_source sink_properties=device.description="Alert Source"
```

## 🎮 Game Capture Setup

### Game Capture Sources

#### Method 1: Game Capture (Recommended)
```
OBS Source: Game Capture
├── Mode: Capture specific window
├── Window: [Select game window]
├── Capture Cursor: Yes
├── Multi-adapter Compatibility: Yes (for multi-GPU)
└── Capture Method: Automatic
```

#### Method 2: Display Capture
```
OBS Source: Display Capture
├── Display: [Primary monitor]
├── Capture Cursor: Yes
└── Show cursor: Yes
```

#### Method 3: Window Capture
```
OBS Source: Window Capture
├── Window: [Select game window]
├── Capture Method: Automatic
└── Cursor: Yes
```

### Game-Specific Settings

#### Cyberpunk 2077
```
Window Mode: Borderless
Resolution: 1920x1080
VSync: Off
OBS Capture: Game Capture
```

#### The Division 2
```
Window Mode: Fullscreen
Resolution: 1920x1080
VSync: Off
OBS Capture: Game Capture
```

## 🎨 Custom Overlays

### Branding Elements
- **Logo**: WehttamSnaps logo (top-left)
- **Color Scheme**: Violet-cyan gradient (#8A2BE2 → #00FFFF)
- **Font**: Inter, JetBrains Mono
- **Animations**: Smooth transitions

### Alert Widgets
```bash
# Install StreamElements
# Visit: https://streamelements.com/dashboard
# Copy widget URLs to OBS Browser Source
```

### Custom Alerts
```
Browser Source: Stream Alerts
├── URL: [Your StreamElements URL]
├── Width: 1920
├── Height: 1080
├── FPS: 30
└── Shutdown source when not visible: Yes
```

## ⌨️ Stream Keybindings

### OBS Keybindings
```
Start Streaming: Ctrl+F1
Stop Streaming: Ctrl+Shift+F1
Start Recording: Ctrl+F2
Stop Recording: Ctrl+Shift+F2
Mute/Unmute Mic: Ctrl+M
Mute/Unmute Desktop: Ctrl+D
```

### J.A.R.V.I.S. Commands
```bash
# Streaming shortcuts
jarvis streaming                    # Activate streaming mode
jarvis launch obs                  # Launch OBS
jarvis audio volume-up             # Increase volume
jarvis audio volume-down           # Decrease volume
jarvis audio mute                  # Mute/unmute
```

### System Keybindings
```
Mod+Shift+S: Start/Stop Streaming
Mod+Shift+R: Start/Stop Recording
Mod+M: Mute/Unmute Mic
Mod+D: Mute/Unmute Desktop
```

## 📊 Stream Monitoring

### Performance Monitoring
```bash
# Check system resources
htop
radeontop
nvtop

# Check network
speedtest-cli
ping twitch.tv
```

### Stream Health
```bash
# Check stream status
curl -s https://api.twitch.tv/helix/streams?user_login=wehttamsnaps
```

## 🎵 Advanced Audio Features

### Noise Suppression
```bash
# Install noise suppression
nix-env -iA nixos.noise-suppression-for-voice

# Create noise suppression filter
pactl load-module module-ladspa-sink sink_name=mic_clean master=alsa_input.pci-0000_00_1f.3.analog-stereo plugin=noise_suppression label=noise_suppression_mono control=50,50
```

### Echo Cancellation
```bash
# Create echo cancellation
pactl load-module module-echo-cancel source_master=mic_clean sink_master=alsa_output.pci-0000_00_1f.3.analog-stereo
```

### Compressor Settings
```
Compressor Settings:
├── Ratio: 3:1
├── Threshold: -18dB
├── Attack: 6ms
├── Release: 60ms
└── Makeup Gain: +6dB
```

## 🎮 Game-Specific Streaming Settings

### Cyberpunk 2077
```yaml
Game Settings:
  Resolution: 1920x1080
  Graphics: Medium
  VSync: Off
  FPS Limit: 60

OBS Settings:
  Capture: Game Capture
  Audio: Desktop Audio
  Bitrate: 6000 kbps
```

### The Division 2
```yaml
Game Settings:
  Resolution: 1920x1080
  Graphics: High
  VSync: Off
  FPS Limit: 60

OBS Settings:
  Capture: Game Capture
  Audio: Desktop Audio
  Bitrate: 6000 kbps
```

### Fallout 4
```yaml
Game Settings:
  Resolution: 1920x1080
  Graphics: High
  VSync: Off
  FPS Limit: 60

OBS Settings:
  Capture: Game Capture
  Audio: Desktop Audio
  Bitrate: 6000 kbps
```

## 📱 Mobile Integration

### Stream Deck Mobile
```bash
# Install companion app
# Download from app store
# Connect to OBS via WebSocket
```

### Remote Control
```bash
# Install OBS WebSocket
# Configure in OBS → Tools → WebSocket Server Settings
# Port: 4455
# Password: [Set secure password]
```

## 🔧 Troubleshooting

### Common Issues

#### Stream Lag/Stuttering
```bash
# Check CPU usage
htop

# Check GPU usage
radeontop

# Check network
speedtest-cli
```

#### Audio Desync
```bash
# Restart audio services
systemctl --user restart pipewire.service
systemctl --user restart wireplumber.service
```

#### OBS Crashes
```bash
# Check OBS logs
cat ~/.config/obs-studio/logs/latest.log

# Reset OBS settings
mv ~/.config/obs-studio ~/.config/obs-studio.backup
```

### Performance Optimization
```bash
# Reduce OBS load
# Use NVENC if available
# Lower game settings
# Close unnecessary applications
```

## 📊 Analytics

### Stream Metrics
- **Viewers**: Live viewer count
- **Followers**: New followers per stream
- **Chat Activity**: Messages per minute
- **Stream Duration**: Total stream time

### Export Settings
```yaml
Recording Settings:
  Format: mp4
  Encoder: x264
  Bitrate: 8000 kbps
  Resolution: 1920x1080
  FPS: 60
```

## 🎉 Custom Features

### J.A.R.V.I.S. Integration
```bash
# Voice alerts
jarvis streaming        # Activate streaming mode
jarvis alert "New follower!"  # Custom alerts

# System notifications
jarvis notify "Stream starting in 5 minutes"
```

### Custom Scripts
```bash
# Stream start script
~/.config/obs/scripts/stream-start.sh

# Stream end script
~/.config/obs/scripts/stream-end.sh
```

---

<p align="center">
  <strong>🎬 Happy Streaming! 📺</strong>
</p>