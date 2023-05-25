{
  stdenvNoCC,
  makeWrapper,
  emptty-unwrapped,
  additionalPathEntries ? [],
  dbus,
  lib,
  systemPath ? null,
  ...
}: let
  runtimePath = lib.makeBinPath ([
      dbus
    ]
    ++ (lib.lists.optionals (systemPath != null) [systemPath])
    ++ additionalPathEntries);
in
  stdenvNoCC.mkDerivation {
    name = "empty-wrapper";
    src = emptty-unwrapped;

    buildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out
    '';

    postFixup = ''
      wrapProgram \
          $out/bin/emptty \
          --prefix PATH ":" ${runtimePath}
    '';
  }
