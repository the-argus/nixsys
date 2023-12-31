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
    # HACK: i couldn't find where in my config i was referencing exa, so i just
    # globally replaced it with eza
    exa = super.eza;
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
