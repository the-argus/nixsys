{
  description = "the-argus nixos system configuration";

  inputs = {
    #nixpkgs.url = "nixpkgs/nixos-21.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      # home manager use out nixpkgs and not its own
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      url = "github:the-argus/nvim-config";
      flake = false;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ranger-devicons = {
      url = "github:alexanderjeurissen/ranger_devicons";
      flake = false;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kanagawa-gtk = {
      url = "github:Fausto-Korpsvart/Kanagawa-GKT-Theme";
      flake = false;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, nvim-config, ranger-devicons, kanagawa-gtk, arkenfox-userjs, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "argus";
    in
    {
      nixosConfigurations = {
        # hostname (evil)
        evil = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            ./system/configuration.nix
          ];
        };
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit system username;
        homeDirectory = "/home/${username}";
        configuration = import ./user/${username};
        stateVersion = "22.05";
        extraSpecialArgs = inputs;
      };
    };
}
