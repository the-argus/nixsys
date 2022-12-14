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
      sha256 = "03blfpwpp8x8f9krrja0b6qsgrmp4djyz6g5205np5593wib5a1s";
      rev = "e09da5077f110d27a810066bd605365d840cd884";
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
