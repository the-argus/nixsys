{callPackage, ...}: {
  darkg = callPackage ./darkg.nix {};
  kanagawa = callPackage ./kanagawa.nix {};
  marwaita = callPackage ./marwaita.nix {};
  nord = callPackage ./nord.nix {};
  cursor-themes = callPackage ./cursor-themes.nix {};
  material-black-frost = callPackage ./material-black-frost.nix {};

  icons = callPackage ./icons {};
}
