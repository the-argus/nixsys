{
  stdenvNoCC,
  makeWrapper,
  emptty-unwrapped,
  additionalPathEntries ? [],
  util-linuxMinimal,
  getent,
  lib,
  ...
}: let
  runtimePath = lib.makeBinPath ([getent] ++ additionalPathEntries);
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
