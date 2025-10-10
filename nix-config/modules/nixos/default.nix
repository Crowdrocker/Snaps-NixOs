{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./core.nix
    ./gaming.nix
    ./audio.nix
    ./graphics.nix
    ./networking.nix
  ];
}