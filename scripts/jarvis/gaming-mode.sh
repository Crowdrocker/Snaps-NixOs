#!/usr/bin/env bash
# J.A.R.V.I.S. Gaming Mode Toggle
# Activates gaming optimizations and plays sound

# Path to sounds
SOUNDS_DIR="$HOME/.config/sounds"

# Check if gaming mode is active
if pgrep -x "gamemoded" > /dev/null; then
    # Gaming mode is active, deactivate it
    pkill gamemoded
    
    # Send notification
    notify-send "J.A.R.V.I.S." "Gaming mode deactivated. Returning to normal operation." -i applications-games -u normal
    
    # Log
    echo "$(date): Gaming mode deactivated" >> "$HOME/.config/jarvis/jarvis.log"
else
    # Activate gaming mode
    # Play J.A.R.V.I.S. gaming sound
    if [ -f "$SOUNDS_DIR/jarvis-gaming.mp3" ]; then
        mpv --no-video --volume=70 "$SOUNDS_DIR/jarvis-gaming.mp3" &
    fi
    
    # Send notification
    notify-send "J.A.R.V.I.S." "Gaming mode activated. Systems at maximum performance." -i applications-games -u normal
    
    # Set CPU governor to performance
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    
    # Log
    echo "$(date): Gaming mode activated" >> "$HOME/.config/jarvis/jarvis.log"
fi