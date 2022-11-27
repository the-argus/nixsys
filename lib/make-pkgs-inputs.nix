{
  lib,
  settings,
}: let
  inherit (settings.optimization) useMusl useFlags;
  inherit (settings) allowedUnfree system plymouth name;
in {
  config =
    {
      inherit (settings) allowBroken;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowedUnfree;
    }
    // (
      if
        settings.optimization.useFlags
        or settings.optimization.useClang
      then {
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
      else {}
    );
  localSystem =
    {
      inherit system;
    }
    // (
      if useMusl
      then {
        libc = "musl";
        config = "x86_64-unknown-linux-musl";
      }
      else {}
    )
    // (
      if useFlags
      then {
        gcc = {
          arch = settings.optimization.arch;
          tune = settings.optimization.arch;
        };
      }
      else {}
    );

  overlays =
    settings.additionalOverlays
    ++ [
      (_: super: {
        plymouth-themes-package = import ../packages/plymouth-themes.nix ({
            pkgs = super;
          }
          // settings.plymouth);
        gnome =
          super.gnome
          // {
            seahorse = super.seahorse.overrideAttrs (_: {
              postInstall = ''
                rm $out/share/applications/org.gnome.seahorse.Application.desktop
              '';
            });
          };
      })
    ];
  # ++ (
  #   if (builtins.hasAttr "theme" settings)
  #   then [
  #     (self: super: {
  #       flakeTheme = settings.theme;
  #     })
  #   ]
  #   else []
  # );
}
