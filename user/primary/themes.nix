{ pkgs, ... }:
# if settings had a theme, it gets added to pkgs set in flake.nix
let
  themes = (pkgs.callPackage ../../modules/color/themes.nix { });
  default = themes.defaultTheme;
in
(if builtins.hasAttr "flakeTheme" pkgs then
  (
    if builtins.typeOf pkgs.flakeTheme == "string" then
      themes.${pkgs.flakeTheme}
    else if builtins.typeOf pkgs.theme == "set" then
      pkgs.flakeTheme
    else
      default
  )
else
  default)
