rec {
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

  altfg3 = "908caa";
  altbg3 = "555169";

  hi1 = magenta;
  hi2 = yellow;
  hi3 = cyan;
  hi4 = altbg;

  firefox = {
    highlight = hi1;
  };
  dribbblish = {
    center = {
      text = hi3;
      inherit bg;
    };
    outer = {
      text = hi3;
      bg = altbg;
    };
  };
  terminal = {
    inherit bg;
    inherit black;
  };
}
