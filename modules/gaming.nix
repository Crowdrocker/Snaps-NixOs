{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gamemode
    mangohud
    heroic
    lutris
    steam
    protonup-qt
    wineWowPackages.staging
    winetricks
    dxvk
    vkd3d
  ];

  programs.steam.enable = true;
}

