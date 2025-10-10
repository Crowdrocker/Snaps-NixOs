# WehttamSnaps Audio Routing Guide
## PipeWire + qpwgraph Setup (Like Voicemeter for Linux)

Complete guide to setting up professional audio routing on Linux for gaming, streaming, and Discord.

---

## 🎯 What We're Building

**Goal:** Separate audio streams like Voicemeter does on Windows:
- **Games** → Separate channel (control volume independently)
- **Browser** (YouTube, Twitch) → Separate channel  
- **Discord** → Separate channel
- **Music** (Spotify) → Separate channel
- **Microphone** → Route to Discord + OBS
- **All outputs** → Your headphones/speakers

---

## 🛠️ Installation

Already included in your NixOS config! But here's what you have:

```nix
# In your configuration.nix
services.pipewire = {
  enable = true;
  alsa.enable = true;
  pulse.enable = true;
  jack.enable = true;
};

environment.systemPackages = with pkgs; [
  qpwgraph    # Visual routing tool
  pavucontrol # Simple volume control
  helvum      # Alternative graph tool
  easyeffects # Audio effects (optional)
];
```

---

## 📋 Step-by-Step Setup

### Step 1: Understand the Basics

**Sources** (produce audio):
- Games (Steam, Lutris)
- Browser (Firefox, Chrome)
- Discord
- Spotify
- Music players

**Sinks** (receive audio):
- Physical output (headphones/speakers)
- Virtual sinks (routing destinations)

**How it works:**
```
Game → Virtual Sink "Games" → Your Headphones
```

---

### Step 2: Create Virtual Sinks

Your config already creates these automatically on boot!

To create them manually (if needed):

```bash
# Create "Games" sink
pw-cli create-node adapter \
  '{ factory.name=support.null-audio-sink 
     node.name=Games 
     node.description="Games Audio"
     media.class=Audio/Sink
     audio.position=FL,FR }'

# Create "Browser" sink  
pw-cli create-node adapter \
  '{ factory.name=support.null-audio-sink 
     node.name=Browser 
     node.description="Browser Audio"
     media.class=Audio/Sink
     audio.position=FL,FR }'

# Create "Discord" sink
pw-cli create-node adapter \
  '{ factory.name=support.null-audio-sink 
     node.name=Discord 
     node.description="Discord Audio"
     media.class=Audio/Sink
     audio.position=FL,FR }'

# Create "Music" sink
pw-cli create-node adapter \
  '{ factory.name=support.null-audio-sink 
     node.name=Music 
     node.description="Spotify/Music"
     media.class=Audio/Sink
     audio.position=FL,FR }'
```

---

### Step 3: Open qpwgraph

```bash
qpwgraph
```

**Interface Overview:**
- **Left side**: Audio sources (applications)
- **Right side**: Audio sinks (outputs)
- **Lines**: Audio connections
- **Colors**: 
  - Blue = Audio
  - Red = MIDI
  - Green = Video

---

### Step 4: Basic Routing - Game Audio

**Scenario:** Route Steam game to "Games" virtual sink

1. Launch qpwgraph
2. Start a game in Steam
3. Find the game in left panel (e.g., "Cyberpunk2077")
4. Find "Games" sink in middle/right panel
5. Drag from game output → Games sink input
6. Find "Games" sink's output (monitor)
7. Drag from Games monitor → Your headphones input

**Visual:**
```
[Cyberpunk2077] → [Games Sink] → [Monitor] → [Headphones]
     Output            Input       Output        Input
```

---

### Step 5: Browser Audio Routing

**Route Firefox/Chrome separately:**

1. Open browser, play video
2. Find browser in qpwgraph (e.g., "Firefox")
3. Disconnect from default output
4. Connect to "Browser" virtual sink
5. Connect Browser monitor to headphones

**Quick Method via pavucontrol:**
1. Open pavucontrol
2. Go to "Playback" tab
3. Find Firefox
4. Change output dropdown to "Browser Audio"

---

### Step 6: Discord Setup

**Route Discord audio + Mic:**

**Discord Output (hearing others):**
1. Open Discord, join voice
2. Find Discord in qpwgraph
3. Connect Discord → Discord virtual sink
4. Connect Discord monitor → Headphones

**Microphone to Discord:**
1. Find your microphone (Built-in Audio)
2. Connect Mic → Discord application input

**For OBS (stream Discord):**
```
Microphone → Discord
         ↘ → OBS
```

This way OBS captures your mic, Discord hears you, but viewers hear you clearly.

---

### Step 7: Music/Spotify Routing

Same as others:
1. Play music in Spotify
2. Connect Spotify → Music virtual sink
3. Connect Music monitor → Headphones

**Benefit:** Lower music volume during gaming without affecting game volume!

---

## 🎮 Gaming + Discord + Music Setup

**The Full Setup:**

```
[Cyberpunk2077] → [Games Sink] ──┐
[Firefox]       → [Browser Sink] ─┤
[Discord]       → [Discord Sink] ─┼→ [MIXER] → [Headphones]
[Spotify]       → [Music Sink] ───┘

[Microphone] → [Discord App]
           └─→ [OBS Studio]
```

