# WehttamSnaps Streaming Guide

Complete guide to streaming on Twitch with OBS Studio.

## Table of Contents
1. [OBS Studio Setup](#obs-studio-setup)
2. [Audio Configuration](#audio-configuration)
3. [Scene Creation](#scene-creation)
4. [Streaming Settings](#streaming-settings)
5. [Twitch Integration](#twitch-integration)
6. [Tips & Tricks](#tips--tricks)

---

## OBS Studio Setup

### Initial Configuration

1. **Launch OBS Studio**
   ```bash
   obs
   # Or press: Mod+Shift+T (activates streaming mode)
   ```

2. **Run Auto-Configuration Wizard**
   - First launch will show wizard
   - Select: "Optimize for streaming"
   - Service: Twitch
   - Enter your Twitch stream key

3. **Manual Settings** (if skipping wizard)
   - Settings → Stream
   - Service: Twitch
   - Server: Auto (closest)
   - Stream Key: (from Twitch dashboard)

---

## Audio Configuration

### Set Up Audio Sources

Your system has virtual audio sinks for perfect audio separation!

#### Step 1: Remove Default Audio

1. Settings → Audio
2. Disable all default desktop audio
3. We'll add custom sources instead

#### Step 2: Add Virtual Sink Sources

In OBS main window:

1. **Add Game Audio**
   - Audio Mixer → "+" → Audio Output Capture
   - Name: "Game Audio"
   - Device: "Monitor of Game Audio Sink"
   - Click OK

2. **Add Discord Audio**
   - Audio Mixer → "+" → Audio Output Capture
   - Name: "Discord"
   - Device: "Monitor of Discord Audio Sink"
   - Click OK

3. **Add Music Audio**
   - Audio Mixer → "+" → Audio Output Capture
   - Name: "Music"
   - Device: "Monitor of Spotify Audio Sink"
   - Click OK

4. **Add Microphone**
   - Audio Mixer → "+" → Audio Input Capture
   - Name: "Microphone"
   - Device: Your microphone
   - Click OK

#### Step 3: Configure Audio Filters

For each audio source:

**Microphone Filters:**
1. Right-click "Microphone" → Filters
2. Add:
   - **Noise Suppression** (RNNoise)
     - Method: RNNoise
   - **Noise Gate**
     - Close Threshold: -50 dB
     - Open Threshold: -45 dB
   - **Compressor**
     - Ratio: 3:1
     - Threshold: -18 dB
     - Attack: 6 ms
     - Release: 60 ms
   - **Gain**
     - Gain: +5 dB (adjust as needed)

**Game Audio Filters:**
1. Right-click "Game Audio" → Filters
2. Add:
   - **Compressor**
     - Ratio: 2:1
     - Threshold: -20 dB
   - **Limiter**
     - Threshold: -6 dB

**Discord Filters:**
1. Right-click "Discord" → Filters
2. Add:
   - **Noise Suppression** (RNNoise)
   - **Compressor**
     - Ratio: 3:1
     - Threshold: -18 dB

#### Step 4: Set Audio Levels

Recommended levels (adjust to taste):
- **Microphone**: -12 dB to -6 dB (when talking)
- **Game Audio**: -18 dB to -12 dB
- **Discord**: -24 dB to -18 dB
- **Music**: -30 dB to -24 dB (background)

---

## Scene Creation

### Scene 1: Starting Soon

**Purpose**: Pre-stream countdown

**Elements:**
1. **Background Image**
   - Source: Image
   - File: Your "Starting Soon" graphic
   - Transform: Fit to screen

2. **Countdown Timer** (optional)
   - Source: Text (FreeType 2)
   - Text: "Stream starts in 5 minutes"
   - Font: Large, bold
   - Position: Center

3. **Music**
   - Enable "Music" audio source
   - Disable game audio

### Scene 2: Gameplay

**Purpose**: Main gaming scene

**Elements:**
1. **Game Capture**
   - Source: Window Capture
   - Window: [Auto] (captures focused window)
   - Transform: Fit to screen

2. **Webcam** (if you have one)
   - Source: Video Capture Device
   - Device: Your webcam
   - Transform: Bottom-right corner, 320x240

3. **Overlay** (optional)
   - Source: Image
   - File: Your stream overlay PNG
   - Transform: Full screen

4. **Chat Box** (optional)
   - Source: Browser
   - URL: Twitch chat widget
   - Width: 400, Height: 600
   - Position: Right side

5. **Audio Visualizer** (optional)
   - Source: Audio Visualizer plugin
   - Audio Source: Game Audio

**Audio:**
- Enable: Game Audio, Microphone, Discord
- Disable: Music (or keep very low)

### Scene 3: BRB (Be Right Back)

**Purpose**: Bathroom breaks, etc.

**Elements:**
1. **Background Image**
   - Source: Image
   - File: Your "BRB" graphic
   - Transform: Fit to screen

2. **Text**
   - Source: Text (FreeType 2)
   - Text: "Be Right Back!"
   - Font: Large
   - Position: Center

3. **Music**
   - Enable "Music" audio source
   - Disable game audio

### Scene 4: Ending

**Purpose**: Stream outro

**Elements:**
1. **Background Image**
   - Source: Image
   - File: Your "Thanks for watching" graphic
   - Transform: Fit to screen

2. **Social Media**
   - Source: Text (FreeType 2)
   - Text: Your social links
   - Position: Center

3. **Music**
   - Enable "Music" audio source

---

## Streaming Settings

### Video Settings

Settings → Video:

**Base (Canvas) Resolution**: 1920x1080
**Output (Scaled) Resolution**: 1920x1080
**Downscale Filter**: Lanczos (best quality)
**FPS**: 60 (or 30 for slower internet)

### Output Settings

Settings → Output:

**Output Mode**: Advanced

**Streaming Tab:**
- **Encoder**: x264 (CPU) or VAAPI (GPU)
- **Rate Control**: CBR
- **Bitrate**: 6000 Kbps (adjust based on upload speed)
- **Keyframe Interval**: 2
- **CPU Usage Preset**: veryfast (or faster if CPU struggles)
- **Profile**: high
- **Tune**: zerolatency

**Recording Tab** (optional):
- **Type**: Standard
- **Recording Path**: /run/media/wehttamsnaps/LINUXDRIVE-1/Recordings
- **Recording Format**: mkv
- **Encoder**: Same as streaming

### Advanced Settings

Settings → Advanced:

**Process Priority**: High
**Renderer**: OpenGL
**Color Format**: NV12
**Color Space**: 709
**Color Range**: Partial

---

## Twitch Integration

### Get Your Stream Key

1. Go to https://dashboard.twitch.tv/
2. Settings → Stream
3. Copy "Primary Stream Key"
4. In OBS: Settings → Stream → Stream Key

### Set Up Chat

**Option 1: Browser Source**
1. Add Browser source to scene
2. URL: `https://www.twitch.tv/popout/[YOUR_USERNAME]/chat`
3. Width: 400, Height: 600

**Option 2: Separate Window**
- Open Twitch chat in Firefox
- Position on second monitor (if available)

### Stream Information

Before streaming:
1. Go to Twitch dashboard
2. Set stream title
3. Select category/game
4. Add tags
5. Set up stream notifications

---

## Keybindings for Streaming

### OBS Hotkeys

Settings → Hotkeys:

**Recommended Hotkeys:**
- **Start Streaming**: F9
- **Stop Streaming**: F10
- **Start Recording**: F11
- **Stop Recording**: F12
- **Mute Microphone**: Ctrl+M
- **Push to Talk**: Left Alt (hold)
- **Scene 1 (Starting Soon)**: Ctrl+1
- **Scene 2 (Gameplay)**: Ctrl+2
- **Scene 3 (BRB)**: Ctrl+3
- **Scene 4 (Ending)**: Ctrl+4

### System Hotkeys

Already configured:
- **Activate Streaming Mode**: Mod+Shift+T
  - Launches OBS
  - Plays J.A.R.V.I.S. sound
  - Optimizes system

---

## Tips & Tricks

### Optimize Performance

1. **Use Hardware Encoding** (if available)
   - AMD: VAAPI
   - Reduces CPU load

2. **Lower Game Settings**
   - Reduce graphics quality slightly
   - Maintain 60 FPS in-game

3. **Close Background Apps**
   - Close Firefox, Discord (if not needed)
   - Free up resources

4. **Monitor Performance**
   - Watch OBS stats (bottom right)
   - CPU usage should be < 80%
   - Dropped frames should be < 1%

### Audio Mixing Tips

1. **Game Audio**: Loudest, but not overpowering
2. **Your Voice**: Clear and prominent
3. **Discord**: Lower than your voice
4. **Music**: Background level only

**Test Your Mix:**
- Record a test stream
- Watch it back
- Adjust levels accordingly

### Engagement Tips

1. **Talk to Chat**
   - Read chat regularly
   - Respond to questions
   - Thank new followers

2. **Be Consistent**
   - Stream on schedule
   - Same days/times each week

3. **Have Fun**
   - Enjoy the games you play
   - Your enthusiasm is contagious

### Stream Quality Checklist

Before going live:
- [ ] Audio levels correct
- [ ] Microphone working
- [ ] Game audio routing correctly
- [ ] Webcam positioned (if using)
- [ ] Overlay displaying correctly
- [ ] Stream title/category set
- [ ] Chat visible
- [ ] Notifications enabled

---

## Troubleshooting

### High CPU Usage

**Solution 1**: Lower encoder preset
- Settings → Output → CPU Usage Preset: superfast

**Solution 2**: Reduce resolution
- Settings → Video → Output Resolution: 1280x720

**Solution 3**: Lower FPS
- Settings → Video → FPS: 30

### Dropped Frames

**Cause**: Internet upload speed too low

**Solution**:
- Lower bitrate (Settings → Output → Bitrate)
- Test your upload speed: https://speedtest.net/
- Recommended: 7+ Mbps upload for 6000 Kbps stream

### Audio Desync

**Solution**:
- Right-click audio source → Advanced Audio Properties
- Adjust "Sync Offset" (try +100ms or -100ms)

### Game Not Capturing

**Solution 1**: Use Window Capture instead of Game Capture
**Solution 2**: Run OBS as admin (not recommended on NixOS)
**Solution 3**: Use Display Capture as fallback

---

## Stream Templates

### Free Resources

**Graphics:**
- https://nerdordie.com/
- https://streamlabs.com/
- https://own3d.tv/

**Overlays:**
- https://streamelements.com/
- https://streamlabs.com/

**Alerts:**
- https://streamelements.com/
- https://streamlabs.com/

### Create Your Own

Use GIMP or Inkscape to create:
- Starting Soon screen
- BRB screen
- Ending screen
- Overlays
- Alerts

**Recommended Sizes:**
- Full screen graphics: 1920x1080
- Overlays: 1920x1080 (with transparency)
- Webcam border: 320x240 + border

---

## Advanced Features

### Stream Deck Integration

If you have a Stream Deck:
1. Install obs-websocket plugin
2. Configure Stream Deck software
3. Create buttons for scenes, sources, etc.

### Multi-Platform Streaming

Stream to multiple platforms:
1. Use Restream.io or similar
2. Configure in OBS: Settings → Stream
3. Enter Restream RTMP URL

### Recording While Streaming

Settings → Output → Recording:
- Enable recording
- Save to: /run/media/wehttamsnaps/LINUXDRIVE-1/Recordings
- Use same encoder as streaming

---

## Streaming Checklist

### Pre-Stream (30 minutes before)
- [ ] Test audio levels
- [ ] Test microphone
- [ ] Test game capture
- [ ] Set stream title/category
- [ ] Post on social media
- [ ] Start "Starting Soon" scene

### During Stream
- [ ] Monitor chat
- [ ] Watch for technical issues
- [ ] Engage with viewers
- [ ] Have fun!

### Post-Stream
- [ ] Thank viewers
- [ ] Save VOD highlights
- [ ] Post clips on social media
- [ ] Review stream for improvements

---

## Your Streaming Setup

### Workspace 6: Streaming

Press `Mod+6` to switch to streaming workspace

**Layout:**
- OBS Studio (main window)
- Twitch chat (browser)
- Discord (if needed)
- Game (on workspace 5)

### Quick Streaming Workflow

1. Press `Mod+Shift+T` (activates streaming mode)
2. Press `Mod+6` (switch to streaming workspace)
3. Set up OBS scenes
4. Press `Mod+5` (switch to gaming workspace)
5. Launch game
6. Press `Mod+6` (back to OBS)
7. Start stream (F9)
8. Press `Mod+5` (back to game)
9. Stream and have fun!
10. Press `Mod+6` (back to OBS)
11. Stop stream (F10)

---

## Resources

- **OBS Studio**: https://obsproject.com/
- **Twitch Creator Camp**: https://www.twitch.tv/creatorcamp
- **Streaming Guides**: https://streamscheme.com/
- **WehttamSnaps Discord**: https://discord.gg/nTaknDvdUA

---

**Happy Streaming!** 📡

For more help, join the Discord: https://discord.gg/nTaknDvdUA