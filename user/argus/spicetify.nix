{ pkgs, unstable, lib, spicetify-nix, ... }:
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
      officialThemesOLD = pkgs.fetchgit {
        url = "https://github.com/spicetify/spicetify-themes";
        rev = "c2751b48ff9693867193fe65695a585e3c2e2133";
        sha256 = "0rbqaxvyfz2vvv3iqik5rpsa3aics5a7232167rmyvv54m475agk";
      };
    in
  {
    # use unstable channel for these because old versions tend to inject improperly
    # spotifyPackage = unstable.spotify // { version = unstable.spotify-unwrapped.version; };
    spotifyPackage = unstable.spotify-unwrapped;
    # spicetifyPackage = unstable.spicetify-cli;
    spicetifyPackage = import ../../packages/spicetify-cli-2.9.9.nix { inherit pkgs; };
    enable = true;
    theme = {
      name = "Dribbblish";
      src = officialThemesOLD;
      requiredExtensions = [
        {
          filename = "dribbblish.js";
          src = "${officialThemesOLD}/Dribbblish";
        }
      ];
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)32,";
        "xpui.js_repl_8008" = ",$\{1}56,";
      };
      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
      appendName = true;
      sidebarConfig = true;
    };
    colorScheme = "custom";

    customColorScheme = {
      text = "ebbcba";
      subtext = "F0F0F0";
      sidebar-text = "e0def4";
      main = "191724";
      sidebar = "2a2837";
      player = "191724";
      card = "191724";
      shadow = "1f1d2e";
      selected-row = "797979";
      button = "31748f";
      button-active = "31748f";
      button-disabled = "555169";
      tab-active = "ebbcba";
      notification = "1db954";
      notification-error = "eb6f92";
      misc = "6e6a86";
    };

    enabledCustomApps = with spicetify-nix.pkgs.apps; [
      # new-releases
      # localFiles
    ];
    enabledExtensions = with spicetify-nix.pkgs.extensions; [
      "playlistIcons.js"
      "lastfm.js"
      "genre.js"
      "historyShortcut.js"
      "hidePodcasts.js"
      "fullAppDisplay.js"
      "shuffle+.js"
    ];
  };
}
