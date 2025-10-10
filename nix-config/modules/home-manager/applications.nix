{ config, pkgs, lib, inputs, ... }:

{
  # Applications
  home.packages = with pkgs; [
    # Development
    vscode
    helix
    
    # Gaming
    discord
    obs-studio
    
    # Media
    vlc
    mpv
    spotify
    
    # Utilities
    flameshot
    keepassxc
    transmission
  ];

  # Browser configuration
  programs.firefox = {
    enable = true;
    profiles.wehttamsnaps = {
      settings = {
        "browser.startup.homepage" = "https://www.google.com";
      };
    };
  };

  # OBS Studio
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
    ];
  };

  # VS Code
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      rust-lang.rust-analyzer
      ms-python.python
    ];
  };
}