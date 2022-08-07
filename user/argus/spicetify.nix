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
      # av = pkgs.fetchFromGitHub {
      #   owner = "amanharwara";
      #   repo = "spicetify-autoVolume";
      #   rev = "d7f7962724b567a8409ef2898602f2c57abddf5a";
      #   sha256 = "1pnya2j336f847h3vgiprdys4pl0i61ivbii1wyb7yx3wscq7ass";
      # };

      hidePodcasts = pkgs.fetchgit {
        url = "https://github.com/theRealPadster/spicetify-hide-podcasts";
        rev = "cfda4ce0c3397b0ec38a971af4ff06daba71964d";
        sha256 = "146bz9v94dk699bshbc21yq4y5yc38lq2kkv7w3sjk4x510i0v3q";
      };

      history = pkgs.fetchgit {
        url = "https://github.com/einzigartigerName/spicetify-history";
        rev = "577e34f364127f18d917d2fe2e8c8f2a1af9f6ae";
        sha256 = "0fv5fb6k9zc446a1lznhmd68m47sil5pqabv4dmrqk6cvfhba49r";
      };

      genre = pkgs.fetchgit {
        url = "https://github.com/Shinyhero36/Spicetify-Genre";
        rev = "4ab66852825525869ef5ced5747e7e84ddd0a8bb";
        sha256 = "09b69dcknqvj9nc5ayfqcdg63vc5yshn0wa23gyachzicwalq30m";
      };

      lastfm = pkgs.fetchgit {
        url = "https://github.com/LucasBares/spicetify-last-fm";
        rev = "0f905b49362ea810b6247ac1950a2951dd35632e";
        sha256 = "1b0l2g5cyjj1nclw1ff7as9q94606mkq1k8l2s34zzdsx3m2zv81";
      };

      localFiles = pkgs.fetchgit {
        url = "https://github.com/hroland/spicetify-show-local-files/";
        rev = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
        sha256 = "01gy16b69glqcalz1wm8kr5wsh94i419qx4nfmsavm4rcvcr3qlx";
      };
    in
    {
      # use unstable channel for these because old versions tend to inject improperly
      # spotifyPackage = unstable.spotify // { version = unstable.spotify-unwrapped.version; };
      spotifyPackage = unstable.spotify-unwrapped;
      # spicetifyPackage = unstable.spicetify-cli;
      spicetifyPackage = import ../../packages/spicetify-cli-2.9.9.nix { inherit pkgs; };
      enable = true;
      theme = "Dribbblish";
      colorScheme = "rosepine";
      enabledCustomApps = [
        # "new-releases"
        # {
        #     name = "localFiles";
        #     src = localFiles;
        #     appendName = false;
        # }
      ];
      enabledExtensions = [
        {
          src = hidePodcasts;
          filename = "hidePodcasts.js";
        }
        {
          src = history;
          filename = "historyShortcut.js";
        }
        {
          src = genre;
          filename = "genre.js";
        }
        {
          src = "${lastfm}/src";
          filename = "lastfm.js";
        }
        "dribbblish.js"
        "fullAppDisplay.js"
        "shuffle+.js"
      ];
    };
}
