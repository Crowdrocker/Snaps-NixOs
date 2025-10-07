outputs = { self, nixpkgs, ... }:
let
  system = "x86_64-linux";
overlays = [
  (import ./pkgs)
];
  pkgs = import nixpkgs {
    inherit system;
    overlays = overlays;
  };
in {
  # your nixosConfigurations...
}
outputs = { self, nixpkgs, ... }:
let
  system = "x86_64-linux";
  overlays = [ (import ./pkgs) ];
  pkgs = import nixpkgs { inherit system; overlays = overlays; };
in {
  packages.${system}.matugen-bin = pkgs.matugen-bin;
  packages.${system}.hyprshade = pkgs.hyprshade;
  packages.${system}.grub-hook = pkgs.grub-hook;

  # your nixosConfigurations...
}

