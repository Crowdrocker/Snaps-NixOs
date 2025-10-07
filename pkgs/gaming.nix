# WehttamSnaps Gaming Configuration
# Optimized for AMD RX 580 on NixOS

{ config, pkgs, lib, ... }:

{
  # ========================================
  # GAMING PACKAGES
  # ========================================
  
  environment.systemPackages = with pkgs; [
    # Game launchers and platforms
    steam
    lutris
    heroic
    bottles
    
    # Game streaming
    obs-studio
    obs-studio-plugins.obs-pipewire-audio-capture
    obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.obs-gstreamer
    
    # Gaming utilities
    gamemode
    gamescope
    mangohud
    goverlay
    
    # Performance monitoring
    corectrl
    # lact # AMD GPU controller
    
    # Wine and Proton
    wine
    winetricks
    protontricks
    protonup-qt
    
    # Mod managers
    # nexusmods-app # Official Nexus Mods app
    
    # Streaming tools
    streamlink
    
    # Discord with streaming support
    vesktop  # Discord with better streaming
    
    # Additional gaming tools
    antimicrox # Controller mapping
    sc-controller # Steam Controller GUI
  ];

  # ========================================
  # STEAM CONFIGURATION
  # ========================================
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    
    # Enable game-specific launch options optimization
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # ========================================
  # GAMEMODE CONFIGURATION
  # ========================================
  
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        ioprio = 0;
        inhibit_screensaver = 1;
      };
      
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
      
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode activated' && ${pkgs.mpg123}/bin/mpg123 /home/wehttamsnaps/.config/jarvis/sounds/jarvis-gaming.mp3";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode deactivated'";
      };
    };
  };

  # ========================================
  # AMD GPU OPTIMIZATIONS
  # ========================================
  
  # AMD specific kernel parameters
  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"  # Enable all power features
    "amd_iommu=on"                      # Enable IOMMU for better performance
  ];

  # Enable AMD GPU performance features
  systemd.tmpfiles.rules = [
    "w /sys/class/drm/card0/device/power_dpm_force_performance_level - - - - high"
    "w /sys/class/drm/card0/device/pp_power_profile_mode - - - - 1"
  ];

  # ========================================
  # GAMING ENVIRONMENT VARIABLES
  # ========================================
  
  environment.sessionVariables = {
    # AMD GPU optimization
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "aco,nggc";
    
    # Enable FSR (FidelityFX Super Resolution)
    WINE_FULLSCREEN_FSR = "1";
    
    # Gamescope variables
    GAMESCOPE_WAYLAND_DISPLAY = "wayland-1";
    
    # MangoHud
    MANGOHUD = "1";
    MANGOHUD_CONFIG = "cpu_temp,gpu_temp,cpu_load_value,gpu_load_value,ram,vram,fps,frametime,frame_timing=0,position=top-right";
    
    # Steam
    STEAM_FORCE_DESKTOPUI_SCALING = "1";
    
    # Proton
    PROTON_ENABLE_NVAPI = "1";
    PROTON_ENABLE_NGX_UPDATER = "1";
    DXVK_ASYNC = "1";
    DXVK_STATE_CACHE = "1";
    
    # Wine
    WINEFSYNC = "1";
    WINEESYNC = "1";
  };

  # ========================================
  # GAMING SERVICES
  # ========================================
  
  # Automatic gamemode detection script
  systemd.user.services.gamemode-watcher = {
    description = "Watch for games and enable GameMode automatically";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.writeShellScript "gamemode-watcher" ''
        #!/usr/bin/env bash
        # This script monitors for game processes and automatically enables GameMode
        
        GAME_PROCESSES=(
          "steam"
          "wine"
          "proton"
          "hl2_linux"
          "csgo_linux"
          "dota2"
          "Division"
          "Cyberpunk"
          "Fallout"
        )
        
        while true; do
          for proc in "''${GAME_PROCESSES[@]}"; do
            if pgrep -x "$proc" > /dev/null; then
              if ! gamemoded -s | grep -q "is active"; then
                gamemode start
                notify-send "Gaming Mode" "Detected $proc - GameMode activated"
                mpg123 /home/wehttamsnaps/.config/jarvis/sounds/jarvis-gaming.mp3 &
              fi
              break
            fi
          done
          sleep 5
        done
      ''}";
      Restart = "always";
      RestartSec = 10;
    };
  };

  # CoreCtrl for GPU control
  systemd.user.services.corectrl = {
    description = "CoreCtrl";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.corectrl}/bin/corectrl --minimize-systray";
      Restart = "on-failure";
    };
  };

  # ========================================
  # FAN CONTROL SETUP
  # ========================================
  
  # Enable lm_sensors for temperature monitoring
  environment.systemPackages = with pkgs; [
    lm_sensors
    fancontrol
  ];

  # Fancontrol service (configure after running sensors-detect)
  systemd.services.fancontrol = {
    description = "Fan Control Service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.fancontrol}/bin/fancontrol";
      Restart = "always";
      RestartSec = 10;
    };
  };

  # ========================================
  # FIREWALL FOR GAMING
  # ========================================
  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      27015 27036  # Steam Remote Play
      47984 47989 47990 48010  # Steam Link
    ];
    allowedUDPPorts = [ 
      27015 27031 27036  # Steam
      47998 47999 48000 48010  # Steam Link
    ];
  };

  # ========================================
  # UDEV RULES FOR CONTROLLERS
  # ========================================
  
  services.udev.extraRules = ''
    # Steam Controller
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
    
    # Xbox Controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", MODE="0666"
    
    # PlayStation Controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", MODE="0666"
    
    # Nintendo Controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", MODE="0666"
  '';

  # ========================================
  # SYSTEM LIMITS FOR GAMING
  # ========================================
  
  security.pam.loginLimits = [
    { domain = "@gamemode"; item = "nice"; type = "-"; value = "-10"; }
    { domain = "@gamemode"; item = "rtprio"; type = "-"; value = "99"; }
  ];

  # Increase file descriptor limits for games
  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
  '';

  # ========================================
  # STEAM LIBRARY MOUNT
  # ========================================
  
  # Auto-mount gaming drive
  fileSystems."/run/media/wehttamsnaps/LINUXDRIVE-1" = {
    device = "/dev/disk/by-label/LINUXDRIVE-1";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-gvfs-show" ];
  };
}
