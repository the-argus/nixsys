{ pkgs, ... }:
pkgs.spicetify-cli.overrideAttrs (finalAttrs: previousAttrs: rec {
  pname = "spicetify-cli";
  version = "2.9.9";
  src = pkgs.fetchgit {
    url = "spicetify/${pname}";
    rev = "v${version}";
    sha256 = "1a6lqp6md9adxjxj4xpxj0j1b60yv3rpjshs91qx3q7blpsi3z4z";
  };
})
