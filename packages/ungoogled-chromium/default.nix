{ pkgs, ... }:
pkgs.ungoogled-chromium.overrideAttrs (attrs: {
    patches = (attrs.patches or []) ++ [ ./patches/extension-search-path.patch ];
})
