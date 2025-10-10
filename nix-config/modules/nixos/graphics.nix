{ config, pkgs, lib, inputs, ... }:

{
  # Enable Niri window manager
  services.displayManager = {
    enable = true;
    defaultSession = "niri";
  };

  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.system}.default;
  };

  # Graphics packages
  environment.systemPackages = with pkgs; [
    kitty
    alacritty
    foot
    xorg.xrandr
    arandr
  ];

  # Display configuration
  services.xserver = {
    enable = false;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}