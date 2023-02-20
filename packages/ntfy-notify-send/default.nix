{ stdenvNoCC
, python3Minimal
, ntfy-sh
, libnotify
, buildPackages
, writeShellScriptBin
, lib
, ...
}:
let
  notify_send = stdenvNoCC.mkDerivation {
    name = "ntfy_script";
    src = ./.;

    buildInputs = [ python3Minimal ntfy-sh libnotify ];

    nativeBuildInputs = [
      buildPackages.makeWrapper
    ];

    dontBuild = true;
    postPatch = ''
      sed -i "s|ntfy_command = \[\"ntfy\", \"subscribe\"|ntfy_command = \[\"${ntfy-sh}/bin/ntfy\", \"subscribe\"|g" ntfy-notify-send.py
    '';
    installPhase =
      let
        path = lib.makeBinPath [ libnotify ];
      in
      ''
        mkdir -p $out/bin
        cp ntfy-notify-send.py $out/bin/single_notification_reciever
        wrapProgram $out/bin/single_notification_reciever \
            --prefix PATH : ${path}
      '';
  };
in
writeShellScriptBin "ntfy-notify-send" ''
  for url in $(cat $HOME/.config/ntfy_subscriptions); do
      ${notify_send}/bin/single_notification_reciever $url &
  done
''
