{
  description = "the-argus nixos system configuration";

  inputs = {
    #nixpkgs.url = "nixpkgs/nixos-21.11";
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    # master so its unstable
    home-manager.url = "github:nix-community/home-manager/master";
    # home manager use out nixpkgs and not its own
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        # hostname (evil)
        evil = lib.nixosSystem {
          inherit system;

          modules = [
            ./system/configuration.nix
          ];
        };
      };
    };
}
