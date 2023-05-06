{
  lib,
  settings,
}: let
  inherit (settings.optimization) useMusl useFlags useClang;
  inherit (settings) allowedUnfree system name;
in {
  config =
    # always needs allowBroken and allowedUnfree
    {
      inherit (settings) allowBroken;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowedUnfree;
    }
    # replace the stdenv if a setting that needs it is set
    // (
      lib.attrsets.optionalAttrs (useFlags || useClang)
      {
        replaceStdenv = {
          pkgs,
          unstable,
          remotebuild,
          localbuild,
        }: let
          pkgSets = {inherit unstable remotebuild localbuild pkgs;};
        in
          import ./make-stdenv-from-pkgs.nix {
            pkgs = pkgSets.${settings.name};
            inherit settings;
          };
      }
    );

  localSystem =
    # always needs system
    {inherit system;}
    # add libc = musl if set
    // (lib.attrsets.optionalAttrs useMusl {
      libc = "musl";
      config = "x86_64-unknown-linux-musl";
    })
    # add gcc arch and tune flags if using
    // (
      lib.attrsets.optionalAttrs useFlags {
        gcc = {
          arch = settings.optimization.arch;
          tune = settings.optimization.arch;
        };
      }
    );

  overlays =
    settings.additionalOverlays
    ++ (import ./universal-overlays.nix);
}
