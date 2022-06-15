{ ... }:
let

  black = "0x6e6a86";
  red = "0xeb6f92";
  green = "0x9ccfd8";
  yellow = "0xf6c177";
  blue = "0x31748f";
  magenta = "0xc4a7e7";
  cyan = "0xebbcba";
  white = "0xe0def4";
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

  bg = "0x191724";
  fg = "0xe0def4";
  
  # inverted, in this case
  altbg = "0x2A2738";
  altfg = "0x796268";

  c0 = black;
  c1 = red;
  c2 = green;
  c3 = yellow;
  c4 = blue;
  c5 = magenta;
  c6 = cyan;
  c7 = white;
}
