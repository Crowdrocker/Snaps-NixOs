
{ config, pkgs, ... }:

{
  imports =
    [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hardware-configuration.nix
      ./modules/gaming.nix
      ./modules/streaming.nix
      ./modules/aesthetics.nix
      ./modules/hyprland.nix
      ./modules/devtools.nix
      ./modules/shell.nix
      ./modules/fonts.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use unstable channel for gaming
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Chaotic Nyx overlay
  nixpkgs.overlays = [
    (import (builtins.fetchTarball "https://github.com/chaotic-cx/nyx/archive/main.tar.gz"))
  ];

  # CachyOS kernel for gaming performance
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # Gaming optimizations
  boot.kernelParams = [ "mitigations=off" ];
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

  # Network
  networking.hostName = "snaps-pc";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Internationalisation
  i18n.defaultLocale = "en_US.UTF-8";

  # User account
  users.users.wehttamsnaps = {
    isNormalUser = true;
    description = "Matthew";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "games" ];
    packages = with pkgs; [];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Core
    vim wget curl git
    # Audio
    pavucontrol qpwgraph pulseaudio
    # Gaming
    gamemode gamescope mangohud
    # GPU control
    corectrl lact
    # Monitoring
    htop btop nvtop
    # Apps
    firefox discord spotify
    # File manager
    thunar
    # Terminal
    kitty
    # Theming
    gtk3
  ];

  # Enable gaming optimizations
  programs.gamemode.enable = true;
  
  # AMD GPU configuration
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      amdvlk
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };

  # PipeWire audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # CoreCtrl for GPU control
  services.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  # Niri window manager
  services.xserver = {
    enable = true;
    displayManager = {
      sddm = {
        enable = true;
        theme = "sugar-candy";
      };
    };
    desktopManager.plasma5.enable = false;
    windowManager.niri = {
      enable = true;
      package = pkgs.niri;
    };
  };

  # ZRAM for better performance
  zramSwap.enable = true;

  # Fan control
  services.thermald.enable = true;

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  system.stateVersion = "23.11";
}
