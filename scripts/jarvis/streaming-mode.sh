#!/usr/bin/env bash
# J.A.R.V.I.S. Streaming Mode Toggle
# Activates streaming optimizations and plays sound

# Path to sounds
SOUNDS_DIR="$HOME/.config/sounds"

# State file
STATE_FILE="$HOME/.config/jarvis/streaming-mode.state"

# Check if streaming mode is active
if [ -f "$STATE_FILE" ]; then
    # Streaming mode is active, deactivate it
    rm "$STATE_FILE"
    
    # Send notification
    notify-send "J.A.R.V.I.S." "Streaming mode deactivated." -i camera-video -u normal
    
    # Log
    echo "$(date): Streaming mode deactivated" >> "$HOME/.config/jarvis/jarvis.log"
else
    # Activate streaming mode
    touch "$STATE_FILE"
    
    # Play J.A.R.V.I.S. streaming sound
    if [ -f "$SOUNDS_DIR/jarvis-streaming.mp3" ]; then
        mpv --no-video --volume=70 "$SOUNDS_DIR/jarvis-streaming.mp3" &
    fi
    
    # Send notification
    notify-send "J.A.R.V.I.S." "Streaming systems online. All feeds operational." -i camera-video -u normal
    
    # Launch OBS if not running
    if ! pgrep -x "obs" > /dev/null; then
        obs &
    fi
    
    # Log
    echo "$(date): Streaming mode activated" >> "$HOME/.config/jarvis/jarvis.log"
fi