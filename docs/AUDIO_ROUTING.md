# WehttamSnaps Audio Routing Guide

Complete guide to setting up Voicemeter-like audio routing on Linux using PipeWire.

## Table of Contents
1. [Overview](#overview)
2. [Virtual Sinks Setup](#virtual-sinks-setup)
3. [Application Routing](#application-routing)
4. [OBS Configuration](#obs-configuration)
5. [Troubleshooting](#troubleshooting)

---

## Overview

### What is Audio Routing?

Audio routing allows you to separate different audio sources (games, browser, Discord, Spotify) into individual channels that you can control independently. This is similar to Voicemeter on Windows.

### Why Use Audio Routing?

- **Streaming**: Control game, music, and voice chat volumes independently in OBS
- **Recording**: Capture specific audio sources without background noise
- **Gaming**: Adjust Discord volume without affecting game audio
- **Flexibility**: Route any application to any output device

### How It Works

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│   Steam     │────▶│  Game Sink   │────▶│  Speakers    │
└─────────────┘     └──────────────┘     └──────────────┘
                           │
                           └────────────▶ OBS (Capture)

┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│   Firefox   │────▶│ Browser Sink │────▶│  Speakers    │
└─────────────┘     └──────────────┘     └──────────────┘
                           │
                           └────────────▶ OBS (Capture)

┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│   Discord   │────▶│ Discord Sink │────▶│  Speakers    │
└─────────────┘     └──────────────┘     └──────────────┘
                           │
                           └────────────▶ OBS (Capture)
```

---

## Virtual Sinks Setup

### Step 1: Run Setup Script

The virtual sinks are automatically created by your NixOS configuration, but you can manually create them:

```bash
bash /etc/audio-routing-setup.sh
```

This creates the following virtual sinks:
- **Game Audio** - For Steam games
- **Browser Audio** - For Firefox/Chrome
- **Discord Audio** - For Discord voice chat
- **Spotify Audio** - For music
- **OBS Audio** - For streaming output

### Step 2: Verify Sinks

Check that sinks were created:

```bash
pactl list sinks short
```

You should see:
```
game_audio_sink
browser_audio_sink
discord_audio_sink
spotify_audio_sink
obs_audio_sink
```

### Step 3: Open qpwgraph

Launch the PipeWire graph editor:

```bash
qpwgraph
```

Or press: `Mod+Shift+A`

---

## Application Routing

### Using qpwgraph (Visual Method)

qpwgraph shows a visual representation of all audio connections.

#### Understanding the Interface

- **Left side**: Audio sources (applications)
- **Right side**: Audio sinks (outputs)
- **Lines**: Active connections
- **Colors**: Different types of audio streams

#### Connecting Applications

1. **Find your application** on the left side
   - Example: "Firefox" or "Steam"

2. **Find the virtual sink** on the right side
   - Example: "browser_audio_sink"

3. **Drag a line** from application to sink
   - Click and hold on the application's output port
   - Drag to the sink's input port
   - Release to create connection

4. **Connect sink to speakers**
   - Find the virtual sink on the left side (it's now a source)
   - Connect it to your speakers/headphones on the right

#### Example: Route Firefox to Browser Sink

```
[Firefox] ──────▶ [browser_audio_sink] ──────▶ [Speakers]
  (app)              (virtual sink)              (hardware)
```

### Using pavucontrol (Simple Method)

For a simpler interface, use pavucontrol:

```bash
pavucontrol
```

Or press: `Mod+A`

#### Steps:

1. **Open pavucontrol**
2. **Go to "Playback" tab**
3. **Find your application** (e.g., Firefox)
4. **Click the dropdown** next to the application
5. **Select the virtual sink** (e.g., "Browser Audio")

#### Example Configuration:

| Application | Virtual Sink |
|-------------|--------------|
| Steam games | Game Audio |
| Firefox | Browser Audio |
| Discord | Discord Audio |
| Spotify | Spotify Audio |

---

## OBS Configuration

### Step 1: Add Audio Sources

In OBS Studio:

1. **Go to Settings → Audio**
2. **Disable default desktop audio**
3. **Add custom audio sources**:
   - Click "+" in Audio Mixer
   - Select "Audio Output Capture"
   - Name it (e.g., "Game Audio")
   - Select the virtual sink (e.g., "game_audio_sink.monitor")

### Step 2: Create Audio Sources for Each Sink

Create separate audio sources for:
- Game Audio (game_audio_sink.monitor)
- Browser Audio (browser_audio_sink.monitor)
- Discord Audio (discord_audio_sink.monitor)
- Spotify Audio (spotify_audio_sink.monitor)

### Step 3: Control Individual Volumes

Now in OBS Audio Mixer, you can:
- Adjust game volume independently
- Mute music without affecting game
- Control Discord volume separately
- Mix audio perfectly for your stream

### Step 4: Advanced Filters

For each audio source in OBS:

1. **Right-click** on audio source
2. **Select "Filters"**
3. **Add filters**:
   - **Noise Suppression** (for Discord)
   - **Compressor** (for consistent volume)
   - **Gain** (to boost quiet audio)
   - **Limiter** (to prevent clipping)

---

## Practical Examples

### Example 1: Gaming + Discord + Music

**Goal**: Stream gameplay with Discord voice and background music

**Setup**:
1. Route Steam to "Game Audio"
2. Route Discord to "Discord Audio"
3. Route Spotify to "Spotify Audio"
4. In OBS, add all three as separate sources
5. Adjust volumes in OBS mixer

**Result**: You can lower music during intense gameplay, mute Discord when not talking, all without affecting your local audio.

### Example 2: Recording Tutorial

**Goal**: Record a tutorial with browser audio and microphone

**Setup**:
1. Route Firefox to "Browser Audio"
2. Add microphone as separate source in OBS
3. Add "Browser Audio" as audio source in OBS

**Result**: Clean recording with separate control over browser and mic audio.

### Example 3: Multiple Games

**Goal**: Stream multiple games with different audio levels

**Setup**:
1. Route Game 1 to "Game Audio"
2. Route Game 2 to "Browser Audio" (repurposed)
3. Adjust volumes independently in OBS

**Result**: Perfect audio balance between different games.

---

## Troubleshooting

### Issue: Virtual sinks not appearing

**Solution**:
```bash
# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse wireplumber

# Re-run setup script
bash /etc/audio-routing-setup.sh
```

### Issue: Application not showing in qpwgraph

**Solution**:
- Make sure application is playing audio
- Refresh qpwgraph (View → Refresh)
- Check if application is using PulseAudio (it should)

### Issue: No sound after routing

**Solution**:
1. Check connections in qpwgraph
2. Verify virtual sink is connected to speakers
3. Check volume levels in pavucontrol
4. Ensure sink is not muted

### Issue: Audio crackling or stuttering

**Solution**:
```bash
# Increase buffer size
# Edit: ~/.config/pipewire/pipewire.conf
# Change: default.clock.quantum = 2048
```

### Issue: OBS not capturing audio

**Solution**:
1. Make sure you're capturing the `.monitor` device
2. Check OBS audio settings
3. Verify virtual sink is active
4. Restart OBS

### Issue: Discord audio routing not working

**Solution**:
1. In Discord: Settings → Voice & Video
2. Output Device: Select "Discord Audio"
3. Input Device: Select your microphone
4. Test audio

---

## Advanced Tips

### Tip 1: Save qpwgraph Layout

After setting up your routing:
1. File → Save As
2. Name: `wehttamsnaps-audio-routing.qpwgraph`
3. Load this layout anytime: File → Open

### Tip 2: Create Profiles

Create different routing profiles for different scenarios:
- `gaming.qpwgraph` - Gaming setup
- `streaming.qpwgraph` - Streaming setup
- `recording.qpwgraph` - Recording setup
- `music.qpwgraph` - Music production

### Tip 3: Automatic Routing

Applications can be automatically routed using WirePlumber rules (already configured in your NixOS setup):
- Firefox → Browser Audio (automatic)
- Discord → Discord Audio (automatic)
- Spotify → Spotify Audio (automatic)

### Tip 4: Monitor Your Routing

Use `pw-top` to monitor PipeWire in real-time:
```bash
pw-top
```

### Tip 5: Create Custom Sinks

Need more sinks? Create them manually:
```bash
pw-cli create-node adapter '{ 
  factory.name=support.null-audio-sink 
  node.name=custom_sink 
  node.description="Custom Audio" 
  media.class=Audio/Sink 
  audio.position=[FL FR] 
}'
```

---

## Quick Reference

### Essential Commands

```bash
# List all sinks
pactl list sinks short

# List all sources
pactl list sources short

# Set default sink
pactl set-default-sink game_audio_sink

# Move application to sink
pactl move-sink-input <ID> game_audio_sink

# Get application ID
pactl list sink-inputs short
```

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Mod+A` | Open pavucontrol |
| `Mod+Shift+A` | Open qpwgraph |

---

## Visual Cheat Sheet

```
┌────────────────────────────────────────────────────────────┐
│                  Audio Routing Flow                        │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  [Steam] ──▶ [Game Sink] ──┬──▶ [Speakers]               │
│                             └──▶ [OBS]                     │
│                                                            │
│  [Firefox] ─▶ [Browser Sink] ─┬─▶ [Speakers]             │
│                                └─▶ [OBS]                   │
│                                                            │
│  [Discord] ─▶ [Discord Sink] ─┬─▶ [Speakers]             │
│                                └─▶ [OBS]                   │
│                                                            │
│  [Spotify] ─▶ [Spotify Sink] ─┬─▶ [Speakers]             │
│                                └─▶ [OBS]                   │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

**Pro Tip**: Save your qpwgraph layout after setting up your perfect routing, so you can restore it anytime!

For more help, join the WehttamSnaps Discord: https://discord.gg/nTaknDvdUA