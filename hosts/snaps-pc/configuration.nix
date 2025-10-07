# WehttamSnaps Main System Configuration
# Intel i5-4430 + AMD RX 580 + 16GB RAM

{ config, pkgs, inputs, username, hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # SYSTEM INFORMATION
  # ============================================================================
  
  networking.hostName = hostname;
  time.timeZone = "America/New_York"; # Adjust to your timezone
  
  # ============================================================================
  # NIX CONFIGURATION
  # ============================================================================
  
  nix = {
    settings = {
      # Enable flakes and new nix command
      experimental-features = [ "nix-command" "flakes" ];
      
      # Optimize storage
      auto-optimise-store = true;
      
      # Trusted users for nix commands
      trusted-users = [ "root" username ];
      
      # Substituters for faster downloads
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://niri.cachix.org"
        "https://chaotic-nyx.cachix.org"
      ];
      
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
    };
    
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  
  # Allow unfree packages (needed for Steam, Discord, etc.)
  nixpkgs.config.allowUnfree = true;
  
  # ============================================================================
  # BOOT CONFIGURATION
  # ============================================================================
  
  boot = {
    # Use CachyOS kernel for gaming performance
    kernelPackages = pkgs.linuxPackages_cachyos;
    
    # Kernel parameters for AMD GPU and gaming
    kernelParams = [
      "amd_pstate=active"           # AMD P-State driver for better power management
      "amdgpu.ppfeaturemask=0xffffffff"  # Enable all AMD GPU features
      "mitigations=off"             # Disable CPU mitigations for performance (optional)
    ];
    
    # Kernel modules
    kernelModules = [ "amdgpu" ];
    
    # Bootloader configuration
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      
      # Timeout for boot menu
      timeout = 5;
      
      # GRUB theme (if you prefer GRUB over systemd-boot)
      # grub = {
      #   enable = true;
      #   device = "nodev";
      #   efiSupport = true;
      #   useOSProber = true; # Detect Windows
      #   theme = ./path/to/grub/theme;
      # };
    };
    
    # Enable OS-Prober to detect Windows
    loader.grub.useOSProber = true;
  };
  
  # ============================================================================
  # HARDWARE CONFIGURATION
  # ============================================================================
  
  hardware = {
    # OpenGL/Graphics
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true; # For 32-bit games
      
      # AMD GPU drivers
      extraPackages = with pkgs; [
        amdvlk           # AMD Vulkan driver
        rocm-opencl-icd  # OpenCL support
        rocm-opencl-runtime
      ];
      
      # 32-bit AMD drivers for gaming
      extraPackages32 = with pkgs.pkgsi686Linux; [
        amdvlk
      ];
    };
    
    # CPU microcode updates
    cpu.intel.updateMicrocode = true;
    
    # Enable firmware updates
    enableRedistributableFirmware = true;
  };
  
  # ============================================================================
  # CHAOTIC-NYX CONFIGURATION
  # ============================================================================
  
  chaotic = {
    # Enable Chaotic-Nyx cache
    nyx.cache.enable = true;
    
    # Use Mesa-git for latest AMD driver improvements
    mesa-git.enable = true;
  };
  
  # ============================================================================
  # GAMING OPTIMIZATIONS
  # ============================================================================
  
  programs = {
    # GameMode - Automatic performance optimizations
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
          ioprio = 0;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };
      };
    };
    
    # Steam
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      
      # Gamescope session
      gamescopeSession.enable = true;
      
      # Extra compatibility tools
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
  
  # ============================================================================
  # AUDIO CONFIGURATION (PipeWire)
  # ============================================================================
  
  # Disable PulseAudio
  hardware.pulseaudio.enable = false;
  
  # Enable PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # Low latency configuration
    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 512;
        "default.clock.max-quantum" = 2048;
      };
    };
  };
  
  # RealtimeKit for audio priority
  security.rtkit.enable = true;
  
  # ============================================================================
  # DESKTOP ENVIRONMENT (Niri + Noctalia)
  # ============================================================================
  
  # Enable Niri compositor
  programs.niri.enable = true;
  
  # Display manager (SDDM)
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sugar-candy"; # Will be customized
    };
  };
  
  # Wayland support
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint Electron apps to use Wayland
    MOZ_ENABLE_WAYLAND = "1"; # Firefox Wayland
  };
  
  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================
  
  environment.systemPackages = with pkgs; [
    # System utilities
    wget curl git vim neovim
    htop btop
    tree
    unzip zip
    
    # File managers
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    
    # Terminal
    kitty
    
    # Launcher
    rofi-wayland
    fuzzel
    
    # Notifications
    dunst
    mako
    
    # Wallpaper
    swww
    hyprpaper
    
    # Screenshots
    grim
    slurp
    swappy
    
    # System info
    neofetch
    fastfetch
    
    # Audio control
    pavucontrol
    qpwgraph
    helvum
    
    # Gaming utilities
    mangohud
    goverlay
    gamemode
    gamescope
    
    # GPU control
    corectrl
    lact
    
    # Streaming
    obs-studio
    
    # Browser
    firefox
    
    # Communication
    discord
    
    # Development
    vscode
    
    # Quickshell (for Noctalia)
    quickshell
  ];
  
  # ============================================================================
  # SERVICES
  # ============================================================================
  
  services = {
    # Enable CUPS for printing
    printing.enable = true;
    
    # Enable USB automounting
    udisks2.enable = true;
    gvfs.enable = true;
    
    # Enable Flatpak
    flatpak.enable = true;
    
    # Enable SSH
    openssh.enable = true;
  };
  
  # ============================================================================
  # NETWORKING
  # ============================================================================
  
  networking = {
    networkmanager.enable = true;
    
    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ]; # SSH
      allowedUDPPorts = [ ];
    };
  };
  
  # ============================================================================
  # USERS
  # ============================================================================
  
  users.users.${username} = {
    isNormalUser = true;
    description = "Matthew (WehttamSnaps)";
    extraGroups = [ 
      "networkmanager" 
      "wheel"          # sudo access
      "audio"
      "video"
      "input"
      "gamemode"       # GameMode access
    ];
    shell = pkgs.zsh;
  };
  
  # Enable Zsh system-wide
  programs.zsh.enable = true;
  
  # ============================================================================
  # SECURITY
  # ============================================================================
  
  security = {
    # Sudo configuration
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };
    
    # Polkit for privilege escalation
    polkit.enable = true;
  };
  
  # ============================================================================
  # FONTS
  # ============================================================================
  
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Meslo" ]; })
    ];
    
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };
  
  # ============================================================================
  # SYSTEM STATE VERSION
  # ============================================================================
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Don't change this unless you know what you're doing.
  system.stateVersion = "24.11";
}