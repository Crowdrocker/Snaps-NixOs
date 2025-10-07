{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fastfetch
    neofetch
    lolcat
    figlet
    flameshot
    swww
    waypaper
    dunst
    rofi
    tokyonight-gtk-theme
    tela-circle-icon-theme
    bibata-cursor-theme
  ];
}

