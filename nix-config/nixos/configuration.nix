{ config, pkgs, lib, inputs, username, hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/nixos/core.nix
    ../modules/nixos/gaming.nix
    ../modules/nixos/audio.nix
    ../modules/nixos/graphics.nix
  ];

  # System information
  system.stateVersion = "25.05";
  
  # User configuration
  users.users.${username} = {
    isNormalUser = true;
    description = "WehttamSnaps";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "games" ];
    shell = pkgs.zsh;
    # Initial password - change after first boot
    initialPassword = "wehttamsnaps";
  };

  # Enable sudo
  security.sudo.wheelNeedsPassword = false;

  # Networking
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "America/New_York";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # Enable the X11 windowing system
  services.xserver.enable = false;

  # Enable the Niri window manager
  services.displayManager = {
    enable = true;
    defaultSession = "niri";
  };

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Enable printing
  services.printing.enable = true;

  # Enable OpenSSH
  services.openssh.enable = true;

  # Enable automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    nano
    git
    wget
    curl
    htop
    neofetch
    fastfetch
    eza
    bat
    fd
    ripgrep
    fzf
    tree
    tldr
  ];

  # Gaming packages will be added via modules
}