{ pkgs, unstable, lib, homeDirectory, mpkgs, ... }:
# NOTE: some of these packages are installed both by being evaluated in
# home.file and home.packages. to uninstall remove both.
{
  programs.yabridge = {
    enable = true;
    package = unstable.yabridge;
    ctlPackage = unstable.yabridgectl;
    paths =
      [
        "${mpkgs.effects.ferric-tds}"
      ] ++ (map (value: "${value}") mpkgs.sets.heckscaper)
      ++ (map (value: "${value}") mpkgs.sets.TAL);
    nativePaths = [
      "${mpkgs.native.effects.fire-bin}"
    ] ++ (map (value: "${value}") mpkgs.sets.native.TAL);
    extraPath = "${homeDirectory}/.wine/drive_c/yabridge";
  };

  home.packages = with pkgs; [
    # music
    reaper

    # plugins
    zam-plugins
    airwindows-lv2
    unstable.cardinal
    ChowPhaser
    ChowKick
    ChowCentaur
    CHOWTapeModel

    # synths
    surge-XT
    oxefmsynth
    odin2
    tunefish
    # bespokesynth
    # bespokesynth-with-vst2

    # need to look up what these are (nix search lv2)
    # talentedhack # autotalent ported to lv2
    # x42-plugins
    # vocproc
    # x42-avldrums
    # sorcer
    # rkrlv2
    # plujain-ramp

    # https://www.youtube.com/playlist?list=PLCXbZyyqusu3b3_CD6gHj4fKHE4AiesnJ
    # TODO: Fire distortion, Ruina distortion
    # AIRWINDOWS (NC-17 is cool)
    # Gatelab, filterstep, and panflow (use panflow for 70s drums)
    # Surge FX (Surge XT effects separated)
    # deelay (kinda like valhalla supermassive)
    # driftmaker delay disentegration (creepy digital delay)
    # emergence - grain delay thing, very visual, trip-hop-ey
    # fogpad (open source babeyyy, check out the creator)
    # PSP pianoverb (simulates having a sustaining piano in the room when a loud sound is played)
    # all the CHOW plugins, CHOW matrix works on linux, open source
    # GSatPlus (excellent sounding free saturation plugin)
    # Burier (also saturation, absolutely destroys shit, can be a cool distortion pedal)
    #           https://www.youtube.com/watch?v=lw03654HndM&list=PLCXbZyyqusu3b3_CD6gHj4fKHE4AiesnJ&index=3
    # Melda Free Bundle https://www.meldaproduction.com/MFreeFXBundle
    # Channe V (de-esser, compressor, limiter, pre, tape) analog obsession
    # PreBox (analog obsession, saturation-ey mix glue thing)
    # Magic Dice by baby audio (random delay)
    # Amplitube CS (stompboxes tuner preamps and shit, freemium though)
    # TDR Nova
    # Zebralette U-he

    # other plugins i should get:
    # modartt pianoteq 
  ];

  home.file =
    {
      ".vst/dexed" = {
        source = "${mpkgs.native.synths.dexed}/Dexed.vst3/Contents/x86_64-linux";
        recursive = true;
      };
      ".vst/zam" = {
        source = "${pkgs.zam-plugins}/lib/vst";
        recursive = true;
      };
      ".vst/surge" = {
        source = "${pkgs.surge-XT}/lib/vst3";
        recursive = true;
      };
      ".vst/oxe" = {
        source = "${pkgs.oxefmsynth}/lib/lxvst";
        recursive = true;
      };
      ".vst/cardinal" = {
        source = "${unstable.cardinal}/lib";
        recursive = true;
      };
      ".vst/CHOW/Phaser" = {
        source = "${unstable.ChowPhaser}";
        recursive = true;
      };
      ".vst/CHOW/Kick" = {
        source = "${unstable.ChowKick}";
        recursive = true;
      };
      ".vst/CHOW/Centaur" = {
        source = "${unstable.ChowCentaur}";
        recursive = true;
      };
      ".vst/CHOW/TapeModel" = {
        source = "${unstable.CHOWTapeModel}";
        recursive = true;
      };
      ".vst/airwindows" = {
        source = "${unstable.airwindows-lv2}";
        recursive = true;
      };
      ".vst/odin2" = {
        source = "${unstable.odin2}";
        recursive = true;
      };
      ".vst/tunefish" = {
        source = "${unstable.tunefish}";
        recursive = true;
      };
    };
}