**Step-by-Step:**

1. **Game Audio**
   - Cyberpunk → Games sink → Headphones
   - Volume: 80%

2. **Music Audio**  
   - Spotify → Music sink → Headphones
   - Volume: 30% (background music)

3. **Discord Audio**
   - Discord → Discord sink → Headphones
   - Volume: 100% (hear teammates clearly)

4. **Microphone**
   - Built-in Mic → Discord (so they hear you)
   - Built-in Mic → OBS (so stream hears you)

5. **Browser** (optional)
   - Firefox → Browser sink → Headphones
   - Volume: 50%

---

## 🎛️ Using pavucontrol (Easy Mode)

For quick adjustments without the graph:

```bash
pavucontrol
```

### Playback Tab
Lists all playing audio:
- Move each app to its virtual sink
- Adjust individual volumes
- Mute specific sources

### Recording Tab
- Set Discord to use your microphone
- Set OBS to capture virtual sink monitors
- Set OBS to capture your microphone

### Output Devices Tab
- Your physical outputs (headphones, speakers)
- Virtual sinks you created
- Set default output device

### Input Devices Tab
- Your microphones
- Virtual sources
- Set default input

---

## 📊 Volume Control Strategy

**During Gaming Session:**

| Source | Volume | Why |
|--------|--------|-----|
| Game | 70-80% | Main audio |
| Discord | 100% | Must hear teammates |
| Music | 20-40% | Background only |
| Browser | 50% | YouTube guides, etc. |
| Mic | 75-85% | Clear voice |

**During Streaming:**

| Source | Volume | Why |
|--------|--------|-----|
| Game | 60-70% | Viewers need to hear you |
| Your Voice | 85-95% | Most important |
| Discord | 40-50% | Lower so viewers hear you |
| Music | 20-30% | Very background |

---

## 🎙️ Microphone Routing for Streaming

**Goal:** You in Discord + Stream hears you clearly

### Setup in qpwgraph:

1. **Your Mic → Discord**
   ```
   [Built-in Mic] → [Discord Input]
   ```

2. **Your Mic → OBS**
   ```
   [Built-in Mic] → [OBS Audio Input]
   ```

3. **Game Audio → OBS**
   ```
   [Games Sink Monitor] → [OBS Audio Input]
   ```

4. **Music → OBS** (optional)
   ```
   [Music Sink Monitor] → [OBS Audio Input]
   ```

5. **Discord → OBS** (if you want stream to hear teammates)
   ```
   [Discord Sink Monitor] → [OBS Audio Input]
   ```
   
   ⚠️ **Warning:** Only do this if teammates consent to being on stream!

---

## 💾 Saving Your Setup

### Method 1: qpwgraph Patchbay

1. Set up all your connections
2. In qpwgraph: **File → Store Patchbay...**
3. Save as: `~/.config/qpwgraph/gaming-setup.qpwgraph`
4. Next time: **File → Restore Patchbay...**

### Method 2: Auto-load on Start

Create a systemd service (already in your config!):

```nix
# Already in your audio.nix
systemd.user.services.audio-routing = {
  Unit = {
    Description = "WehttamSnaps Audio Routing";
    After = [ "pipewire.service" ];
  };
  
  Service = {
    Type = "oneshot";
    ExecStart = "${pkgs.qpwgraph}/bin/qpwgraph -a ~/.config/qpwgraph/gaming-setup.qpwgraph";
  };
  
  Install.WantedBy = [ "default.target" ];
};
```

### Method 3: PipeWire Config (Advanced)

Create persistent rules in `~/.config/pipewire/pipewire.conf.d/`:

```json
{
  "context.modules": [
    {
      "name": "libpipewire-module-loopback",
      "args": {
        "node.description": "Games Loopback",
        "capture.props": {
          "node.name": "games_loopback",
          "media.class": "Audio/Sink"
        },
        "playback.props": {
          "node.name": "games_playback"
        }
      }
    }
  ]
}
```

---

## 🎮 Per-Game Audio Setup

### Steam Games

**Method 1: Using pavucontrol**
1. Launch game
2. Alt+Tab out (or use second monitor)
3. Open pavucontrol
4. Go to Playback tab
5. Find game → Change output to "Games"

**Method 2: Using qpwgraph**
1. Keep qpwgraph open
2. Launch game
3. Game appears in graph
4. Connect it to Games sink

**Method 3: Set Default for Steam**
```bash
# Find Steam's PulseAudio ID
pactl list sink-inputs | grep -A 20 "Steam"

# Move all Steam to Games sink
pactl move-sink-input <ID> Games
```

### Lutris Games

Same as Steam, but look for:
- Wine prefix name
- Game executable name

### Native Linux Games

Usually show up with their name directly.

---

## 🔧 Troubleshooting

### Virtual Sinks Not Appearing

```bash
# Restart PipeWire
systemctl --user restart pipewire wireplumber

# Manually create sinks
~/.local/bin/setup-audio-routing.sh

# Check if created
wpctl status
```

