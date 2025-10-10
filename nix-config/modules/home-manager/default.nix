{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./shell.nix
    ./themes.nix
    ./applications.nix
  ];
}