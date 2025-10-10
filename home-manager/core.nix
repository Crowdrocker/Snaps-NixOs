{ config, pkgs, lib, username, hostname, ... }:

{
  # Basic home configuration
  home.packages = with pkgs; [
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
    tldr
    
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
    
    # Terminal emulators
    kitty
    alacritty
    
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

  # Enable GTK and Qt theming
  gtk = {
    enable = true;
    theme = {
      name = "TokyoNight-Dark";
      package = pkgs.tokyo-night-gtk-theme;
    };
    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-icon-theme;
    };
    font = {
      name = "Inter";
      package = pkgs.inter;
      size = 12;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "gtk2";
      package = pkgs.qt5.qtbase;
    };
  };

  # Enable XDG directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
      desktop = "$HOME/Desktop";
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "WehttamSnaps";
    userEmail = "wehttamsnaps@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}