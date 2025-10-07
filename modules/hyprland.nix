{ pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hyprland
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    hyprshot
    waybar
    xwayland
    xdg-desktop-portal
    xdg-desktop-portal-wlr
  ];
}

