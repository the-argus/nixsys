{
  stdenvNoCC,
  python3Minimal,
  ntfy-sh,
  libnotify,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "ntfy-notify-send";
  src = ./.;

  buildInputs = [python3Minimal ntfy-sh libnotify];

  dontBuild = true;
  postPatch = ''
    sed -i "s|ntfy_command = \[\"ntfy\", \"subscribe\"|ntfy_command = \[\"${ntfy-sh}/bin/ntfy\", \"subscribe\"|g" ntfy-notify-send.py
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp ntfy-notify-send.py $out/bin/ntfy-notify-send
  '';
}
