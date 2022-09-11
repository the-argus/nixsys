{pkgs, ...}: {
  darkg = pkgs.callPackage ./darkg.nix {};
  kanagawa = pkgs.callPackage ./kanagawa.nix {};
  marwaita = pkgs.callPackage ./marwaita.nix {};
  nord = pkgs.callPackage ./nord.nix {};
  rose-pine = pkgs.callPackage ./rose-pine.nix {};
  cursorThemes = pkgs.callPackage ./cursor-themes.nix {};
  materialBlackFrost = pkgs.callPackage ./material-black-frost.nix {};
}
