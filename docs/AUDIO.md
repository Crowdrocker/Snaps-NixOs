# Audio Routing Guide - WehttamSnaps NixOS Setup

This guide covers advanced audio routing using PipeWire and qpwgraph, similar to Voicemeeter on Windows.

## 🎵 Overview

We use **PipeWire** as the audio server with **qpwgraph** as the GUI for audio routing. This provides:
- **Application isolation**: Separate game, chat, music, and system sounds
- **Virtual devices**: Create custom audio sinks/sources
- **Real-time routing**: Visual audio graph manipulation
- **Recording capabilities**: Route any audio to recording software

## 🔧 Setup

### 1. Install Audio Tools
```bash
# Install required packages
nix-env -iA nixos.qpwgraph
nix-env -iA nixos.helvum
nix-env -iA nixos.pavucontrol
```

### 2. Start Services
```bash
# Ensure PipeWire is running
systemctl --user enable pipewire.service
systemctl --user enable wireplumber.service
systemctl --user start pipewire.service
systemctl --user start wireplumber.service
```

## 🎯 Audio Routing Scenarios

### Scenario 1: Gaming + Discord + Spotify
```
[Game Audio] ──┐
               ├── [Gaming Mix] ─── [Headphones]
[Discord] -----┤
               ├── [Chat Mix] ───── [Stream Output]
[Spotify] -----┘
```

### Scenario 2: Streaming Setup
```
[Game Audio] ──┐
               ├── [Stream Mix] ─── [OBS/Recording]
[Mic] ----------┤
               ├── [Monitor] ───── [Headphones]
[System] ------┘
```

### Scenario 3: Dual Monitor Setup
```
[Game 1] ──┐
           ├── [Monitor 1] ─── [Headphones]
[Game 2] ──┤
           ├── [Monitor 2] ─── [Speakers]
[Chat] ----┘
```

## 🎛️ Using qpwgraph

### Basic Interface
1. **Nodes**: Represent applications/devices (squares)
2. **Ports**: Input/output connections (circles)
3. **Connections**: Audio flow between ports (lines)

### Creating Virtual Devices

#### 1. Create Gaming Sink
```bash
# Create virtual gaming sink
pactl load-module module-null-sink sink_name=gaming_sink sink_properties=device.description="Gaming Audio"

# Create virtual chat sink
pactl load-module module-null-sink sink_name=chat_sink sink_properties=device.description="Chat Audio"
```

#### 2. Create Monitor Source
```bash
# Create monitor for streaming
pactl load-module module-null-sink sink_name=stream_mix sink_properties=device.description="Stream Mix"
```

### Routing Applications

#### Via qpwgraph GUI:
1. **Launch qpwgraph**: `qpwgraph &`
2. **Drag connections**: Connect app outputs to desired sinks
3. **Monitor levels**: Check volume levels in real-time
4. **Save presets**: Save graph configurations

#### Via pavucontrol:
1. **Launch pavucontrol**: `pavucontrol &`
2. **Playback tab**: Set default output for each application
3. **Recording tab**: Set input sources for recording apps
4. **Output devices**: Manage virtual sinks

## 📋 Common Routing Patterns

### Pattern 1: Game + Discord + Stream
```bash
# Create sinks
pactl load-module module-null-sink sink_name=game_audio
pactl load-module module-null-sink sink_name=discord_audio
pactl load-module module-null-sink sink_name=stream_mix

# Route applications
# In qpwgraph:
# - Connect game output to game_audio sink
# - Connect Discord to discord_audio sink
# - Mix both to stream_mix for OBS
```

### Pattern 2: Music Separation
```bash
# Music-only sink
pactl load-module module-null-sink sink_name=music_only

# Route Spotify to music_only
# In pavucontrol, set Spotify output to music_only
```

### Pattern 3: Recording Setup
```bash
# Recording sink
pactl load-module module-null-sink sink_name=recording_mix

# Loopback for monitoring
pactl load-module module-loopback source=recording_mix.monitor sink=alsa_output.pci-0000_00_1f.3.analog-stereo
```

## 🔊 Audio Presets

### Gaming Preset
```bash
# Create gaming preset script
cat > ~/.config/audio/gaming-preset.sh << 'EOF'
#!/bin/bash
# Gaming audio preset
pactl load-module module-null-sink sink_name=gaming_mix
pactl load-module module-loopback source=gaming_mix.monitor sink=alsa_output.pci-0000_00_1f.3.analog-stereo
echo "Gaming audio preset loaded"
EOF
chmod +x ~/.config/audio/gaming-preset.sh
```

