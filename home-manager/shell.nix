{ config, pkgs, lib, username, hostname, ... }:

{
  # Enable zsh
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
      alias clean-old='sudo nix-store --gc --print-roots | head -20'
      
      # J.A.R.V.I.S. integration
      alias jarvis='${./scripts/jarvis-cli.sh}'
      
      # Custom prompt
      export PS1='%F{magenta}┌[%f%F{cyan}%n@%m%f%F{magenta}]─[%f%F{yellow}%D{%H:%M:%S}%f%F{magenta}]─[%f%F{green}%~%f%F{magenta}]%f
%F{magenta}└─>%f '
      
      # Fastfetch with custom config
      alias neofetch='fastfetch --config ~/.config/fastfetch/wehttamsnaps.jsonc'
      
      # Gaming shortcuts
      alias division='steam steam://rungameid/365590'
      alias cyberpunk='steam steam://rungameid/1091500'
      alias fallout4='steam steam://rungameid/377160'
      
      # Development shortcuts
      alias dev='cd ~/Projects'
      alias gaming='cd /run/media/wehttamsnaps/LINUXDRIVE-1/Games'
    '';
    
    envExtra = ''
      # Environment variables
      export EDITOR="helix"
      export VISUAL="helix"
      export BROWSER="firefox"
      export TERM="xterm-256color"
      
      # Gaming environment
      export STEAM_FORCE_DESKTOPUI_SCALING=1
      export STEAM_RUNTIME=1
      export DXVK_LOG_LEVEL=none
      export MANGOHUD=1
      
      # Audio environment
      export PULSE_LATENCY_MSEC=60
      
      # J.A.R.V.I.S. environment
      export JARVIS_HOME="$HOME/.config/jarvis"
      export JARVIS_SOUNDS="$HOME/.config/jarvis/sounds"
    '';
  };

  # Enable fish shell
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
      
      # Gaming
      steam = "gamescope -e -f -i steam";
      lutris = "gamescope -e -f -i lutris";
      
      # System
      update = "sudo nixos-rebuild switch --flake .#snaps-pc";
      upgrade = "nix flake update && sudo nixos-rebuild switch --flake .#snaps-pc";
      clean = "sudo nix-collect-garbage -d";
      
      # J.A.R.V.I.S.
      jarvis = "${./scripts/jarvis-cli.sh}";
    };
    
    shellInit = ''
      # Environment variables
      set -gx EDITOR helix
      set -gx VISUAL helix
      set -gx BROWSER firefox
      set -gx TERM xterm-256color
      
      # Gaming
      set -gx STEAM_FORCE_DESKTOPUI_SCALING 1
      set -gx STEAM_RUNTIME 1
      set -gx DXVK_LOG_LEVEL none
      set -gx MANGOHUD 1
      
      # Audio
      set -gx PULSE_LATENCY_MSEC 60
      
      # J.A.R.V.I.S.
      set -gx JARVIS_HOME $HOME/.config/jarvis
      set -gx JARVIS_SOUNDS $HOME/.config/jarvis/sounds
      
      # Custom prompt
      function fish_prompt
          set_color magenta
          echo -n '┌['
          set_color cyan
          echo -n (whoami)@(hostname)
          set_color magenta
          echo -n ']─['
          set_color yellow
          echo -n (date "+%H:%M:%S")
          set_color magenta
          echo -n ']─['
          set_color green
          echo -n (prompt_pwd)
          set_color magenta
          echo ']'
          set_color magenta
          echo -n '└─> '
          set_color normal
      end
    '';
  };

  # Enable Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };
      
      git_branch = {
        symbol = "🌱 ";
        format = "on [$symbol$branch]($style) ";
      };
      
      git_status = {
        format = "([$all_status$ahead_behind]($style)) ";
        conflicted = "🏳";
        ahead = "⇡${count}";
        behind = "⇣${count}";
        diverged = "⇕⇡${ahead_count}⇣${behind_count}";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        staged = '[++\($count\)](green)';
        renamed = "👅";
        deleted = "🗑";
      };
      
      cmd_duration = {
        min_time = 500;
        format = "[$duration]($style) ";
      };
      
      hostname = {
        ssh_only = false;
        format = "on [$hostname]($style) ";
        style = "bold dimmed green";
      };
      
      username = {
        format = "[$user]($style) ";
        style_user = "bold green";
        style_root = "bold red";
        show_always = true;
      };
      
      line_break = {
        disabled = false;
      };
      
      battery = {
        disabled = false;
        format = "[$symbol$percentage]($style) ";
        charging_symbol = "🔋";
        discharging_symbol = "🔋";
        unknown_symbol = "🔋";
      };
      
      memory_usage = {
        disabled = false;
        format = "[$symbol$ram( | $swap)]($style) ";
        symbol = "🧠 ";
      };
      
      custom = {
        gaming = {
          description = "Gaming mode indicator";
          command = "echo '🎮'";
          when_command = "test -f /tmp/gaming_mode";
          format = "[$output]($style) ";
          style = "bold green";
        };
        
        jarvis = {
          description = "J.A.R.V.I.S. status";
          command = "echo '🤖'";
          when_command = "test -f /tmp/jarvis_active";
          format = "[$output]($style) ";
          style = "bold cyan";
        };
      };
    };
  };

  # Bash configuration
  programs.bash = {
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
    
    initExtra = ''
      # Custom prompt
      export PS1='\[\033[1;35m\]┌[\[\033[1;36m\]\u@\h\[\033[1;35m\]]─[\[\033[1;33m\]\t\[\033[1;35m\]]─[\[\033[1;32m\]\w\[\033[1;35m\]]\[\033[0m\]
\[\033[1;35m\]└─>\[\033[0m\] '
      
      # Environment variables
      export EDITOR="helix"
      export VISUAL="helix"
      export BROWSER="firefox"
      
      # Gaming
      export STEAM_FORCE_DESKTOPUI_SCALING=1
      export STEAM_RUNTIME=1
      export DXVK_LOG_LEVEL=none
      export MANGOHUD=1
      
      # J.A.R.V.I.S.
      export JARVIS_HOME="$HOME/.config/jarvis"
      export JARVIS_SOUNDS="$HOME/.config/jarvis/sounds"
    '';
  };
}