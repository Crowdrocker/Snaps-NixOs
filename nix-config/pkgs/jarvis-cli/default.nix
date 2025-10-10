{ lib, stdenv, bash, coreutils, alsaUtils, espeak-ng }:

stdenv.mkDerivation rec {
  pname = "jarvis-cli";
  version = "1.0.0";

  src = ./.;
  
  buildInputs = [ bash coreutils alsaUtils espeak-ng ];

  installPhase = ''
    mkdir -p $out/bin
    cp jarvis-cli.sh $out/bin/jarvis
    chmod +x $out/bin/jarvis
  '';

  meta = with lib; {
    description = "J.A.R.V.I.S. CLI assistant for WehttamSnaps";
    homepage = "https://github.com/Crowdrocker/Snaps-NixOS";
    license = licenses.mit;
    maintainers = [ "WehttamSnaps" ];
    platforms = platforms.linux;
  };
}