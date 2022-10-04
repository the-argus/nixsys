rec {
  black = "282828";
  red = "cc241d";
  green = "98971a";
  yellow = "d79921";
  blue = "458588";
  magenta = "b16286";
  cyan = "689d6a";
  white = "ebdbb2";

  bg = "1d2021";
  fg = white;

  # inverted, in this case
  altbg = "ebdbb2";
  altfg = "7c6f64";

  altfg2 = "d5c4a1";
  altbg2 = "665c54";

  altfg3 = "bdae93";
  altbg3 = "504945";

  hi1 = yellow;
  hi2 = red;
  hi3 = blue;
  hi4 = cyan;

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
