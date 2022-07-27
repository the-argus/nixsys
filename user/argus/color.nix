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
  firefox-tabtext = cyan; # rose pine 9BCED7
  firefox-arrowpanel = white; # rose pine fefefa
  firefox-panel-disabled = altbg2; # rose pine f9f9fa
  firefox-sidebar = yellow; # rose pine F1CA93
}
