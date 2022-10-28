{
  pkgs,
  picom,
  awesome,
  font-icons,
  ...
}: {
  picom = import ./picom.nix {
    inherit pkgs;
    inherit picom;
  };
  awesome = import ./awesome.nix {
    inherit pkgs;
    inherit awesome;
  };
  font-icons = import ./font-icons.nix {
    inherit pkgs;
    inherit font-icons;
  };
}
