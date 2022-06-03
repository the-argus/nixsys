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

    nvim-config = {
      url = "github:the-argus/nvim-config";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
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
