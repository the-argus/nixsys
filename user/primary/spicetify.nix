{
  pkgs,
  unstable,
  lib,
  spicetify-nix,
  config,
  ...
}: let
  spicePkgs = spicetify-nix.pkgSets.${pkgs.system};
in {
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify-unwrapped"
    ];

  # import the flake's module
  imports = [spicetify-nix.homeManagerModule];

  # configure spicetify :)
  programs.spicetify = {
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
    theme = spicePkgs.themes.Dribbblish;
    colorScheme = "custom";

    customColorScheme = let
      center = with config.banner.palette; {
        text = hialt2;
        bg = base00;
      };
      outer = with config.banner.palette; {
        text = hialt2;
        bg = base02;
      };
    in
      with config.banner.palette; {
        text = center.text;
        subtext = center.text; # "F0F0F0";
        sidebar-text = outer.text; # use altfg if going for contrast on dribbs
        main = center.bg;
        sidebar = outer.bg; # and altbg here
        player = base00;
        card = base00;
        shadow = base02;
        selected-row = base02; # "797979";
        button = highlight;
        button-active = highlight;
        button-disabled = base03;
        tab-active = highlight;
        notification = base01; # "1db954";
        notification-error = urgent;
        misc = base04;
      };

    enabledCustomApps = with spicePkgs.apps; [
      new-releases
      lyrics-plus
      localFiles
      marketplace
    ];
    enabledExtensions = with spicePkgs.extensions; [
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
