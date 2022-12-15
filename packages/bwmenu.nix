{
  stdenv,
  keyutils,
  jq,
  bitwarden-cli,
  rofi,
  xclip,
  gnupg,
  coreutils-full,
  buildPackages,
  fetchgit,
  lib,
  ...
}: let
  runtimePath = lib.strings.makeBinPath [
    jq
    bitwarden-cli
    rofi
    xclip
    keyutils
    gnupg
  ];
in
  stdenv.mkDerivation rec {
    name = "bw-rofi";
    src = fetchgit {
      url = "https://github.com/the-argus/bitwarden-rofi";
      sha256 = "1zfh1kn1c2fbnz3gqxdrwv5c5xkw5afibdyb4b0nfk40adwqslsp";
      rev = "88e6bef0d88949289151870f42802dc2e90e0068";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/lib
      substitute bwmenu $out/bin/bwmenu --replace "source \"\$DIR/lib-bwmenu\"" "source \"$out/lib/lib-bwmenu\""
      ${coreutils-full}/bin/chmod +x $out/bin/bwmenu
      cp lib-bwmenu $out/lib

      wrapProgram "$out/bin/bwmenu" \
          --prefix PATH : ${runtimePath}
    '';
    nativeBuildInputs = [buildPackages.makeWrapper];
  }
