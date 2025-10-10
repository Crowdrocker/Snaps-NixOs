{ config, pkgs, lib, username, hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/core.nix
    ../../modules/system/networking.nix
    ../../modules/system/audio.nix
    ../../modules/system/printing.nix
    ../../modules/gaming/steam.nix
    ../../modules/gaming/amd-gpu.nix
    ../../modules/graphics/niri.nix
  ];

  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Core utilities
    wget
    curl
    unzip
    zip
    p7zip
    unrar
    
    # System monitoring
    htop
    btop
    neofetch
    fastfetch
    duf
    
    # File management
    eza
    bat
    fd
    ripgrep
    fzf
    tree
    
    # Development tools
    git
    github-cli
    gcc
    gdb
    valgrind
    
    # Text editors
    vim
    nano
    helix
    
    # Browsers
    firefox
    chromium
    google-chrome
    
    # Media tools
    vlc
    mpv
    ffmpeg
    gimp
    inkscape
    blender
    audacity
    
    # Office tools
    libreoffice
    okular
    
    # Fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    inter
    terminus_font
    jetbrains-mono
    fira-code
    nerdfonts
    
    # Terminal emulators
    kitty
    alacritty
    foot
    
    # Shells
    zsh
    fish
    starship
    
    # Audio tools
    pavucontrol
    qpwgraph
    helvum
    
    # Gaming tools
    mangohud
    gamescope
    gamemode
    lutris
    heroic
    bottles
    
    # GPU tools
    corectrl
    lact
    
    # Flatpak support
    flatpak
    
    # J.A.R.V.I.S. tools
    espeak-ng
    sox
    ffmpeg
  ];

  # Enable NixOS unstable
  nixpkgs.config.allowUnfree = true;
  
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Enable chaotic-cx packages
  nixpkgs.overlays = [ (import "${chaotic}/overlay.nix") ];
  
  # Enable flatpak
  services.flatpak.enable = true;
  
  # User configuration
  users.users.${username} = {
    isNormalUser = true;
    description = "WehttamSnaps";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "docker" "games" ];
    shell = pkgs.zsh;
  };
  
  # Default editor
  programs.zsh.enable = true;
  programs.fish.enable = true;
  
  # OpenSSH
  services.openssh.enable = true;
  
  # Printing
  services.printing.enable = true;
  
  # Enable sudo
  security.sudo.wheelNeedsPassword = false;
  
  # System state version
  system.stateVersion = "25.05";
}