{
  description = "the-argus nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-22.05";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs-unstable.url = "github:the-argus/nixpkgs?ref=fix/chromium-extension-path";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      # home manager use out nixpkgs and not its own
      inputs.nixpkgs.follows = "nixpkgs";
    };

    audio-plugins = {
      url = "github:the-argus/audio-plugins-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    webcord = {
      url = "github:fufexan/webcord-flake";
    };

    # nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    rycee-expressions = {
      url = "gitlab:rycee/nur-expressions";
      flake = false;
    };

    chrome-extensions = {
      url = "github:the-argus/chrome-extensions-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
    };

    # non-nix imports (need fast updates):
    nvim-config = {
      url = "github:the-argus/nvim-config";
      flake = false;
    };

    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , webcord
    , rycee-expressions
      # , nur
    , audio-plugins
    , chrome-extensions
    , spicetify-nix
    , nvim-config
    , arkenfox-userjs
    , ...
    }@inputs:
    let
      # global configuration variables
      # whether to use laptop or PC configuration
      hardware = "laptop";
      # use musl instead of glibc
      useMusl = false;
      # compile everything from source
      useFlags = false;

      allowedUnfree = [
        "spotify-unwrapped"
        "reaper"
        "slack"
      ];

      system = "x86_64-linux";
      username = "argus";
      homeDirectory = "/home/${username}";

      laptopArch = {
        gcc = {
          arch = "tigerlake";
          tune = "tigerlake";
        };
      };
      pcArch = {
        gcc = {
          arch = "x86_64";
          tune = "x86_64";
        };
      };
      arch =
        if hardware == "laptop" then laptopArch
        else if hardware == "pc" then pcArch else { };

      pkgsInputs =
        {
          config = {
            allowBroken = true;
            allowUnfreePredicate =
              pkg: builtins.elem (pkgs.lib.getName pkg) allowedUnfree;
          };
          localSystem = {
            inherit system;
          } // (if useMusl then {
            libc = "musl";
            config = "x86_64-unknown-linux-musl";
          } else { })
          // (if useFlags then arch else { });
        };

      pkgs = import nixpkgs pkgsInputs;
      unstable = import nixpkgs-unstable pkgsInputs;

      firefox-addons = (import "${rycee-expressions}" { inherit pkgs; }).firefox-addons;

      plymouth = let name = "rings"; in
        {
          themeName = name;
          themePath = "pack_4/${name}";
        };

      overlays = [
        (self: super: {
          # better discord performance, if its not installed via flatpak
          discord = super.discord.override {
            commandLineArgs =
              "--no-sandbox --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization";
          };
        })

        (self: super: {
          plymouth-themes-package = import ./packages/plymouth-themes.nix ({
            inherit pkgs;
          } // plymouth);
        })
      ];
    in
    {
      nixosConfigurations = {
        # hostname (evil)
        evil = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs // {
            inherit hardware unstable plymouth useMusl useFlags;
          };
          modules = [
            {
              nixpkgs.overlays = overlays;
              imports = [ ./system/configuration.nix ];
            }
          ];
        };
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit system username homeDirectory;
        configuration = { pkgs, ... }: {
          imports = [ ./user/${username} audio-plugins.homeManagerModule ];
          nixpkgs.overlays = overlays;
        };
        stateVersion = "22.05";
        extraSpecialArgs = inputs // {
          inherit hardware unstable homeDirectory firefox-addons useMusl useFlags;
          mpkgs = audio-plugins.mpkgs;
        };
      };

      devShell.${system} = pkgs.mkShell { };
    };
}
