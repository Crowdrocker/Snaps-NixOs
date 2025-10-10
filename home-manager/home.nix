{ config, pkgs, lib, username, hostname, ... }:

{
  imports = [
    ./core.nix
    ./shell.nix
    ./terminal.nix
    ./applications.nix
    ./gaming.nix
    ./audio.nix
    ./themes.nix
  ];

  # Home Manager version
  home.stateVersion = "25.05";

  # User information
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Enable home-manager
  programs.home-manager.enable = true;
}