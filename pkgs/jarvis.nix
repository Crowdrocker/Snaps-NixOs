# WehttamSnaps J.A.R.V.I.S. Theme Configuration
# Full J.A.R.V.I.S. integration with sounds and notifications

{ config, pkgs, lib, ... }:

let
  jarvisScriptsDir = "/home/wehttamsnaps/.config/jarvis";
  jarvisSoundsDir = "${jarvisScriptsDir}/sounds";
in
{
  # ========================================
  # J.A.R.V.I.S. PACKAGES
  # ========================================
  
  environment.systemPackages = with pkgs; [
    mpg123  # Audio playback
    sox     # Sound processing
    libnotify  # Notifications
    jq      # JSON processing for scripts
    curl    # For API calls
  ];

  # ========================================
  # J.A.R.V.I.S. STARTUP SCRIPT
  # ========================================
  
  environment.etc."wehttamsnaps/jarvis-startup.sh" = {
    text = ''
      #!/usr/bin/env bash
      # J.A.R.V.I.S. Startup Script
      
      SOUNDS_DIR="${jarvisSoundsDir}"
      
      # Determine greeting based on time
      HOUR=$(date +%H)
      if [ $HOUR -lt 12 ]; then
        GREETING="Good morning"
      elif [ $HOUR -lt 18 ]; then
        GREETING="Good afternoon"
      else
        GREETING="Good evening"
      fi
      
      # Wait for audio system to be ready
      sleep 2
      
      # Play startup sound
      mpg123 "$SOUNDS_DIR/jarvis-startup.mp3" &
      
      # Show notification
      notify-send -u low -i computer "J.A.R.V.I.S." "$GREETING, Matthew. All systems operational." &
      
      # Log startup
      echo "[$(date)] J.A.R.V.I.S. initialized" >> /home/wehttamsnaps/.local/share/jarvis/startup.log
    '';
    mode = "0755";
  };

  # ========================================
  # J.A.R.V.I.S. SHUTDOWN SCRIPT
  # ========================================
  
  environment.etc."wehttamsnaps/jarvis-shutdown.sh" = {
    text = ''
      #!/usr/bin/env bash
      # J.A.R.V.I.S. Shutdown Script
      
      SOUNDS_DIR="${jarvisSoundsDir}"
      
      # Play shutdown sound
      mpg123 "$SOUNDS_DIR/jarvis-shutdown.mp3" &
      
      # Wait for sound to finish
      sleep 3
      
      # Proceed with shutdown
      systemctl poweroff
    '';
    mode = "0755";
  };

  # ========================================
  # J.A.R.V.I.S. GAMING MODE SCRIPT
  # ========================================
  
  environment.etc."wehttamsnaps/gaming-mode.sh" = {
    text = ''
      #!/usr/bin/env bash
      # J.A.R.V.I.S. Gaming Mode Toggle
      
      SOUNDS_DIR="${jarvisSoundsDir}"
      STATE_FILE="/tmp/jarvis-gaming-mode"
      
      if [ -f "$STATE_FILE" ]; then
        # Deactivate gaming mode
        rm "$STATE_FILE"
        
        # Restore normal performance
        echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
        
        notify-send -u normal -i applications-games "J.A.R.V.I.S." "Gaming mode deactivated. Systems returning to normal."
      else
        # Activate gaming mode
        touch "$STATE_FILE"
        
        # Enable performance mode
        echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
        
        # Enable gamemode
        gamemoded -r &
        
        # Play gaming mode sound
        mpg123 "$SOUNDS_DIR/jarvis-gaming.mp3" &
        
        notify-send -u normal -i applications-games "J.A.R.V.I.S." "Gaming mode activated. Systems at maximum performance."
      fi
    '';
    mode = "0755";
  };

  # ========================================
  # J.A.R.V.I.S. STREAMING MODE SCRIPT
  # ========================================
  
  environment.etc."wehttamsnaps/streaming-mode.sh" = {
    text = ''
      #!/usr/bin/env bash
      # J.A.R.V.I.S. Streaming Mode Toggle
      
      SOUNDS_DIR="${jarvisSoundsDir}"
      STATE_FILE="/tmp/jarvis-streaming-mode"
      
      if [ -f "$STATE_FILE" ]; then
        # Deactivate streaming mode
        rm "$STATE_FILE"
        
        # Kill OBS if running
        pkill obs
        
        notify-send -u normal -i camera-video "J.A.R.V.I.S." "Streaming mode deactivated."
      else
        # Activate streaming mode
        touch "$STATE_FILE"
        
        # Start OBS
        obs &
        
        # Play streaming mode sound
        mpg123 "$SOUNDS_DIR/jarvis-streaming.mp3" &
        
        notify-send -u normal -i camera-video "J.A.R.V.I.S." "Streaming systems online. All feeds operational."
      fi
    '';
    mode = "0755";
  };

  # ========================================
  # J.A.R.V.I.S. SYSTEM MONITOR
  # ========================================
  
  environment.etc."wehttamsnaps/jarvis-monitor.sh" = {
    text = ''
      #!/usr/bin/env bash
      # J.A.R.V.I.S. System Monitoring
      
      SOUNDS_DIR="${jarvisSoundsDir}"
      WARNING_SENT=false
      
      while true; do
        # Check CPU temperature
        CPU_TEMP=$(sensors | grep 'Core 0' | awk '{print $3}' | sed 's/+//;s/°C//')
        
        # Check GPU temperature
        GPU_TEMP=$(sensors | grep 'edge' | awk '{print $2}' | sed 's/+//;s/°C//')
        
        # Check disk space
        DISK_USAGE=$(df -h /home | awk 'NR==2 {print $5}' | sed 's/%//')
        
        # CPU temperature warning
        if [ $(echo "$CPU_TEMP > 80" | bc) -eq 1 ] && [ "$WARNING_SENT" = false ]; then
          mpg123 "$SOUNDS_DIR/jarvis-warning.mp3" &
          notify-send -u critical -i dialog-warning "J.A.R.V.I.S." "Warning: CPU temperature at ${CPU_TEMP}°C"
          WARNING_SENT=true
        fi
        
        # GPU temperature warning
        if [ ! -z "$GPU_TEMP" ] && [ $(echo "$GPU_TEMP > 85" | bc) -eq 1 ] && [ "$WARNING_SENT" = false ]; then
          mpg123 "$SOUNDS_DIR/jarvis-warning.mp3" &
          notify-send -u critical -i dialog-warning "J.A.R.V.I.S." "Warning: GPU temperature at ${GPU_TEMP}°C"
          WARNING_SENT=true
        fi
        
        # Disk space warning
        if [ $DISK_USAGE -gt 90 ] && [ "$WARNING_SENT" = false ]; then
          mpg123 "$SOUNDS_DIR/jarvis-warning.mp3" &
          notify-send -u critical -i drive-harddisk "J.A.R.V.I.S." "Warning: Disk usage at ${DISK_USAGE}%"
          WARNING_SENT=true
        fi
        
        # Reset warning flag after 5 minutes
        if [ "$WARNING_SENT" = true ]; then
          sleep 300
          WARNING_SENT=false
        fi
        
        sleep 30
      done
    '';
    mode = "0755";
  };

  # ========================================
  # J.A.R.V.I.S. NOTIFICATION WRAPPER
  # ========================================
  
  environment.etc."wehttamsnaps/jarvis-notify.sh" = {
    text = ''
      #!/usr/bin/env bash
      # J.A.R.V.I.S. Notification Wrapper
      
      SOUNDS_DIR="${jarvisSoundsDir}"
      
      # Play notification sound
      mpg123 "$SOUNDS_DIR/jarvis-notification.mp3" &
      
      # Show notification with J.A.R.V.I.S. branding
      notify-send -u normal -i computer "J.A.R.V.I.S." "Matthew, you have a notification: $1"
    '';
    mode = "0755";
  };

  # ========================================
  # DUNST CONFIGURATION FOR J.A.R.V.I.S.
  # ========================================
  
  environment.etc."xdg/dunst/dunstrc" = {
    text = ''
      [global]
          monitor = 0
          follow = mouse
          width = 350
          height = 300
          origin = top-right
          offset = 10x50
          scale = 0
          notification_limit = 3
          
          progress_bar = true
          progress_bar_height = 10
          progress_bar_frame_width = 1
          progress_bar_min_width = 150
          progress_bar_max_width = 300
          
          indicate_hidden = yes
          separator_height = 2
          padding = 12
          horizontal_padding = 12
          text_icon_padding = 0
          frame_width = 2
          frame_color = "#8A2BE2"
          separator_color = frame
          sort = yes
          
          font = JetBrains Mono 10
          line_height = 0
          markup = full
          format = "<b>%s</b>\n%b"
          alignment = left
          vertical_alignment = center
          show_age_threshold = 60
          ellipsize = middle
          ignore_newline = no
          stack_duplicates = true
          hide_duplicate_count = false
          show_indicators = yes
          
          icon_position = left
          min_icon_size = 32
          max_icon_size = 64
          
          sticky_history = yes
          history_length = 20
          
          browser = /usr/bin/xdg-open
          always_run_script = true
          title = Dunst
          class = Dunst
          corner_radius = 10
          ignore_dbusclose = false
          
          mouse_left_click = close_current
          mouse_middle_click = do_action, close_current
          mouse_right_click = close_all

      [urgency_low]
          background = "#1a1b26"
          foreground = "#c0caf5"
          frame_color = "#00FFFF"
          timeout = 3
          
      [urgency_normal]
          background = "#1a1b26"
          foreground = "#c0caf5"
          frame_color = "#8A2BE2"
          timeout = 5
          script = "mpg123 ${jarvisSoundsDir}/jarvis-notification.mp3"
          
      [urgency_critical]
          background = "#f7768e"
          foreground = "#1a1b26"
          frame_color = "#FF69B4"
          timeout = 0
          script = "mpg123 ${jarvisSoundsDir}/jarvis-warning.mp3"
    '';
  };

  # ========================================
  # J.A.R.V.I.S. SYSTEMD SERVICES
  # ========================================
  
  systemd.user.services.jarvis-monitor = {
    description = "J.A.R.V.I.S. System Monitor";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "/etc/wehttamsnaps/jarvis-monitor.sh";
      Restart = "always";
      RestartSec = 10;
    };
  };

  # ========================================
  # SUDOERS FOR JARVIS SCRIPTS
  # ========================================
  
  security.sudo.extraRules = [
    {
      users = [ "wehttamsnaps" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
