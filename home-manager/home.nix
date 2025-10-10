{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./modules/hyprland.nix
    ./modules/noctalia.nix
    ./modules/terminal.nix
    ./modules/audio.nix
    ./modules/jarvis.nix
  ];

  home = {
    username = "wehttamsnaps";
    homeDirectory = "/home/wehttamsnaps";
    stateVersion = "24.11";

    # === USER PACKAGES ===
    packages = with pkgs; [
      # === TERMINALS ===
      alacritty kitty foot

      # === BROWSERS ===
      firefox chromium

      # === FILE MANAGERS ===
      thunar xfce.thunar-volman
      gnome.file-roller # Archive manager

      # === MEDIA & CREATIVE ===
      vlc mpv
      gimp inkscape krita blender
      audacity
      obs-studio

      # === OFFICE ===
      libreoffice-fresh
      okular # PDF viewer

      # === GAMING ===
      lutris
      heroic
      bottles
      wine winetricks
      protontricks
      gamescope
      mangohud
      steam-run

      # Gaming mods
      # nexusmods-app # Add when available in nixpkgs

      # === COMMUNICATION ===
      discord
      telegram-desktop

      # === UTILITIES ===
      pavucontrol # Audio control
      qpwgraph # PipeWire graph
      networkmanagerapplet

      # Wayland utilities
      wl-clipboard
      wl-clipboard-x11
      grim # Screenshot
      slurp # Screen selection
      swappy # Screenshot editor

      # === LAUNCHERS ===
      rofi-wayland
      fuzzel

      # === NOTIFICATIONS ===
      dunst
      libnotify

      # === SHELL ENHANCEMENTS ===
      starship
      zoxide

      # === DEVELOPMENT ===
      vscode
      github-desktop

      # === SYSTEM MONITORING ===
      nvtop # GPU monitoring

      # === WALLPAPERS ===
      hyprpaper
      swww

      # === THEMES ===
      flat-remix-gtk
      papirus-icon-theme

      # === QUICKSHELL (for Noctalia) ===
      qt6.qtwayland
      qt6.qtdeclarative
    ];

    # === ENVIRONMENT VARIABLES ===
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";

      # Wayland
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";

      # AMD GPU
      AMD_VULKAN_ICD = "RADV";

      # Gaming
      MANGOHUD = "1";
      MANGOHUD_DLSYM = "1";
    };

    # === FILE ASSOCIATIONS ===
    file = {
      # J.A.R.V.I.S. sounds directory
      ".local/share/sounds/jarvis" = {
        source = ./jarvis-sounds;
        recursive = true;
      };

      # Custom scripts
      ".local/bin" = {
        source = ./scripts;
        recursive = true;
      };
    };
  };

  # === NIX-COLORS THEME (WehttamSnaps Brand) ===
  colorScheme = {
    slug = "wehttamsnaps";
    name = "WehttamSnaps";
    author = "Matt";
    palette = {
      base00 = "0f0f1e"; # Dark background
      base01 = "1a1a2e"; # Lighter background
      base02 = "2e2e4e"; # Selection background
      base03 = "4a4a6a"; # Comments
      base04 = "b4b4d4"; # Dark foreground
      base05 = "e0e0ff"; # Default foreground
      base06 = "f0f0ff"; # Light foreground
      base07 = "ffffff"; # Lightest
      base08 = "ff69b4"; # Hot pink (error/important)
      base09 = "b884ff"; # Light violet
      base0A = "8a2be2"; # Blue violet (primary)
      base0B = "00ffff"; # Cyan (success)
      base0C = "4dd0e1"; # Light blue
      base0D = "0066cc"; # Deep blue
      base0E = "9f7aea"; # Purple
      base0F = "ec4899"; # Pink
    };
  };

  # === PROGRAMS ===
  programs = {
    home-manager.enable = true;

    # Git
    git = {
      enable = true;
      userName = "Crowdrocker";
      userEmail = "your-email@example.com"; # FIXME: Add your email
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };

    # Zsh with custom config
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "eza -la";
        ls = "eza";
        cat = "bat";
        find = "fd";
        grep = "rg";

        # NixOS shortcuts
        rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#snaps-pc";
        update = "cd ~/nix-config && nix flake update && rebuild";
        clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

        # System info
        temps = "sensors";
        gpu = "nvtop";

        # Quick edits
        editnix = "nvim ~/nix-config";
        edithypr = "nvim ~/.config/hypr/hyprland.conf";
      };

      initExtra = ''
        # Starship prompt
        eval "$(starship init zsh)"

        # Zoxide
        eval "$(zoxide init zsh)"

        # Custom welcome message
        if command -v fastfetch &> /dev/null; then
          fastfetch
        fi

        # J.A.R.V.I.S. startup sound
        if [ -f ~/.local/share/sounds/jarvis/jarvis-startup.mp3 ]; then
          ${pkgs.mpv}/bin/mpv --no-video ~/.local/share/sounds/jarvis/jarvis-startup.mp3 &> /dev/null &
        fi
      '';
    };

    # Starship prompt
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold cyan)";
          error_symbol = "[➜](bold red)";
        };
        directory = {
          style = "bold cyan";
          truncation_length = 3;
        };
        git_branch = {
          style = "bold purple";
        };
      };
    };

    # Kitty terminal
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 11;
      };
      settings = {
        background_opacity = "0.9";
        confirm_os_window_close = 0;
        enable_audio_bell = false;
      };
      theme = "Tokyo Night";
    };

    # Alacritty (backup terminal)
    alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.9;
        font = {
          normal.family = "JetBrainsMono Nerd Font";
          size = 11;
        };
      };
    };

    # Firefox with customization
    firefox = {
      enable = true;
      profiles.wehttamsnaps = {
        settings = {
          "browser.startup.homepage" = "https://www.youtube.com";
          "privacy.trackingprotection.enabled" = true;
        };
      };
    };

    # VSCode
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        eamodio.gitlens
      ];
    };
  };

  # === GTK THEME ===
  gtk = {
    enable = true;
    theme = {
      name = "Flat-Remix-GTK-Blue-Dark-Solid";
      package = pkgs.flat-remix-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  # === QT THEME ===
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  # === XDG ===
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";

      # Custom: Gaming drive
      extraConfig = {
        XDG_GAMES_DIR = "/run/media/wehttamsnaps/LINUXDRIVE-1/Games";
      };
    };
  };

  # === SERVICES ===
  services = {
    # Dunst notifications
    dunst = {
      enable = true;
      settings = {
        global = {
          font = "JetBrainsMono Nerd Font 10";
          markup = "full";
          format = "<b>%s</b>\\n%b";
          transparency = 10;
          frame_color = config.colorScheme.palette.base0A;
          background = config.colorScheme.palette.base00;
          foreground = config.colorScheme.palette.base05;
        };
      };
    };
  };
}
