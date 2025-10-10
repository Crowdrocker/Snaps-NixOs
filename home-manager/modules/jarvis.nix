{ config, pkgs, ... }:

{
  # === J.A.R.V.I.S. SOUND INTEGRATION ===

  home.file = {
    # J.A.R.V.I.S. sound manager script
    ".local/bin/jarvis-sound".source = pkgs.writeShellScript "jarvis-sound" ''
      #!/usr/bin/env bash

      SOUNDS_DIR="$HOME/.local/share/sounds/jarvis"

      play_sound() {
        local sound="$1"
        if [ -f "$SOUNDS_DIR/$sound.mp3" ]; then
          ${pkgs.mpv}/bin/mpv --no-video "$SOUNDS_DIR/$sound.mp3" &> /dev/null &
        fi
      }

      case "$1" in
        startup)
          play_sound "jarvis-startup"
          ;;
        shutdown)
          play_sound "jarvis-shutdown"
          ;;
        notification)
          play_sound "jarvis-notification"
          ;;
        warning)
          play_sound "jarvis-warning"
          ;;
        gaming)
          play_sound "jarvis-gaming"
          ;;
        streaming)
          play_sound "jarvis-streaming"
          ;;
        *)
          echo "Usage: jarvis-sound {startup|shutdown|notification|warning|gaming|streaming}"
          exit 1
          ;;
      esac
    '';

    # Gaming mode toggle script
    ".local/bin/toggle-gaming-mode.sh".source = pkgs.writeShellScript "toggle-gaming-mode" ''
      #!/usr/bin/env bash

      STATE_FILE="/tmp/gaming-mode-state"

      if [ -f "$STATE_FILE" ]; then
        # Disable gaming mode
        ${pkgs.systemd}/bin/systemctl --user stop gamemode.service 2>/dev/null
        rm "$STATE_FILE"
        ${pkgs.libnotify}/bin/notify-send "Gaming Mode" "Deactivated" -i input-gaming
        ~/.local/bin/jarvis-sound shutdown
      else
        # Enable gaming mode
        ${pkgs.systemd}/bin/systemctl --user start gamemode.service 2>/dev/null
        touch "$STATE_FILE"
        ${pkgs.libnotify}/bin/notify-send "Gaming Mode" "Activated - Systems at maximum performance" -i input-gaming
        ~/.local/bin/jarvis-sound gaming
      fi
    '';

    # J.A.R.V.I.S. power menu
    ".local/bin/jarvis-power-menu.sh".source = pkgs.writeShellScript "jarvis-power-menu" ''
      #!/usr/bin/env bash

      # WehttamSnaps themed power menu
      OPTIONS="⏻ Shutdown\n⏾ Reboot\n⏸ Sleep\n🔒 Lock\n⎌ Logout"

      CHOICE=$(echo -e "$OPTIONS" | ${pkgs.fuzzel}/bin/fuzzel --dmenu \
        --prompt="J.A.R.V.I.S. System Control: " \
        --width=30 \
        --lines=5)

      case "$CHOICE" in
        "⏻ Shutdown")
          ~/.local/bin/jarvis-sound shutdown
          sleep 2
          systemctl poweroff
          ;;
        "⏾ Reboot")
          ~/.local/bin/jarvis-sound shutdown
          sleep 2
          systemctl reboot
          ;;
        "⏸ Sleep")
          systemctl suspend
          ;;
        "🔒 Lock")
          ${pkgs.hyprlock}/bin/hyprlock
          ;;
        "⎌ Logout")
          ~/.local/bin/jarvis-sound shutdown
          sleep 1
          hyprctl dispatch exit
          ;;
      esac
    '';

    # Temperature monitoring script
    ".local/bin/check-temps.sh".source = pkgs.writeShellScript "check-temps" ''
      #!/usr/bin/env bash

      # Check CPU temp
      CPU_TEMP=$(${pkgs.lm_sensors}/bin/sensors | grep 'Package id 0:' | awk '{print $4}' | sed 's/+//;s/°C//')

      # Check GPU temp (AMD)
      GPU_TEMP=$(${pkgs.lm_sensors}/bin/sensors | grep 'edge:' | awk '{print $2}' | sed 's/+//;s/°C//')

      # Warning threshold
      if (( $(echo "$CPU_TEMP > 80" | ${pkgs.bc}/bin/bc -l) )); then
        ${pkgs.libnotify}/bin/notify-send "Temperature Warning" "CPU: ''${CPU_TEMP}°C" -u critical
        ~/.local/bin/jarvis-sound warning
      fi

      if (( $(echo "$GPU_TEMP > 85" | ${pkgs.bc}/bin/bc -l) )); then
        ${pkgs.libnotify}/bin/notify-send "Temperature Warning" "GPU: ''${GPU_TEMP}°C" -u critical
        ~/.local/bin/jarvis-sound warning
      fi
    '';
  };

  # Make scripts executable
  home.activation.makeScriptsExecutable = ''
    chmod +x $HOME/.local/bin/*
  '';

  # === SYSTEMD USER SERVICES ===
  systemd.user.services = {
    # Temperature monitor service
    temperature-monitor = {
      Unit = {
        Description = "J.A.R.V.I.S. Temperature Monitor";
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.bash}/bin/bash -c 'while true; do $HOME/.local/bin/check-temps.sh; sleep 60; done'";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "hyprland-session.target" ];
    };
  };

  # === DUNST NOTIFICATION HOOKS ===
  services.dunst.settings = {
    global = {
      # Play J.A.R.V.I.S. sound on notifications
      script = "~/.local/bin/jarvis-sound notification";
    };

    urgency_critical = {
      background = "#ff0000";
      foreground = "#ffffff";
      timeout = 0;
      # Play warning sound for critical notifications
      script = "~/.local/bin/jarvis-sound warning";
    };
  };
}
