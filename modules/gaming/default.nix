# WehttamSnaps Gaming Module
# Comprehensive gaming setup for NixOS

{ config, pkgs, lib, ... }:

{
  imports = [
    ./steam.nix
    ./lutris.nix
    ./gamemode.nix
    ./optimizations.nix
  ];

  # ============================================================================
  # GAMING PACKAGES
  # ============================================================================
  
  environment.systemPackages = with pkgs; [
    # Game launchers
    steam
    lutris
    heroic
    bottles
    
    # Game utilities
    mangohud          # Performance overlay
    goverlay          # MangoHud configurator
    gamemode          # Performance optimizations
    gamescope         # Gaming compositor
    
    # Proton/Wine
    protonup-qt       # Proton-GE installer
    winetricks
    protontricks
    
    # Modding tools
    steamtinkerlaunch # Mod manager integration
    
    # Performance monitoring
    nvtop             # GPU monitor
    
    # Controller support
    antimicrox        # Controller mapping
    
    # Streaming
    obs-studio
    obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.obs-pipewire-audio-capture
  ];

  # ============================================================================
  # STEAM CONFIGURATION
  # ============================================================================
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    
    # Gamescope session for Steam Big Picture
    gamescopeSession.enable = true;
    
    # Extra compatibility tools
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # ============================================================================
  # GAMEMODE
  # ============================================================================
  
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
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations activated' -i applications-games";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations deactivated' -i applications-games";
      };
    };
  };

  # ============================================================================
  # HARDWARE OPTIMIZATIONS
  # ============================================================================
  
  # AMD GPU optimizations
  boot.kernelParams = [
    "amd_pstate=active"
    "amdgpu.ppfeaturemask=0xffffffff"
  ];
  
  # Enable AMD GPU overclocking
  boot.kernelModules = [ "amdgpu" ];
  
  # ============================================================================
  # SYSTEM OPTIMIZATIONS
  # ============================================================================
  
  # Increase file watchers for games
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.file-max" = 2097152;
    
    # Network optimizations for online gaming
    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
    "net.core.rmem_default" = 1048576;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_default" = 1048576;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    "net.ipv4.tcp_fastopen" = 3;
    
    # Reduce swappiness for gaming
    "vm.swappiness" = 10;
  };

  # ============================================================================
  # ZRAM CONFIGURATION
  # ============================================================================
  
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # ============================================================================
  # FIREWALL FOR GAMING
  # ============================================================================
  
  networking.firewall = {
    allowedTCPPorts = [
      27015  # Steam
      27036  # Steam
    ];
    
    allowedUDPPorts = [
      27015  # Steam
      27031  # Steam
      27036  # Steam
    ];
  };

  # ============================================================================
  # UDEV RULES FOR CONTROLLERS
  # ============================================================================
  
  services.udev.extraRules = ''
    # PS4 Controller
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
    
    # PS5 Controller
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0666"
    
    # Xbox Controllers
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", MODE="0666"
    
    # Nintendo Switch Pro Controller
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666"
  '';

  # ============================================================================
  # PERFORMANCE GOVERNOR
  # ============================================================================
  
  powerManagement.cpuFreqGovernor = "performance";

  # ============================================================================
  # ENABLE CORECTRL
  # ============================================================================
  
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };
}