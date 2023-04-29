{
  jetbrains,
  stdenvNoCC,
  makeWrapper,
  curl,
  libpulseaudio,
  systemd,
  alsa-lib,
  flite,
  libXxf86vm,
  lib,
  ...
}: let
  envLibPath = lib.makeLibraryPath [
    curl
    libpulseaudio
    systemd
    alsa-lib # needed for narrator
    flite # needed for narrator
    libXxf86vm # needed only for versions <1.13
  ];
in
  stdenvNoCC.mkDerivation rec {
    pname = "IDEA-old-minecraft";
    src = jetbrains.idea-community;
    version = src.version;
    dontUnpack = true;
    dontBuild = true;

    buildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/bin
      ln -sf $src/bin/idea-community $out/bin/idea-community
    '';

    postFixup = ''
      wrapProgram $out/bin/idea-community \
        --prefix LD_LIBRARY_PATH : ${envLibPath}
    '';
  }
