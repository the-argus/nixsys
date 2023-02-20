{
  stdenvNoCC,
  python3Minimal,
  ntfy-sh,
  libnotify,
  buildPackages,
  lib,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "ntfy-notify-send";
  src = ./.;

  buildInputs = [python3Minimal ntfy-sh libnotify];

  nativeBuildInputs = [
    buildPackages.makeWrapper
  ];

  dontBuild = true;
  postPatch = ''
    sed -i "s|ntfy_command = \[\"ntfy\", \"subscribe\"|ntfy_command = \[\"${ntfy-sh}/bin/ntfy\", \"subscribe\"|g" ntfy-notify-send.py
  '';
  installPhase = let
    path = lib.makeBinPath [libnotify];
  in ''
    mkdir -p $out/bin
    cp ntfy-notify-send.py $out/bin/ntfy-notify-send
    wrapProgram $out/bin/ntfy-notify-send \
        --prefix PATH : ${path}
  '';
}
