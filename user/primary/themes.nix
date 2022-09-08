{ pkgs, ... }:
# if settings had a theme, it gets added to pkgs set in flake.nix
let
  themes = (pkgs.callPackage ../../modules/color/themes.nix { });
  default = themes.defaultTheme;
in
(if builtins.hasAttr "theme" pkgs then
  (
    if builtins.typeOf pkgs.theme == "string" then
      themes.${pkgs.theme}
    else if builtins.typeOf pkgs.theme == "set" then
      pkgs.theme
    else
      default
  )
else
  default)
