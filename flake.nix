{
  description = "the-argus nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-remotebuild.url = "github:nixos/nixpkgs?ref=nixos-22.05";
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

    gtk-nix.url = "github:the-argus/gtk-nix";

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

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-remotebuild,
    home-manager,
    webcord,
    rycee-expressions,
    # , nur
    audio-plugins,
    chrome-extensions,
    spicetify-nix,
    gtk-nix,
    nvim-config,
    arkenfox-userjs,
    ...
  } @ inputs: let
    # global configuration variables ---------------------------------------
    defaultGlobalSettings = rec {
      system = "x86_64-linux";
      username = "argus";
      hostname = "evil";
      # unfree packages that i explicitly use
      allowedUnfree = [
        "spotify-unwrapped"
        "reaper"
        "slack"
      ];
      allowBroken = false;
      plymouth = let
        name = "rings";
      in {
        themeName = name;
        themePath = "pack_4/${name}";
      };
      terminal = "kitty";
      extraExtraSpecialArgs = {mpkgs = audio-plugins.mpkgSets.${system};};
      extraSpecialArgs = {};
      additionalModules = [audio-plugins.homeManagerModule];
      packageSelections = {
        # packages to override with their unstable versions
        # all of these are things that i might want to move
        # to remotebuild at some point (so theyre FOSS)
        unstable = [
          "alejandra"
          "wl-color-picker"
          "heroic"
          "solo2-cli"
          "ani-cli"
          "ungoogled-chromium"
          "firefox"
          "linuxPackages_latest"
          "linuxPackages_zen"
          "linuxPackages_xanmod_latest"
          "OVMFFull"
          "neovim"
          "kitty"
        ];
        # packages to build remotely
        remotebuild = [
          # "linuxPackages_latest"
          # "linuxPackages_zen"
          # "linuxPackages_xanmod_latest"
          # "qtile"
        ];
      };
      additionalUserPackages = [
        #"steam"
      ]; # will be evaluated later
      hardwareConfiguration = [./system/hardware];
      usesWireless = true; # install and autostart nm-applet
      usesBluetooth = true; # install and autostart blueman applet
      usesMouse = false; # enables xmousepasteblock for middle click
      hasBattery = true; # battery widget in tiling WMs
      optimization = {
        arch = "tigerlake";
        # use musl instead of glibc
        useMusl = false;
        # compile everything from source
        useFlags = false;

        useNative = false;
        useClang = false;
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
      };
      nix = {}; # dont edit nix settings
      additionalSystemPackages = [];
      remotebuildOverrides = {};
      unstableOverrides = {};
    };

    # based on those settings, create any additional entries that
    # will be needed by the configuration

    finalizeSettings = settings: let
      optimizedStdenv = pkgsToOptimize: let
        inherit (settings.optimization) USE arch useClang useNative;
        mkStdenv = march: stdenv:
        # adds -march flag to the global USE flags and creates stdenv
          pkgsToOptimize.withCFlags
          (USE ++ ["-march=${march}" "-mtune=${march}"])
          stdenv;

        # same thing but use -march=native
        mkNativeStdenv = stdenv:
          pkgsToOptimize.impureUseNativeOptimizations
          (pkgsToOptimize.stdenvAdapters.withCFlags USE stdenv);

        optimizedStdenv = mkStdenv arch pkgsToOptimize.stdenv;
        optimizedClangStdenv =
          mkStdenv arch pkgsToOptimize.llvmPackages_14.stdenv;

        optimizedNativeClangStdenv =
          nixpkgs.lib.warn "using native optimizations, \
                forfeiting reproducibility"
          mkNativeStdenv
          pkgsToOptimize.llvmPackages_14.stdenv;
        optimizedNativeStdenv =
          nixpkgs.lib.warn "using native optimizations, \
                forfeiting reproducibility"
          mkNativeStdenv
          pkgsToOptimize.stdenv;
      in
        if useNative
        then
          if useClang
          then optimizedNativeClangStdenv
          else optimizedNativeStdenv
        else if useClang
        then optimizedClangStdenv
        else optimizedStdenv;

      systemCompilerSettings = {
        gcc = {
          arch = settings.optimization.arch;
          tune = settings.optimization.arch;
        };
      };

      mkPkgsInputs = settingsSet: let
        inherit (settingsSet.optimization) useMusl useFlags;
        inherit (settingsSet) allowedUnfree system plymouth;
      in {
        config = {
          inherit (settingsSet) allowBroken;
          allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) allowedUnfree;
        };
        localSystem =
          {
            inherit system;
          }
          // (
            if useMusl
            then {
              libc = "musl";
              config = "x86_64-unknown-linux-musl";
            }
            else {}
          )
          // (
            if useFlags
            then systemCompilerSettings
            else {}
          );

        overlays =
          [
            (self: super: {
              plymouth-themes-package = import ./packages/plymouth-themes.nix ({
                  pkgs = super;
                }
                // plymouth);
            })
            # also add the theme to pkgs
          ]
          ++ (
            if (builtins.hasAttr "theme" settingsSet)
            then [
              (self: super: {
                flakeTheme = settingsSet.theme;
              })
            ]
            else []
          );
      };

      # get a set of all packages that will be overriden
      manualOverlays = pkgSet: selections:
        builtins.listToAttrs (map (value: {
            name = value;
            value = pkgSet.${value};
          })
          selections);
      # save the values that will be overriden by remotebuild AND unstable into
      # pkgs.original before overriding them
      saveOriginal = pkgSet:
        pkgSet
        // {
          original = manualOverlays pkgSet (
            settings.packageSelections.unstable
            ++ settings.packageSelections.remotebuild
          );
        };
      override = nixpkgs.lib.attrsets.recursiveUpdate;

      # create the package sets
      unstable = import nixpkgs-unstable (mkPkgsInputs (
        override settings (settings.unstableOverrides)
      ));
      remotebuild =
        # version of pkgs meant to be compiled on remote aarch64 server
        import nixpkgs-remotebuild
        (override (override (mkPkgsInputs settings) {
            localSystem.system = "aarch64-linux";
            crossSystem.system = "x86_64-linux";
          })
          settings.remotebuildOverrides);
      applyOverlays = pkgSet:
        override pkgSet (
          (manualOverlays unstable settings.packageSelections.unstable)
          // (manualOverlays remotebuild settings.packageSelections.remotebuild)
        );
      pkgs = applyOverlays (saveOriginal (import nixpkgs (mkPkgsInputs settings)));
    in (nixpkgs.lib.trivial.mergeAttrs settings rec {
      features = ["gccarch-${settings.optimization.arch}"];
      inherit pkgs unstable remotebuild;
      homeDirectory = "/home/${settings.username}";
      firefox-addons =
        (import "${rycee-expressions}" {
          inherit pkgs;
        })
        .firefox-addons;
    });
  in rec
  {
    createNixosConfiguration = settings: let
      fs = finalizeSettings settings;
    in {
      ${fs.hostname} = nixpkgs.lib.nixosSystem {
        inherit (fs) pkgs system;
        specialArgs =
          inputs
          // fs.extraSpecialArgs
          // {
            inherit (fs) unstable hostname username useMusl remotebuild;
            inherit (fs) useFlags plymouth usesWireless usesBluetooth;
            settings = fs;
          };
        modules = [
          {
            imports = [./system/configuration.nix ./modules];
          }
        ];
      };
    };

    createHomeConfigurations = settings: let
      fs = finalizeSettings settings;
    in
      home-manager.lib.homeManagerConfiguration rec {
        inherit (fs) pkgs system username homeDirectory;
        configuration = {pkgs, ...}: {
          imports = [./user/primary] ++ fs.additionalModules;
        };
        stateVersion = "22.05";
        extraSpecialArgs =
          inputs
          // {
            inherit (fs) homeDirectory firefox-addons;
          }
          // fs.extraExtraSpecialArgs
          // {
            inherit (fs) unstable hostname username useMusl remotebuild;
            inherit (fs) useFlags plymouth usesWireless usesBluetooth;
            inherit (fs) additionalUserPackages;
            settings = fs;
          };
      };

    inherit finalizeSettings;

    nixosConfigurations = createNixosConfiguration defaultGlobalSettings;
    homeConfigurations.${defaultGlobalSettings.username} =
      createHomeConfigurations defaultGlobalSettings;
    devShell.${defaultGlobalSettings.system} =
      (finalizeSettings defaultGlobalSettings).pkgs.mkShell {};
  };
}
