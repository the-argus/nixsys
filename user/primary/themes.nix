{ settings, ... }:
(if builtins.hasAttr "theme" settings then
  settings.theme
else
  (import ../../modules/color/themes.nix).defaultTheme)
