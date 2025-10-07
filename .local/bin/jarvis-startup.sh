#!/bin/bash
# J.A.R.V.I.S. Startup Greeting

hour=$(date +%H)
if [ $hour -lt 12 ]; then
    greet="Good morning"
elif [ $hour -lt 18 ]; then
    greet="Good afternoon" 
else
    greet="Good evening"
fi

# Play startup sound
mpv --no-video ~/.local/share/sounds/jarvis/jarvis-startup.mp3 &

# Show notification
notify-send -i "~/.local/share/icons/jarvis.png" "J.A.R.V.I.S." "$greet, Matthew. All systems operational."

# System status check
echo "J.A.R.V.I.S. System Status:"
echo "- CPU: $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')"
echo "- Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
echo "- Storage: $(df -h / | awk 'NR==2 {print $4 " free"}')"
