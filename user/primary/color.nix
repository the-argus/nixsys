{ pkgs, ... }:
let
  schemes = import ../../modules/color/schemes;
  scheme = (pkgs.callPackage ./themes.nix {}).scheme;
in
with scheme; (scheme // {
  c0 = black;
  c1 = red;
  c2 = green;
  c3 = yellow;
  c4 = blue;
  c5 = magenta;
  c6 = cyan;
  c7 = white;

  # dunst
  dunstbg = bg;
  dunstfg = fg;
  dunsthi = hi2;
  dunsturgent = red;

  # firefox

  firefox =
    let
      ffbg = bg;
      ffhi = scheme.firefox.highlight;
    in
    {
      userChrome = {
        # whole background
        bg = ffbg;
        # the url text
        urlbar-selected = ffhi; # rose pine 403C58
        # tab title text
        tabtext = ffhi; # rose pine 9BCED7

        # dont matter 
        panel-disabled = ffbg; # rose pine f9f9fa
        arrowpanel = white; # rose pine fefefa
        tab = red; # rose pine EA6F91
        tab-selected = red; # rose pine 403C58
        urlbar = yellow; # rose pine 98c1d9
        urlbar-results = yellow; # rose pine F1CA93
        sidebar = yellow; # rose pine F1CA93
        tab-soundplaying = magenta; # rose pine 9c89b8
        misc = cyan; # rose pine ea6f91
      };
      # user content (home page)
      userContent = {
        # dark colors
        d2 = ffbg; #"1F1D29";
        d4 = red; #"30333d";

        # word colors
        w1 = magenta; # "ccaced";
        w2 = fg; #"c0c0c0";
        w3 = white; #"dfd7d7";

        # light colors
        l1 = white; #"e1e0e6";
        l2 = fg; #"adabb9";
        l3 = altfg; # "9795a3";
        l4 = white; #"878492";

        # other colors
        o1 = blue; #"332e56";
        o2 = altbg; #"4b4757";

        # dont matter
        d1 = red; # "30333d";
        d3 = altbg; #"585e74";
        o3 = red; #"33313c";
      };
    };
})
