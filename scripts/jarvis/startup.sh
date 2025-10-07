#!/usr/bin/env bash
# J.A.R.V.I.S. Startup Script
# Plays greeting based on time of day

# Get current hour
HOUR=$(date +%H)

# Determine greeting based on time
if [ $HOUR -ge 5 ] && [ $HOUR -lt 12 ]; then
    GREETING="Good morning"
elif [ $HOUR -ge 12 ] && [ $HOUR -lt 18 ]; then
    GREETING="Good afternoon"
else
    GREETING="Good evening"
fi

# Path to sounds
SOUNDS_DIR="$HOME/.config/sounds"

# Play startup sound
if [ -f "$SOUNDS_DIR/jarvis-startup.mp3" ]; then
    mpv --no-video --volume=70 "$SOUNDS_DIR/jarvis-startup.mp3" &
fi

# Send notification
notify-send "J.A.R.V.I.S." "$GREETING, Matthew. All systems operational." -i computer -u normal

# Log startup
echo "$(date): J.A.R.V.I.S. startup - $GREETING" >> "$HOME/.config/jarvis/jarvis.log"