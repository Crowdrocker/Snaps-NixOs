self: super:

{
  matugen-bin = super.callPackage ./matugen-bin.nix {};
  hyprshade = super.callPackage ./hyprshade.nix {};
  grub-hook = super.callPackage ./grub-hook.nix {};
}

