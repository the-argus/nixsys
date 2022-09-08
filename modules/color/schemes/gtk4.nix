rec {
  black = "323232";
  red = "E01818";
  green = "41AC85";
  yellow = "EA9B26";
  blue = "3584E4";
  magenta = "9367DA";
  cyan = "56C9D0";
  white = "F9F9F9";

  bg = "242424";
  fg = white;

  # inverted, in this case
  altbg = "DDDDDD";
  altfg = "353535";

  altfg2 = "e9e9e9";
  altbg2 = "474747";

  altfg3 = altfg2;
  altbg3 = "525252";

  hi1 = blue;
  hi2 = cyan;
  hi3 = white;
  hi4 = green;

  firefox = {
    highlight = white;
  };
  dribbblish = {
    center = {
      text = hi3;
      inherit bg;
    };
    outer = {
      text = hi3;
      bg = altfg;
    };
  };
  terminal = {
    inherit bg;
    inherit black;
  };
}
