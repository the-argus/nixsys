# overlays which are applied to every single package set
[
  (_: super: rec {
    myPackages = super.callPackage ../packages {original-kitty = super.kitty;};
    # kitty = myPackages.kitty;
    gnome =
      super.gnome
      // {
        seahorse = super.gnome.seahorse.overrideAttrs (_: {
          postInstall = ''
            rm $out/share/applications/org.gnome.seahorse.Application.desktop
          '';
        });
      };
    qtile-unwrapped = super.qtile-unwrapped.overrideAttrs (oa: {
      makeWrapperArgs = (oa.makeWrapperArgs or []) ++ ["--set PYTHONDONTWRITEBYTECODE \"yes\""];
    });

    # labwc = super.callPackage ../packages/labwc/wrapper.nix {labwc-original = super.labwc;};
    # labwc-unwrapped = super.labwc;
  })
]
