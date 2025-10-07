{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule {
  pname = "hyprshade";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprshade";
    rev = "v0.1.0";
    sha256 = lib.fakeSha256; # Replace after build
  };

  vendorSha256 = lib.fakeSha256; # Replace after build

  meta = with lib; {
    description = "Shader manager for Hyprland";
    homepage = "https://github.com/hyprland-community/hyprshade";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

