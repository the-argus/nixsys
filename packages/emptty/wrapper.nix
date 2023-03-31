{
  stdenvNoCC,
  makeWrapper,
  emptty-unwrapped,
  additionalPathEntries ? [],
  util-linuxMinimal,
  getent,
  dbus,
  xorg,
  lib,
  needXServer ? true,
  ...
}: let
  runtimePath = lib.makeBinPath ([
      getent
      util-linuxMinimal
      dbus
      xorg.xauth
    ]
    ++ (lib.lists.optionals needXServer [
      xorg.xorgserver
    ])
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
