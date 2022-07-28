{ ... }:
let
  black = "6e6a86";
  red = "eb6f92";
  green = "9ccfd8";
  yellow = "f6c177";
  blue = "31748f";
  magenta = "c4a7e7";
  cyan = "ebbcba";
  white = "e0def4";

  bg = "191724";
  fg = white;

  # inverted, in this case
  altbg = "2A2738";
  altfg = "796268";
  
  altfg2 = "26233a";
  altbg2 = "1f1d2e";

  altbg3 = "555169";
in
{
  inherit black;
  inherit red;
  inherit green;
  inherit yellow;
  inherit blue;
  inherit magenta;
  inherit cyan;
  inherit white;

  inherit bg;
  inherit fg;

  inherit altbg;
  inherit altfg;
  
  # similar to regular bg
  inherit altbg2;
  inherit altfg2;
  
  inherit altbg3;

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
  dunsthi = yellow;
  dunsturgent = red;
  
  # firefox
  firefox-chrome-bg = altbg2;
  firefox-tabtext = green; # rose pine 9BCED7
  firefox-arrowpanel = white; # rose pine fefefa
  firefox-panel-disabled = altbg2; # rose pine f9f9fa
  firefox-sidebar = yellow; # rose pine F1CA93
  firefox-tab = red; # rose pine EA6F91
  firefox-tab-selected = bg; # rose pine 403C58
  firefox-tab-soundplaying = magenta; # rose pine 9c89b8
  firefox-urlbar = altbg2; # rose pine 98c1d9
  firefox-urlbar-selected = bg; # rose pine 403C58
  firefox-urlbar-results = yellow; # rose pine F1CA93
  firefox-misc = cyan; # rose pine ea6f91
  firefox-usercontent = {
    # dark colors
    d1 = bg;# "30333d";
    d2 = altbg;#"1F1D29";
    d3 = altbg2;#"585e74";
    d4 = altbg3;#"30333d";
    
    # word colors
    w1 = magenta;# "ccaced";
    w2 = fg; #"c0c0c0";
    w3 = white; #"dfd7d7";

    # light colors
    l1 = white; #"e1e0e6";
    l2 = fg; #"adabb9";
    l3 = altfg;# "9795a3";
    l4 = white;#"878492";

    # other colors
    o1 = blue; #"332e56";
    o2 = altbg; #"4b4757";
    o3 = bg; #"33313c";
  };
}
