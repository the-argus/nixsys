{
  rosepine = rec {
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
  };

  nord = rec {
    black = "2e3440";
    red = "bf616a";
    green = "8fbcbb";
    yellow = "ebcb8b";
    blue = "88c0d0";
    magenta = "b48ead";
    cyan = "81a1c1";
    white = "eceff4";

    bg = "3b4252";
    fg = white;

    # inverted, in this case
    altbg = "e5e9f0";
    altfg = "5e81ac";

    altfg2 = "eceff4";
    altbg2 = "434c5e";
    
    altfg3 = altfg2;
    altbg3 = "4c566a";

    hi1 = blue;
    hi2 = cyan;
    hi3 = white;
    hi4 = magenta;
    
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
  };

  gtk4 = rec {
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
  };
}
