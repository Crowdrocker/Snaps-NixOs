{ stdenv, fetchurl, lib }:

stdenv.mkDerivation {
  pname = "matugen-bin";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/InioX/matugen/releases/latest/download/matugen";
    sha256 = lib.fakeSha256; # Replace after build
  };

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/matugen
    chmod +x $out/bin/matugen
  '';

  meta = with lib; {
    description = "Wallpaper-based color scheme generator";
    homepage = "https://github.com/InioX/matugen";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

