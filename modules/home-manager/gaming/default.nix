{
  pkgs,
  unstable,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gaming;
in {
  options.gaming = {
    enable = mkEnableOption "Install game launchers and setup hardware.";
    minecraft = mkEnableOption "Install a minecraft launcher, pretty much.";
    steam = mkEnableOption "Enable steam and the hardware changes necessary for it.";
    typing = mkEnableOption "Install some typing games";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        heroic
        # lutris
      ]
      ++ (lib.lists.optionals cfg.minecraft (with pkgs; [
        prismlauncher
        unstable.ferium
        jre8
      ]))
      ++ (lib.lists.optionals cfg.steam (with pkgs; [
        steam
        protontricks
      ]))
      ++ (lib.lists.optionals cfg.typing (with pkgs; [
        # typing games
        # thokr     # another simply game with the added ability to tweet
        # your results
        # ktouch    # underwhelming, QWERTY-only. provides a useful
        # capitalization lesson for my bad shift habits
        # ttyper    # simple game, just typing random words then it tells
        # you your speed
        # toipe     # another simple game, looks nice too

        tipp10 # in-depth QWERTY trainer, could support dvorak with
        # a bit of effort (key replacement filter)
        klavaro # good for QWERTY, but only lets you do systemwide
        # dvorak
        gtypist # very good for qwerty, also requires systemwide
        # dvorak
        gotypist # makes you practice fast, slow, and medium.
        # cool typing experiment, idk how good it is really
        #typespeed  # words come flying at you from the left side. fun
        # game, idk how good it really is for typing
      ]));
  };
}
