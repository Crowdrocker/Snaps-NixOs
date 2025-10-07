#!/usr/bin/env bash
# J.A.R.V.I.S. Notification Sound
# Plays notification sound for dunst

# Path to sounds
SOUNDS_DIR="$HOME/.config/sounds"

# Play notification sound
if [ -f "$SOUNDS_DIR/jarvis-notification.mp3" ]; then
    mpv --no-video --volume=50 "$SOUNDS_DIR/jarvis-notification.mp3" &
fi