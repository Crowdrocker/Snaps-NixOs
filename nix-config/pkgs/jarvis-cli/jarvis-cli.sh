#!/bin/bash

# J.A.R.V.I.S. Command Line Interface for WehttamSnaps
# Compatible with Misterio77's NixOS template

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

# Gaming mode activation
gaming_mode() {
    echo "🎮 Activating gaming mode..."
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    systemctl --user start gamemoded
    touch /tmp/gaming_mode
    log "Gaming mode activated"
}

# Work mode activation
work_mode() {
    echo "💼 Activating work mode..."
    echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    rm -f /tmp/gaming_mode
    log "Work mode activated"
}

# System monitoring
monitor_system() {
    echo "📊 System Status:"
    
    # CPU info
    cpu_temp=$(sensors | grep "Package id 0" | awk '{print $4}' | sed 's/+//g' | sed 's/°C//g')
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')
    
    # GPU info
    gpu_temp=$(sensors | grep "edge" | awk '{print $2}' | sed 's/+//g' | sed 's/°C//g')
    
    # Memory info
    memory_usage=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
    
    echo "CPU Temperature: ${cpu_temp:-N/A}°C"
    echo "CPU Usage: ${cpu_usage:-N/A}%"
    echo "GPU Temperature: ${gpu_temp:-N/A}°C"
    echo "Memory Usage: ${memory_usage:-N/A}%"
    
    log "System check - CPU: ${cpu_temp:-N/A}°C, GPU: ${gpu_temp:-N/A}°C, Memory: ${memory_usage:-N/A}%"
}

# Launch applications
launch_app() {
    local app="$1"
    
    case "$app" in
        "steam") gamescope -e -f -i steam & ;;
        "discord") discord & ;;
        "obs") obs & ;;
        "firefox") firefox & ;;
        "lutris") gamescope -e -f -i lutris & ;;
        *) echo "Unknown app: $app" ;;
    esac
    
    log "Launched application: $app"
}

# Main command dispatcher
main() {
    case "$1" in
        "gaming") gaming_mode ;;
        "work") work_mode ;;
        "monitor") monitor_system ;;
        "launch") [ -n "$2" ] && launch_app "$2" || echo "Usage: jarvis launch <app>" ;;
        "help"|"--help"|"-h") 
            echo "J.A.R.V.I.S. Command Line Interface"
            echo "Usage: jarvis <command>"
            echo ""
            echo "Commands:"
            echo "  gaming    - Activate gaming mode"
            echo "  work      - Activate work mode"
            echo "  monitor   - Show system status"
            echo "  launch    - Launch applications"
            echo "  help      - Show this help"
            ;;
        *) echo "Unknown command: $1. Use 'jarvis help' for usage." ;;
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
    "gaming_mode": false
}
EOF
fi

# Run main function
main "$@"