# Home Manager Configuration for WehttamSnaps
# User-level configuration and dotfiles

{ config, pkgs, inputs, username, ... }:

{
  # ============================================================================
  # HOME MANAGER SETTINGS
  # ============================================================================
  
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };

  # ============================================================================
  # USER PACKAGES
  # ============================================================================
  
  home.packages = with pkgs; [
    # Photography & Design
    gimp
    krita
    inkscape
    darktable
    rawtherapee
    
    # Gaming
    lutris
    heroic
    bottles
    
    # Media
    spotify
    vlc
    mpv
    
    # Utilities
    file-roller
    gnome.nautilus
    
    # Development
    nodejs
    python3
    
    # System monitoring
    nvtop
    
    # Screenshot tools
    flameshot
  ];

  # ============================================================================
  # PROGRAM CONFIGURATIONS
  # ============================================================================
  
  programs = {
    # Let Home Manager manage itself
    home-manager.enable = true;
    
    # Git configuration
    git = {
      enable = true;
      userName = "Crowdrocker";
      userEmail = "your-email@example.com"; # Update this
      
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };
    
    # Zsh shell
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      
      shellAliases = {
        # System management
        rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#snaps-pc";
        update = "cd ~/nixos-config && nix flake update && sudo nixos-rebuild switch --flake .#snaps-pc";
        clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
        
        # Quick navigation
        ll = "ls -lah";
        la = "ls -A";
        l = "ls -CF";
        
        # Git shortcuts
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gl = "git log --oneline --graph";
        
        # Gaming
        steam-launch = "gamemoderun steam";
        
        # System info
        sysinfo = "fastfetch";
        
        # Audio
        audio-routing = "qpwgraph";
      };
      
      initExtra = ''
        # Starship prompt
        eval "$(starship init zsh)"
        
        # Custom greeting
        if command -v fastfetch &> /dev/null; then
          fastfetch
        fi
      '';
    };
    
    # Bash (fallback)
    bash = {
      enable = true;
      shellAliases = config.programs.zsh.shellAliases;
    };
    
    # Starship prompt
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
        };
        
        git_branch = {
          symbol = " ";
        };
        
        nix_shell = {
          symbol = " ";
        };
      };
    };
    
    # Kitty terminal
    kitty = {
      enable = true;
      theme = "Tokyo Night";
      
      settings = {
        font_family = "JetBrainsMono Nerd Font";
        font_size = 11;
        
        background_opacity = "0.95";
        
        enable_audio_bell = false;
        
        # WehttamSnaps colors (violet to cyan gradient)
        foreground = "#c0caf5";
        background = "#1a1b26";
        
        # Cursor
        cursor = "#8A2BE2";
        cursor_text_color = "#1a1b26";
        
        # Selection
        selection_foreground = "#1a1b26";
        selection_background = "#00FFFF";
      };
    };
    
    # Rofi launcher
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = "~/.config/rofi/themes/wehttamsnaps.rasi";
    };
    
    # Fastfetch
    fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "~/.config/fastfetch/wehttamsnaps-logo.txt";
          padding = {
            top = 1;
          };
        };
        
        display = {
          separator = " → ";
        };
        
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "de"
          "wm"
          "terminal"
          "cpu"
          "gpu"
          "memory"
          "disk"
          "colors"
        ];
      };
    };
  };

  # ============================================================================
  # XDG CONFIGURATION
  # ============================================================================
  
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
      
      # Custom directories
      publicShare = "/run/media/wehttamsnaps/LINUXDRIVE-1/Shared";
      templates = "${config.home.homeDirectory}/Templates";
    };
    
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        
        "image/jpeg" = "gimp.desktop";
        "image/png" = "gimp.desktop";
        
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
      };
    };
  };

  # ============================================================================
  # NIRI CONFIGURATION
  # ============================================================================
  
  xdg.configFile."niri/config.kdl".source = ./../../home/programs/niri/config.kdl;
  xdg.configFile."niri/keybinds.kdl".source = ./../../home/programs/niri/keybinds.kdl;
  xdg.configFile."niri/window-rules.kdl".source = ./../../home/programs/niri/window-rules.kdl;
  xdg.configFile."niri/layout.kdl".source = ./../../home/programs/niri/layout.kdl;
  xdg.configFile."niri/animations.kdl".source = ./../../home/programs/niri/animations.kdl;
  xdg.configFile."niri/startup.kdl".source = ./../../home/programs/niri/startup.kdl;
  xdg.configFile."niri/environment.kdl".source = ./../../home/programs/niri/environment.kdl;

  # ============================================================================
  # QUICKSHELL/NOCTALIA CONFIGURATION
  # ============================================================================
  
  xdg.configFile."quickshell".source = ./../../home/programs/quickshell;

  # ============================================================================
  # DUNST NOTIFICATION DAEMON
  # ============================================================================
  
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "10x50";
        
        notification_limit = 5;
        
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 2;
        
        font = "JetBrainsMono Nerd Font 10";
        
        # WehttamSnaps colors
        frame_color = "#8A2BE2";
        separator_color = "frame";
        
        # Icons
        icon_position = "left";
        max_icon_size = 64;
      };
      
      urgency_low = {
        background = "#1a1b26";
        foreground = "#c0caf5";
        timeout = 5;
      };
      
      urgency_normal = {
        background = "#1a1b26";
        foreground = "#c0caf5";
        timeout = 10;
        # Play J.A.R.V.I.S. notification sound
        script = "~/.config/scripts/jarvis/notification.sh";
      };
      
      urgency_critical = {
        background = "#f7768e";
        foreground = "#1a1b26";
        frame_color = "#ff0000";
        timeout = 0;
        # Play J.A.R.V.I.S. warning sound
        script = "~/.config/scripts/jarvis/warning.sh";
      };
    };
  };

  # ============================================================================
  # GTK THEMING
  # ============================================================================
  
  gtk = {
    enable = true;
    
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # ============================================================================
  # QT THEMING
  # ============================================================================
  
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # ============================================================================
  # SESSION VARIABLES
  # ============================================================================
  
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    
    # Gaming
    GAMING_DRIVE = "/run/media/wehttamsnaps/LINUXDRIVE-1";
    
    # AMD GPU
    AMD_VULKAN_ICD = "RADV";
    
    # Wayland
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # ============================================================================
  # SYSTEMD USER SERVICES
  # ============================================================================
  
  systemd.user.services = {
    # J.A.R.V.I.S. startup sound
    jarvis-startup = {
      Unit = {
        Description = "J.A.R.V.I.S. Startup Sound";
        After = [ "graphical-session.target" ];
      };
      
      Service = {
        Type = "oneshot";
        ExecStart = "${config.home.homeDirectory}/.config/scripts/jarvis/startup.sh";
      };
      
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}