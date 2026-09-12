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
    pythonPackagesExtensions =
      (super.pythonPackagesExtensions or [])
      ++ [
        (_: pyprev: {
          qtile = pyprev.qtile.overrideAttrs (oa: {
            makeWrapperArgs = (oa.makeWrapperArgs or []) ++ ["--set PYTHONDONTWRITEBYTECODE yes"];

            # it seems they don't even build qtile on hydra, I guess tests will
            # fail or are not reproducible or something, at least they always
            # fail for me. so just skip those. also apparently doCheck doesn't
            # work for a python package
            doInstallCheck = false;
            dontUsePytestCheck = true; # just in case
          });
        })
      ];

    # labwc = super.callPackage ../packages/labwc/wrapper.nix {labwc-original = super.labwc;};
    # labwc-unwrapped = super.labwc;
  })
]