### Streaming Preset
```bash
# Create streaming preset script
cat > ~/.config/audio/streaming-preset.sh << 'EOF'
#!/bin/bash
# Streaming audio preset
pactl load-module module-null-sink sink_name=stream_mix
pactl load-module module-null-sink sink_name=chat_mix
pactl load-module module-loopback source=stream_mix.monitor sink=alsa_output.pci-0000_00_1f.3.analog-stereo
echo "Streaming audio preset loaded"
EOF
chmod +x ~/.config/audio/streaming-preset.sh
```

### Work Preset
```bash
# Create work preset script
cat > ~/.config/audio/work-preset.sh << 'EOF'
#!/bin/bash
# Work audio preset
pactl load-module module-null-sink sink_name=work_mix
pactl load-module module-null-sink sink_name=music_mix
echo "Work audio preset loaded"
EOF
chmod +x ~/.config/audio/work-preset.sh
```

## 🎙️ Microphone Setup

### Noise Reduction
```bash
# Install noise reduction
nix-env -iA nixos.noise-suppression-for-voice

# Create noise suppression sink
pactl load-module module-ladspa-sink sink_name=mic_processed master=alsa_input.pci-0000_00_1f.3.analog-stereo plugin=noise_suppression label=noise_suppression_mono control=50,50
```

### Echo Cancellation
```bash
# Create echo cancellation
pactl load-module module-echo-cancel source_master=mic_processed sink_master=alsa_output.pci-0000_00_1f.3.analog-stereo
```

## 📊 Monitoring Audio

### Check Audio Levels
```bash
# Real-time audio levels
pactl list sink-inputs
pactl list source-outputs

# Volume control
pactl set-sink-volume @DEFAULT_SINK@ 50%
pactl set-source-volume @DEFAULT_SOURCE@ 75%
```

### Audio Troubleshooting
```bash
# Reset audio
systemctl --user restart pipewire.service
systemctl --user restart wireplumber.service

# Check audio devices
pactl list short sinks
pactl list short sources

# Remove unused modules
pactl unload-module <module-number>
```

## 🎮 J.A.R.V.I.S. Audio Integration

### Voice Commands
```bash
# J.A.R.V.I.S. audio commands
jarvis audio volume-up
jarvis audio volume-down
jarvis audio mute
```

### Audio Profiles
```bash
# Switch audio profiles via J.A.R.V.I.S.
jarvis gaming      # Load gaming preset
jarvis streaming   # Load streaming preset
jarvis work        # Load work preset
```

## 📱 Mobile Integration

### Remote Control
```bash
# Install KDE Connect
nix-env -iA nixos.kdeconnect

# Connect mobile device for audio control
# Use KDE Connect app to control volume, skip tracks, etc.
```

## 🔄 Automation

### Auto-switch Audio Profiles
```bash
# Create auto-switch script
cat > ~/.config/audio/auto-switch.sh << 'EOF'
#!/bin/bash
# Auto-switch audio profiles based on active applications

check_gaming() {
    if pgrep -f "steam|lutris|heroic" > /dev/null; then
        ~/.config/audio/gaming-preset.sh
    fi
}

check_streaming() {
    if pgrep -f "obs" > /dev/null; then
        ~/.config/audio/streaming-preset.sh
    fi
}

# Run checks
check_gaming
check_streaming
EOF
chmod +x ~/.config/audio/auto-switch.sh
```

## 🎵 Quick Reference

### Essential Commands
```bash
# Launch audio tools
qpwgraph          # Visual audio routing
pavucontrol       # Volume control
helvum            # Alternative audio routing

# Audio control
pactl set-sink-volume @DEFAULT_SINK@ 75%
pactl set-sink-mute @DEFAULT_SINK@ toggle
pactl set-source-volume @DEFAULT_SOURCE@ 80%

# List devices
pactl list short sinks
pactl list short sources
```

### Keyboard Shortcuts
- **Volume Up**: `Mod+F2`
- **Volume Down**: `Mod+F1`
- **Mute**: `Mod+F3`
- **Audio Settings**: `Mod+Shift+A`

---

## 📞 Support

- **Discord**: [WehttamSnaps Discord](https://discord.gg/nTaknDvdUA)
- **Issues**: [GitHub Issues](https://github.com/Crowdrocker/Snaps-NixOS/issues)
- **Wiki**: [Audio Setup Wiki](https://github.com/Crowdrocker/Snaps-NixOS/wiki/Audio-Setup)

---

<p align="center">
  <strong>🎵 Happy Gaming & Streaming! 🎮</strong>
</p>