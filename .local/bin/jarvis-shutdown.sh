#!/bin/bash
# J.A.R.V.I.S. Shutdown Sequence

# Play shutdown sound
mpv --no-video ~/.local/share/sounds/jarvis/jarvis-shutdown.mp3

# Wait for sound to finish
sleep 3

# Shutdown system
systemctl poweroff
