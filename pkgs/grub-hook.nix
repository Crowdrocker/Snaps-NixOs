{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  pname = "grub-hook";
  version = "git";

  src = fetchFromGitHub {
    owner = "nullobsi";
    repo = "grub-hook";
    rev = "main";
    sha256 = lib.fakeSha256; # Replace after build
  };

  installPhase = ''
    mkdir -p $out/bin
    cp grub-hook.sh $out/bin/grub-hook
    chmod +x $out/bin/grub-hook
  '';

  meta = with lib; {
    description = "Hook script for GRUB updates";
    homepage = "https://github.com/nullobsi/grub-hook";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

