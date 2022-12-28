{unstable, ...}:
# basic override of awesome to use git master source code
unstable.awesome.overrideAttrs (_: {
  src = unstable.fetchgit {
    url = "https://github.com/awesomeWM/awesome";
    rev = "ee0663459922a41f57fa2cc936da80d5857eedc9";
    sha256 = "0wlhwabfm6mkkgf0s0f3nrm2masv6ma2g0xy24fa3z78vhwqxnib";
  };
})
