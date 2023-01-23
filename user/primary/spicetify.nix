{
  pkgs,
  spicetify-nix,
  config,
  ...
}: let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in {
  # import the flake's module
  imports = [spicetify-nix.homeManagerModule];

  # configure spicetify :)
  programs.spicetify = {
    spotifyPackage = pkgs.spotify-unwrapped;
    spicetifyPackage = pkgs.spicetify-cli;
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
      # "playlistIcons" # only needed if not using dribbblish
      fullAlbumDate
      listPlaylistsWithSong
      playlistIntersection
      showQueueDuration
      featureShuffle
      playNext
      keyboardShortcut
      lastfm
      genre
      historyShortcut
      hidePodcasts
      fullAppDisplay
      shuffle
    ];
  };
}
