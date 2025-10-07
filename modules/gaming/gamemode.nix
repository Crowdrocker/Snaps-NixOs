# GameMode Configuration
# Automatic performance optimizations when gaming

{ config, pkgs, ... }:

{
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    
    settings = {
      general = {
        # Renice game process for higher priority
        renice = 10;
        
        # Set I/O priority
        ioprio = 0;
        
        # Inhibit screensaver
        inhibit_screensaver = 1;
        
        # Default timeout (0 = no timeout)
        defaultgov = "performance";
      };
      
      gpu = {
        # Apply GPU optimizations
        apply_gpu_optimisations = "accept-responsibility";
        
        # GPU device (0 = first GPU)
        gpu_device = 0;
        
        # AMD performance level
        amd_performance_level = "high";
      };
      
      cpu = {
        # Pin game to specific cores (optional)
        # pin_cores = "0-3";
        
        # Park cores (optional)
        # park_cores = "4-7";
      };
      
      custom = {
        # Scripts to run when GameMode starts
        start = pkgs.writeShellScript "gamemode-start" ''
          # Play J.A.R.V.I.S. gaming mode sound
          ${pkgs.mpv}/bin/mpv ~/.config/sounds/jarvis-gaming.mp3 &
          
          # Send notification
          ${pkgs.libnotify}/bin/notify-send "GameMode Activated" "Systems at maximum performance" -i applications-games -u normal
          
          # Set CPU governor to performance
          echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
          
          # Disable compositor (if needed)
          # niri msg action disable-compositor
        '';
        
        # Scripts to run when GameMode ends
        end = pkgs.writeShellScript "gamemode-end" ''
          # Send notification
          ${pkgs.libnotify}/bin/notify-send "GameMode Deactivated" "Returning to normal operation" -i applications-games -u low
          
          # Set CPU governor back to schedutil
          echo schedutil | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
          
          # Re-enable compositor (if needed)
          # niri msg action enable-compositor
        '';
      };
    };
  };
  
  # ============================================================================
  # GAMEMODE SUDOERS RULES
  # ============================================================================
  
  # Allow gamemode to change CPU governor without password
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