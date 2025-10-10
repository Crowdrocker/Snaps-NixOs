#!/bin/bash

# J.A.R.V.I.S. Command Line Interface
# WehttamSnaps Gaming & Workstation Assistant

JARVIS_HOME="${HOME}/.config/jarvis"
JARVIS_SOUNDS="${JARVIS_HOME}/sounds"
JARVIS_CONFIG="${JARVIS_HOME}/config.json"
JARVIS_LOG="${JARVIS_HOME}/jarvis.log"

# Create directories if they don't exist
mkdir -p "$JARVIS_HOME" "$JARVIS_SOUNDS" "${HOME}/Pictures/screenshots"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$JARVIS_LOG"
}

# Play sound function
play_sound() {
    local sound_file="$1"
    if [[ -f "$JARVIS_SOUNDS/$sound_file" ]]; then
        paplay "$JARVIS_SOUNDS/$sound_file" &
    fi
}

# Greeting based on time
greet() {
    local hour=$(date +%H)
    local greeting=""
    
    if [[ $hour -ge 5 && $hour -lt 12 ]]; then
        greeting="Good morning, Matthew. All systems operational."
    elif [[ $hour -ge 12 && $hour -lt 17 ]]; then
        greeting="Good afternoon, Matthew. Ready for gaming and productivity."
    elif [[ $hour -ge 17 && $hour -lt 21 ]]; then
        greeting="Good evening, Matthew. Gaming session ready."
    else
        greeting="Good night, Matthew. Sweet dreams."
    fi
    
    echo "$greeting"
    log "Greeting: $greeting"
}

# Gaming mode activation
gaming_mode() {
    echo "Activating gaming mode..."
    play_sound "jarvis-gaming.mp3"
    
    # Set performance governor
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    
    # Enable gamemode
    systemctl --user start gamemoded
    
    # Set gaming flag
    touch /tmp/gaming_mode
    
    log "Gaming mode activated"
}

# Work mode activation
work_mode() {
    echo "Activating work mode..."
    play_sound "jarvis-work.mp3"
    
    # Set balanced governor
    echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    
    # Disable gaming flag
    rm -f /tmp/gaming_mode
    
    log "Work mode activated"
}

# System monitoring
monitor_system() {
    local cpu_temp=$(sensors | grep "Package id 0" | awk '{print $4}' | sed 's/+//g' | sed 's/°C//g')
    local gpu_temp=$(sensors | grep "edge" | awk '{print $2}' | sed 's/+//g' | sed 's/°C//g')
    local memory_usage=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
    
    echo "System Status:"
    echo "CPU Temperature: ${cpu_temp}°C"
    echo "GPU Temperature: ${gpu_temp}°C"
    echo "Memory Usage: ${memory_usage}%"
    
    # Check for high temperatures
    if [[ ${cpu_temp%.*} -gt 80 ]]; then
        echo "Warning: CPU temperature is high!"
        play_sound "jarvis-warning.mp3"
    fi
    
    if [[ ${gpu_temp%.*} -gt 85 ]]; then
        echo "Warning: GPU temperature is high!"
        play_sound "jarvis-warning.mp3"
    fi
    
    log "System check - CPU: ${cpu_temp}°C, GPU: ${gpu_temp}°C, Memory: ${memory_usage}%"
}

# Launch applications
launch_app() {
    local app="$1"
    
    case "$app" in
        "steam")
            echo "Launching Steam..."
            play_sound "jarvis-gaming.mp3"
            gamescope -e -f -i steam &
            ;;
        "discord")
            echo "Launching Discord..."
            discord &
            ;;
        "obs")
            echo "Launching OBS Studio..."
            play_sound "jarvis-streaming.mp3"
            obs &
            ;;
        "firefox")
            echo "Launching Firefox..."
            firefox &
            ;;
        "lutris")
            echo "Launching Lutris..."
            play_sound "jarvis-gaming.mp3"
            lutris &
            ;;
        *)
            echo "Launching $app..."
            "$app" &
            ;;
    esac
    
    log "Launched application: $app"
}

# Audio control
audio_control() {
    local action="$1"
    local value="$2"
    
    case "$action" in
        "volume-up")
            pactl set-sink-volume @DEFAULT_SINK@ +5%
            play_sound "jarvis-notification.mp3"
            ;;
        "volume-down")
            pactl set-sink-volume @DEFAULT_SINK@ -5%
            play_sound "jarvis-notification.mp3"
            ;;
        "mute")
            pactl set-sink-mute @DEFAULT_SINK@ toggle
            play_sound "jarvis-notification.mp3"
            ;;
        "set")
            pactl set-sink-volume @DEFAULT_SINK@ "$value%"
            play_sound "jarvis-notification.mp3"
            ;;
    esac
    
    log "Audio control: $action ${value:-}"
}

# Screenshot functionality
screenshot() {
    local type="$1"
    local filename="${HOME}/Pictures/screenshots/screenshot-$(date +%Y-%m-%d-%H-%M-%S).png"
    
    case "$type" in
        "full")
            grim "$filename"
            play_sound "jarvis-notification.mp3"
            echo "Full screenshot saved to $filename"
            ;;
        "window")
            grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)" "$filename"
            play_sound "jarvis-notification.mp3"
            echo "Window screenshot saved to $filename"
            ;;
        "area")
            grim -g "$(slurp)" "$filename"
            play_sound "jarvis-notification.mp3"
            echo "Area screenshot saved to $filename"
            ;;
    esac
    
    log "Screenshot taken: $type -> $filename"
}

# System shutdown
shutdown_system() {
    play_sound "jarvis-shutdown.mp3"
    echo "Shutting down. Have a good day, Matthew."
    sleep 2
    systemctl poweroff
}

# System reboot
reboot_system() {
    play_sound "jarvis-shutdown.mp3"
    echo "Rebooting system. See you soon, Matthew."
    sleep 2
    systemctl reboot
}

# Main command dispatcher
main() {
    case "$1" in
        "greet")
            greet
            ;;
        "gaming")
            gaming_mode
            ;;
        "work")
            work_mode
            ;;
        "monitor")
            monitor_system
            ;;
        "launch")
            launch_app "$2"
            ;;
        "audio")
            audio_control "$2" "$3"
            ;;
        "screenshot")
            screenshot "$2"
            ;;
        "shutdown")
            shutdown_system
            ;;
        "reboot")
            reboot_system
            ;;
        "help"|"--help"|"-h")
            echo "J.A.R.V.I.S. Command Line Interface"
            echo "Usage: jarvis <command> [options]"
            echo ""
            echo "Commands:"
            echo "  greet                    - Display greeting"
            echo "  gaming                   - Activate gaming mode"
            echo "  work                     - Activate work mode"
            echo "  monitor                  - Show system status"
            echo "  launch <app>             - Launch application"
            echo "  audio <action> [value]   - Control audio"
            echo "  screenshot <type>        - Take screenshot"
            echo "  shutdown                 - Shutdown system"
            echo "  reboot                   - Reboot system"
            echo "  help                     - Show this help"
            ;;
        *)
            echo "Unknown command: $1"
            echo "Use 'jarvis help' for usage information"
            ;;
    esac
}

# Create default configuration if it doesn't exist
if [[ ! -f "$JARVIS_CONFIG" ]]; then
    cat > "$JARVIS_CONFIG" << EOF
{
    "version": "1.0",
    "name": "J.A.R.V.I.S.",
    "user": "Matthew",
    "theme": "violet-cyan",
    "sounds_enabled": true,
    "notifications": true,
    "gaming_mode": false,
    "work_mode": false
}
EOF
fi

# Run main function
main "$@"