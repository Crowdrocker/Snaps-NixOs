{ config, pkgs, lib, inputs, ... }:

{
  # Shell configurations
  programs = {
    zsh = {
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

    fish = {
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

    bash = {
      enable = true;
      shellAliases = {
        ll = "eza -la --icons";
        la = "eza -a --icons";
        l = "eza --icons";
        tree = "eza --tree --icons";
      };
    };
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "helix";
    VISUAL = "helix";
    BROWSER = "firefox";
    
    # Gaming environment
    STEAM_FORCE_DESKTOPUI_SCALING = "1";
    STEAM_RUNTIME = "1";
    DXVK_LOG_LEVEL = "none";
    MANGOHUD = "1";
    
    # J.A.R.V.I.S. environment
    JARVIS_HOME = "${config.home.homeDirectory}/.config/jarvis";
    JARVIS_SOUNDS = "${config.home.homeDirectory}/.config/jarvis/sounds";
  };
}