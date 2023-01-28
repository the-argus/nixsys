{
  lib,
  settings,
}: let
  inherit (settings.optimization) useMusl useFlags;
  inherit (settings) allowedUnfree system name;
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
        myPackages = super.callPackage ../packages {};
        # this avoids conflicts with the version of xdg-desktop-portal gtk
        # that gets installed when you enable gnome
        xdg-desktop-portal-gtk = super.xdg-desktop-portal-gtk.override {
          buildPortalsInGnome = false;
        };
        qtile = super.stdenv.mkDerivation {
          name = "qtile-wrapped";
          src = super.qtile;
          nativeBuildInputs = [super.buildPackages.makeWrapper];
          dontUnpack = true;
          installPhase = ''
            mkdir -p $out/bin
            for binary in $src/bin/*; do
              ln -sf $binary $out/bin/$(${super.coreutils-full}/bin/basename $binary)
            done
            wrapProgram --set PYTHONDONTWRITEBYTECODE "yes" $out/qtile
          '';
        };
        gnome =
          super.gnome
          // {
            seahorse = super.gnome.seahorse.overrideAttrs (_: {
              postInstall = ''
                rm $out/share/applications/org.gnome.seahorse.Application.desktop
              '';
            });
          };
      })
    ];
}
