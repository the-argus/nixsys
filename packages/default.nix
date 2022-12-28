{
  pkgs,
  unstable,
  picom,
  font-icons,
  ...
}: {
  picom = import ./picom.nix {
    inherit pkgs;
    inherit picom;
  };
  awesome = import ./awesome.nix {
    inherit unstable;
  };
  font-icons = import ./font-icons.nix {
    inherit pkgs;
    inherit font-icons;
  };
}
