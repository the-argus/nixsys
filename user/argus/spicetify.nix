{ pkgs, lib, spicetify-nix, ... }:
{
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify-unwrapped"
  ];
  
  # import the flake's module
  imports = [ spicetify-nix.homeManagerModule ];
  
  # configure spicetify :)
  programs.spicetify =
    let
      av = pkgs.fetchFromGitHub {
        owner = "amanharwara";
        repo = "spicetify-autoVolume";
        rev = "d7f7962724b567a8409ef2898602f2c57abddf5a";
        sha256 = "1pnya2j336f847h3vgiprdys4pl0i61ivbii1wyb7yx3wscq7ass";
      };
    in
    {
      enable = true;
      theme = "Dribbblish";
      colorScheme = "horizon";
      enabledCustomApps = [ "reddit" ];
      enabledExtensions = [ "newRelease.js" "autoVolume.js" ];
      thirdParyExtensions = {
        "autoVolume.js" = "${av}/autoVolume.js";
      };
    };
}
