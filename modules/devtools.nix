{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    github-cli
    lazygit
    neovim
    vscode
    cmake
    jq
    nodejs
    python3
    python3Packages.pip
    lua
    luarocks
    bash-language-server
    pyright
    dart-sass
  ];
}

