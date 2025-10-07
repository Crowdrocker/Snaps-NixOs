#!/usr/bin/env bash
# J.A.R.V.I.S. Warning Sound
# Plays warning sound for critical notifications

# Path to sounds
SOUNDS_DIR="$HOME/.config/sounds"

# Play warning sound
if [ -f "$SOUNDS_DIR/jarvis-warning.mp3" ]; then
    mpv --no-video --volume=80 "$SOUNDS_DIR/jarvis-warning.mp3" &
fi