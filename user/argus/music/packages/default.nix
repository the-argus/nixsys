{ pkgs, ... }:
{
  synths = {
    ct0w0 = import ./synths/ct-0w0.nix { inherit pkgs; };
  };

  effects = {
    frohmage = import ./effects/frohmage.nix { inherit pkgs; };
  };

  native = {
    synths = {
      dexed = import ./native/synths/dexed.nix { inherit pkgs; };
    };
  };
}
