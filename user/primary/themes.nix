{ pkgs, ... }:
# if settings had a theme, it gets added to pkgs set in flake.nix
let
  default = (import ../../modules/color/themes.nix).defaultTheme;
in
(if builtins.hasAttr "theme" pkgs then
  (
    if builtins.typeOf pkgs.theme == "string" then
      (import ../../modules/color/themes.nix).${pkgs.theme}
    else if builtins.typeOf pkgs.theme == "set" then
      pkgs.theme
    else
      default
  )
else
  default)
