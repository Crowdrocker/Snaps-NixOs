{ pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    fira-code
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-code-pro
  ];
}

