rec {
  black = "2e3440";
  red = "bf616a";
  green = "8fbcbb";
  yellow = "ebcb8b";
  blue = "88c0d0";
  magenta = "b48ead";
  cyan = "81a1c1";
  white = "eceff4";

  bg = "4c566a";
  fg = white;

  # inverted, in this case
  altbg = "e5e9f0";
  altfg = "5e81ac";

  altfg2 = "eceff4";
  altbg2 = "3b4252";

  altfg3 = altfg2;
  altbg3 = "434c5e";

  hi1 = blue;
  hi2 = cyan;
  hi3 = white;
  hi4 = green;

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
      bg = altbg3;
    };
  };
  terminal = {
    bg = black;
    black = bg;
  };
}
