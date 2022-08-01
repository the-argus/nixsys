{ pkgs, ... }:
pkgs.ungoogled-chromium.overrideAttrs (attrs: {
  dontPatch = false;
  patches = (attrs.patches or [ ]) ++ [ ./patches/extension-search-path.patch ];
})
