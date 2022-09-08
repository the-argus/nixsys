rec {
  black = "000000";
  red = "FF296A";
  green = "3DFBAC";
  yellow = "FAFB92";
  blue = "7B4AF6";
  magenta = "BB48DF";
  cyan = "3CB3BB";
  white = "F0F3F3";

  bg = "000000";
  fg = "F0F3F3";

  # inverted, in this case
  altbg = "F0F3F3"; # 44475a originally
  altfg = "000000";

  altfg2 = "F0F3F3";
  altbg2 = "14151b";

  altfg3 = "F0F3F3";
  altbg3 = "14151b";

  hi1 = green;
  hi2 = magenta;
  hi3 = cyan;
  hi4 = yellow;

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
