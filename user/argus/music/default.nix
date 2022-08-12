{ pkgs, unstable, lib, homeDirectory, mpkgs, ... }:
# NOTE: some of these packages are installed both by being evaluated in
# home.file and home.packages. to uninstall remove both.
{
  programs.yabridge = {
    enable = true;
    package = unstable.yabridge;
    ctlPackage = unstable.yabridgectl;
    suppressFreemiumWarning = true;
    suppressUnmaintainedWarning = true;
    plugins = with mpkgs; [
      effects.ferric-tds
    ]
    ++ mpkgs.sets.heckscaper
    ++ mpkgs.sets.TAL;

    nativePlugins =
      let
        # plugins packaged in audio-plugins-nix
        internal = with mpkgs.native; [
          (mpkgs.lib.wrapPluginPath effects.fire-bin
            "Fire-Linux/VST3/Fire.vst3/Contents/x86_64-linux")
          synths.dexed
        ];
        # plugins packaged in nixpkgs already
        wrapped = with mpkgs.lib; [
          (wrapPluginPath pkgs.zam-plugins "lib/vst")
          (wrapPluginPath pkgs.surge-XT "lib/vst3")
          (wrapPluginPath pkgs.oxefmsynth "lib/lxvst")
          (wrapPluginPath unstable.ChowPhaser "lib/vst3")
          (wrapPluginPath unstable.odin2 "lib/vst3/Odin2.vst3/Contents/x86_64-linux")
          # (wrapPluginPath unstable.cardinal "lib/vst3")
          # (wrapPluginPath unstable.ChowCentaur "lib/vst3/ChowCentaur.vst3/Contents/x86_64-linux")
          # (wrapPluginPath unstable.CHOWTapeModel "lib/vst3/CHOWTapeModel.vst3/Contents/x86_64-linux")
          # (wrapPluginPath unstable.ChowKick "lib/vst3/ChowKick.vst3/Contents/x86_64-linux")
        ];
      in
      internal ++ wrapped
      # all the TAL plugins that run natively on linux
      ++ mpkgs.sets.native.TAL;

    lv2 =
      let
        wrapped = with mpkgs.lib; [
          (wrapPluginPath unstable.ChowCentaur "lib/lv2/ChowCentaur.lv2")
          (wrapPluginPath unstable.CHOWTapeModel "lib/lv2/CHOWTapeModel.lv2")
          (wrapPluginPath unstable.ChowKick "lib/lv2/ChowKick.lv2")
          (wrapPluginPath unstable.cardinal "lib/lv2")
          (wrapPluginPath unstable.airwindows-lv2 "lib/lv2/Airwindows.lv2")
          # (wrapPluginPath unstable.tunefish "lib/lv2/Tunefish4.lv2")
        ];
      in
      wrapped;

    extraPath = "${homeDirectory}/.wine/drive_c/yabridge";
  };

  home.file =
    {
      ".config/REAPER/ColorThemes/logic.ReaperThemeZip" = {
        source = pkgs.fetchurl {
          # maybe also look into:
          # https://stash.reaper.fm/theme/1932/CLogic.zip
          # https://stash.reaper.fm/theme/2146/FLogic.zip
          url = "https://stash.reaper.fm/30321/I%20Logic%20V2%20Public.ReaperThemeZip";
          name = "logicpro-reapertheme-2.0.zip";
          sha256 = "1zq7wapjnabshwq9b6jmkb8p5xv5mamvycfp94w6jp23qk3554pm";
        };
      };
    };

  home.packages = with pkgs; [
    reaper

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

    # backburner
    # Ruina distortion

    # https://www.youtube.com/playlist?list=PLCXbZyyqusu3b3_CD6gHj4fKHE4AiesnJ
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
}
