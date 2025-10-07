#!/bin/bash
# Gaming Mode Activation

# Play gaming mode sound
mpv --no-video ~/.local/share/sounds/jarvis/jarvis-gaming.mp3 &

# Enable performance mode
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Set GPU to performance
if command -v corectrl &> /dev/null; then
    corectrl --profile gaming &
fi

# Start gamemode
gamemoded &

notify-send "J.A.R.V.I.S." "Gaming mode activated. Systems at maximum performance."
