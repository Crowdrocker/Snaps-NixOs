{ config, pkgs, lib, inputs, username, hostname, ... }:

{
  imports = [
    ../modules/home-manager
  ];

  # Home Manager version
  home.stateVersion = "25.05";

  # User information
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Enable home-manager
  programs.home-manager.enable = true;

  # Packages
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
  ];

  # Services
  services = {
    # Enable Flatpak
    flatpak.enable = true;
    
    # Enable GPG agent
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
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

  # Shell configurations
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "docker" "kubectl" "helm" "terraform" "aws" "gcloud" ];
    };
    
    initExtra = ''
      # WehttamSnaps custom aliases
      alias ll='eza -la --icons'
      alias la='eza -a --icons'
      alias l='eza --icons'
      alias tree='eza --tree --icons'
      alias grep='rg'
      alias cat='bat'
      alias find='fd'
      
      # Gaming aliases
      alias steam='gamescope -e -f -i steam'
      alias lutris='gamescope -e -f -i lutris'
      
      # System aliases
      alias update='sudo nixos-rebuild switch --flake .#snaps-pc'
      alias upgrade='nix flake update && sudo nixos-rebuild switch --flake .#snaps-pc'
      alias clean='sudo nix-collect-garbage -d'
      
      # J.A.R.V.I.S. integration
      alias jarvis='${config.home.homeDirectory}/.config/jarvis/scripts/jarvis-cli.sh'
    '';
  };

  # Fish shell
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "eza -la --icons";
      la = "eza -a --icons";
      l = "eza --icons";
      tree = "eza --tree --icons";
      grep = "rg";
      cat = "bat";
      find = "fd";
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };

  # GTK theme
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

  # XDG directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}