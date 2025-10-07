{ pkgs, ... }:

{
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.starship.enable = true;

  environment.systemPackages = with pkgs; [
    zsh
    fish
    starship
    bat
    fd
    ripgrep
    eza
    lsd
    zoxide
    tree
    ncdu
    shfmt
    tldr
  ];
}

