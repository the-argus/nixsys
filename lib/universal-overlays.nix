# overlays which are applied to every single package set
[
  (_: super: rec {
    myPackages = super.callPackage ../packages {original-kitty = super.kitty;};
    # kitty = myPackages.kitty;
    # this avoids conflicts with the version of xdg-desktop-portal gtk
    # that gets installed when you enable gnome
    xdg-desktop-portal-gtk = super.xdg-desktop-portal-gtk.override {
      buildPortalsInGnome = false;
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
    qtile-unwrapped = super.qtile-unwrapped.overrideAttrs (oa: {
      makeWrapperArgs = oa.makeWrapperArgs ++ ["--set PYTHONDONTWRITEBYTECODE \"yes\""];
    });

    # labwc = super.callPackage ../packages/labwc/wrapper.nix {labwc-original = super.labwc;};
    # labwc-unwrapped = super.labwc;
  })
]
