{ config, pkgs, lib, inputs, ... }:

{
  # GTK theme
  gtk = {
    enable = true;
    theme = {
      name = "TokyoNight-Dark";
      package = pkgs.tokyo-night-gtk-theme;
    };
    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-icon-theme;
    };
    font = {
      name = "Inter";
      package = pkgs.inter;
      size = 12;
    };
  };

  # Qt theme
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "gtk2";
      package = pkgs.qt5.qtbase;
    };
  };

  # Terminal theme
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 12.0;
        normal = {
          family = "JetBrains Mono";
          style = "Regular";
        };
      };
      colors = {
        primary = {
          background = "#1a1b26";
          foreground = "#a9b1d6";
        };
      };
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      font_size = 12;
      font_family = "JetBrains Mono";
      background = "#1a1b26";
      foreground = "#a9b1d6";
    };
  };
}