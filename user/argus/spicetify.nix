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
    {
      # use unstable channel for these because old versions tend to inject improperly
      # spotifyPackage = unstable.spotify // { version = unstable.spotify-unwrapped.version; };
      spotifyPackage = unstable.spotify-unwrapped;
      # spicetifyPackage = unstable.spicetify-cli;
      spicetifyPackage = pkgs.spicetify-cli.overrideAttrs (oa: rec {
        pname = "spicetify-cli";
        version = "2.9.9";
        src = pkgs.fetchgit {
          url = "https://github.com/spicetify/${pname}";
          rev = "v${version}";
          sha256 = "1a6lqp6md9adxjxj4xpxj0j1b60yv3rpjshs91qx3q7blpsi3z4z";
        };
      });
      enable = true;
      theme = spicetify-nix.pkgs.themes.Dribbblish;
      colorScheme = "custom";

      customColorScheme =
        let colors = import ./color.nix { }; in
        with colors;
        {
          text = cyan;
          subtext = cyan;# "F0F0F0";
          sidebar-text = white;
          main = bg;
          sidebar = altbg;
          player = bg;
          card = bg;
          shadow = altbg2;
          selected-row = altfg;# "797979";
          button = blue;
          button-active = blue;
          button-disabled = altbg3;
          tab-active = cyan;
          notification = green;# "1db954";
          notification-error = red;
          misc = black;
        };

      enabledCustomApps = with spicetify-nix.pkgs.apps; [
        new-releases
        lyrics-plus
        localFiles
      ];
      enabledExtensions = with spicetify-nix.pkgs.extensions; [
        # "playlistIcons.js" # only needed if not using dribbblish
        "fullAlbumDate.js"
        "listPlaylistsWithSong.js"
        "playlistIntersection.js"
        "showQueueDuration.js"
        "featureShuffle.js"
        "playNext.js"
        "keyboardShortcut.js"
        "lastfm.js"
        "genre.js"
        "historyShortcut.js"
        "hidePodcasts.js"
        "fullAppDisplay.js"
        "shuffle+.js"
      ];
    };
}
