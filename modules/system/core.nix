{ config, pkgs, lib, ... }:

{
  # Enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = [
      "https://cache.nixos.org/"
      "https://chaotic-nyx.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/np++1Zm9xH2Hf1VXIKz1iNfZ5bCN4="
    ];
  };

  # Enable automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    nix-prefetch-git
    nix-prefetch-github
    nix-update
  ];

  # Enable Nix daemon
  nix.enable = true;
  
  # Use zsh as default shell
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableAutosuggestions = true;
  
  # Enable fish shell
  programs.fish.enable = true;
  
  # Enable bash
  programs.bash.enable = true;
}