### Audio Stuttering/Crackling

```bash
# Increase buffer size
# Edit: ~/.config/pipewire/pipewire.conf
{
  "context.properties": {
    "default.clock.quantum": 1024,
    "default.clock.min-quantum": 512
  }
}

# Restart
systemctl --user restart pipewire
```

### Game Audio Not Routing

1. Check game is running
2. Verify it's outputting audio (check volume)
3. Look in pavucontrol Playback tab
4. Manually assign to Games sink
5. Save qpwgraph configuration

### Microphone Echo in Discord

**Cause:** Discord hearing itself through Desktop Audio

**Fix:**
1. In qpwgraph, disconnect Discord monitor from OBS
2. Or: In Discord settings, enable "Echo Cancellation"
3. Lower Discord virtual sink volume

### OBS Not Capturing Audio

**Check OBS Audio Settings:**
1. Settings → Audio
2. Add audio source: "Monitor of Games"
3. Add mic source: "Built-in Audio"
4. Check mixer levels are up

---

## 📱 Control from Phone (Optional)

Use **PulseAudio Remote** app:
1. Install on Android/iOS
2. Connect to your PC (same network)
3. Control volumes remotely
4. Useful when gaming fullscreen!

---

## 🎚️ Advanced: EasyEffects

Add effects to your audio:

```bash
easyeffects
```

**For Microphone:**
- Noise Reduction
- Gate (cut background noise)
- Compressor (even out voice)
- Equalizer (voice clarity)

**For Game Audio:**
- Bass boost
- Surround sound
- Equalizer presets

**Setup:**
1. Open EasyEffects
2. Add effects to input (mic) or output (game)
3. Load presets or create your own
4. Effects apply in real-time!

---

## 📋 Quick Reference Commands

```bash
# List all audio devices
wpctl status

# List sinks
pactl list sinks short

# List sources  
pactl list sources short

# Set default sink
wpctl set-default <SINK-ID>

# Set volume (0-100%)
wpctl set-volume <SINK-ID> 80%

# Mute/unmute
wpctl set-mute <SINK-ID> toggle

# Move playing audio to sink
pactl move-sink-input <INPUT-ID> <SINK-NAME>

# Restart audio
systemctl --user restart pipewire wireplumber
```

---

## 🎯 Example Workflows

### Casual Gaming
```
Games → Headphones (80%)
Music → Headphones (40%)
```

Simple, just game and chill music.

### Competitive Gaming
```
Game → Headphones (70%)
Discord → Headphones (100%)
Music → OFF
```

Focus on game sounds and callouts.

### Streaming Setup
```
Game → OBS (60%) → Headphones (70%)
Mic → OBS (90%) → Discord (80%)
Discord → OBS (40%) → Headphones (100%)
Music → OBS (25%) → Headphones (30%)
```

Balanced for viewers and your ears.

### Work Setup
```
Music → Headphones (60%)
Browser → Headphones (70%)
Notifications → Headphones (50%)
```

Background music while working.

---

## 💡 Pro Tips

1. **Save Multiple Presets**
   - gaming-solo.qpwgraph
   - gaming-discord.qpwgraph  
   - streaming.qpwgraph
   - work.qpwgraph

2. **Keyboard Shortcuts**
   - Bind volume controls to keys
   - Quick mute for mic
   - Toggle virtual sinks

3. **Second Monitor**
   - Keep qpwgraph on second monitor
   - Live adjustment while gaming
   - Visual feedback

4. **Color Coding in qpwgraph**
   - Right-click nodes → Change color
   - Games = Red
   - Discord = Blue
   - Music = Purple
   - Makes it easier to see!

5. **Test Before Streaming**
   - Do a test recording in OBS
   - Play back and check levels
   - Adjust before going live

---

## 🆘 Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| No virtual sinks | Run setup script, restart PipeWire |
| Crackling audio | Increase buffer size in config |
| Mic too quiet | Boost in pavucontrol Input tab |
| Game audio delayed | Lower latency in PipeWire config |
| Can't hear Discord | Check Discord virtual sink volume |
| OBS no audio | Add monitor sources in OBS |

---

## 🎓 Learning Resources

- **PipeWire Docs:** https://docs.pipewire.org/
- **qpwgraph GitHub:** https://github.com/rncbc/qpwgraph
- **PulseAudio Commands:** https://wiki.archlinux.org/title/PulseAudio
- **Audio Production:** https://linuxaudio.org/

---

## ✅ Final Setup Checklist

- [ ] PipeWire installed and running
- [ ] qpwgraph installed
- [ ] Virtual sinks created (Games, Browser, Discord, Music)
- [ ] All applications routed correctly
- [ ] Microphone connected to Discord
- [ ] OBS capturing game audio + mic
- [ ] Volume levels balanced
- [ ] Configuration saved in qpwgraph
- [ ] Auto-load setup on boot
- [ ] Tested in actual gaming session

---

**You now have professional audio routing like Voicemeter, but on Linux!** 🎉

Any questions? Test it out and adjust to your preferences. Happy gaming! 🎮