self: super:

{
  matugen-bin = super.stdenv.mkDerivation {
    pname = "matugen-bin";
    version = "latest";

    src = super.fetchurl {
      url = "https://github.com/InioX/matugen/releases/latest/download/matugen";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual hash
    };

    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/matugen
      chmod +x $out/bin/matugen
    '';

    meta = with super.lib; {
      description = "Wallpaper-based color scheme generator";
      homepage = "https://github.com/InioX/matugen";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  hyprshade = super.buildGoModule {
    pname = "hyprshade";
    version = "0.1.0";

    src = super.fetchFromGitHub {
      owner = "hyprland-community";
      repo = "hyprshade";
      rev = "v0.1.0";
      sha256 = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="; # Replace with actual hash
    };

    vendorSha256 = "sha256-CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC="; # Replace with actual hash

    meta = with super.lib; {
      description = "Shader manager for Hyprland";
      homepage = "https://github.com/hyprland-community/hyprshade";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  grub-hook = super.stdenv.mkDerivation {
    pname = "grub-hook";
    version = "git";

    src = super.fetchFromGitHub {
      owner = "nullobsi";
      repo = "grub-hook";
      rev = "main";
      sha256 = "sha256-DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD="; # Replace with actual hash
    };

    installPhase = ''
      mkdir -p $out/bin
      cp grub-hook.sh $out/bin/grub-hook
      chmod +x $out/bin/grub-hook
    '';

    meta = with super.lib; {
      description = "Hook script for GRUB updates";
      homepage = "https://github.com/nullobsi/grub-hook";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };
}

