{
  description = "the-argus nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      # home manager use our nixpkgs and not its own
      inputs.nixpkgs.follows = "nixpkgs";
    };

    banner.url = "github:the-argus/banner.nix";

    audio-plugins = {
      url = "github:the-argus/audio-plugins-nix?ref=yabridge-packaging";
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    rycee-expressions = {
      url = "gitlab:rycee/nur-expressions";
      flake = false;
    };

    chrome-extensions = {
      url = "github:the-argus/chrome-extensions-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    webcord.url = "github:fufexan/webcord-flake";

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gtk-nix = {
      url = "github:the-argus/gtk-nix?ref=banner";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    modern-unix = {
      url = "github:the-argus/modern-unix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    rycee-expressions,
    # , nur
    audio-plugins,
    ...
  } @ inputs: let
    myLib = import ./lib {inherit (nixpkgs) lib;};
    finalizeSettings = settings:
      myLib.globalConfig.addPkgsToSettings {
        inherit nixpkgs-unstable nixpkgs;
        inherit settings;
      };
    defaultGlobalSettings = myLib.globalConfig.defaults;
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
            inherit (fs) unstable localbuild useMusl remotebuild;
            inherit (fs) useFlags plymouth usesWireless usesBluetooth;
            inherit (fs) usesEthernet hostname username;
            inherit (fs) additionalSystemPackages;
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
      inherit
        (import "${rycee-expressions}" {inherit (fs) pkgs;})
        firefox-addons
        ;
    in
      home-manager.lib.homeManagerConfiguration rec {
        inherit (fs) pkgs system username homeDirectory;
        configuration = {...}: {
          imports =
            [
              ./user/primary
              audio-plugins.homeManagerModule
            ]
            ++ fs.additionalModules;
        };
        stateVersion = "22.05";
        extraSpecialArgs =
          inputs
          // {
            inherit (fs) homeDirectory;
            inherit firefox-addons;
            mpkgs = audio-plugins.mpkgSets.${system};
          }
          // fs.extraExtraSpecialArgs
          // {
            inherit (fs) unstable remotebuild localbuild;
            inherit (fs) useFlags useMusl useClang;
            inherit (fs) usesEthernet usesWireless usesBluetooth;
            inherit (fs) additionalUserPackages hostname username;
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
