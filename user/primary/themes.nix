{ pkgs, ... }:
# if settings had a theme, it gets added to pkgs set in flake.nix
(if builtins.hasAttr "theme" pkgs then
  pkgs.theme
else
  (import ../../modules/color/themes.nix).defaultTheme)
