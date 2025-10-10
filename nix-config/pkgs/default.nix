{ pkgs }:

with pkgs; {
  # Custom packages
  jarvis-cli = callPackage ./jarvis-cli { };
  wehttamsnaps-wallpaper = callPackage ./wallpapers { };
}