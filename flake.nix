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
      # global configuration variables ---------------------------------------
      # whether to use laptop or PC configuration
      hardware = "laptop";

      # unfree packages that i explicitly use
      allowedUnfree = [
        "spotify-unwrapped"
        "reaper"
        "slack"
        "steam"
        "steam-original"
      ];

      system = "x86_64-linux";
      username = "argus";
      hostname = if hardware == "laptop" then "evil" else if hardware == "pc" then "mutant" else "evil";

      plymouth = let name = "rings"; in
        {
          themeName = name;
          themePath = "pack_4/${name}";
        };

      # use musl instead of glibc
      useMusl = false;
      # compile everything from source
      useFlags = false;
      # what optimizations to use (check https://github.com/fortuneteller2k/nixpkgs-f2k/blob/ca75dc2c9d41590ca29555cddfc86cf950432d5e/flake.nix#L237-L289)
      USE = [
        # "-O3"
        "-O2"
        "-pipe"
        "-ffloat-store"
        "-fexcess-precision=fast"
        "-ffast-math"
        "-fno-rounding-math"
        "-fno-signaling-nans"
        "-fno-math-errno"
        "-funsafe-math-optimizations"
        "-fassociative-math"
        "-freciprocal-math"
        "-ffinite-math-only"
        "-fno-signed-zeros"
        "-fno-trapping-math"
        "-frounding-math"
        "-fsingle-precision-constant"
        # not supported on clang 14 yet, and isn't ignored
        # "-fcx-limited-range"
        # "-fcx-fortran-rules"
      ];

      # optimizations --------------------------------------------------------
      # architechtures include:
      # x86-64-v2 x86-64-v3 x86-64-v4 tigerlake
      laptopArch = {
        gcc = {
          arch = "tigerlake";
          tune = "tigerlake";
        };
      };
      pcArch = {
        gcc = {
          arch = "znver1";
          tune = "znver1";
        };
      };
      arch =
        if hardware == "laptop" then laptopArch
        else if hardware == "pc" then pcArch else { };

      optimizedStdenv = pkgsToOptimize:
        let
          mkStdenv = march: stdenv:
            # adds -march flag to the global USE flags and creates stdenv
            pkgsToOptimize.withCFlags
              (USE ++ [ "-march=${march}" "-mtune=${march}" ])
              stdenv;

          # same thing but use -march=native
          mkNativeStdenv = stdenv:
            pkgsToOptimize.impureUseNativeOptimizations
              (pkgsToOptimize.stdenvAdapters.withCFlags USE stdenv);

          optimizedStdenv = mkStdenv arch.gcc.arch pkgsToOptimize.stdenv;
          optimizedClangStdenv =
            mkStdenv arch.gcc.arch pkgsToOptimize.llvmPackages_14.stdenv;

          optimizedNativeClangStdenv =
            pkgs.lib.warn "using native optimizations, \
                forfeiting reproducibility"
              mkNativeStdenv
              pkgsToOptimize.llvmPackages_14.stdenv;
          optimizedNativeStdenv =
            pkgs.lib.warn "using native optimizations, \
                forfeiting reproducibility"
              mkNativeStdenv
              pkgsToOptimize.stdenv;
        in
        optimizedStdenv;

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

          overlays = [
            (self: super: {
              plymouth-themes-package = import ./packages/plymouth-themes.nix ({
                pkgs = super;
              } // plymouth);
            })
          ] ++ (if useFlags then [
            (self: super: {
              stdenv = optimizedStdenv super;
            })
          ] else [ ]);
        };

      pkgs = import nixpkgs pkgsInputs;
      unstable = import nixpkgs-unstable pkgsInputs;

      firefox-addons = (import "${rycee-expressions}" { inherit pkgs; }).firefox-addons;

      homeDirectory = "/home/${username}";
    in
    {
      nixosConfigurations = {
        ${hostname} = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          inherit system;
          specialArgs = inputs // {
            inherit hardware unstable plymouth useMusl useFlags hostname username;
          };
          modules = [
            {
              imports = [ ./system/configuration.nix ];
            }
          ];
        };
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit system username homeDirectory;
        configuration = { pkgs, ... }: {
          imports = [ ./user/primary audio-plugins.homeManagerModule ];
        };
        stateVersion = "22.05";
        extraSpecialArgs = inputs // {
          inherit hardware unstable homeDirectory firefox-addons useMusl useFlags username;
          mpkgs = audio-plugins.mpkgs;
        };
      };

      createNixosConfiguration = settings: {
        ${settings.hostname} = settings.pkgs.lib.nixosSystem {
          inherit (settings) pkgs system;
          specialArgs = inputs // settings.extraSpecialArgs;
        };
      };

      createHomeConfigurations = settings: rec {
        inherit (settings) pkgs system username;
        homeDirectory = "/home/${settings.username}";
        configuration = { pkgs, ... }: {
          imports = [ ./user/primary ] ++ settings.additionalModules;
        };
        stateVersion = "22.05";
        extraSpecialArgs = inputs // {
          inherit homeDirectory firefox-addons;
        } // settings.extraExtraSpecialArgs;
      };

      devShell.${system} = pkgs.mkShell { };
    };
}
