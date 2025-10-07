#!/usr/bin/env bash
# J.A.R.V.I.S. Shutdown Script
# Plays farewell message before shutdown

# Path to sounds
SOUNDS_DIR="$HOME/.config/sounds"

# Play shutdown sound
if [ -f "$SOUNDS_DIR/jarvis-shutdown.mp3" ]; then
    mpv --no-video --volume=70 "$SOUNDS_DIR/jarvis-shutdown.mp3"
fi

# Send notification
notify-send "J.A.R.V.I.S." "Shutting down. Have a good day, Matthew." -i system-shutdown -u critical

# Log shutdown
echo "$(date): J.A.R.V.I.S. shutdown initiated" >> "$HOME/.config/jarvis/jarvis.log"

# Wait for sound to finish
sleep 2

# Proceed with shutdown
systemctl poweroff