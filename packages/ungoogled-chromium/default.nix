{ pkgs, ... }:
pkgs.ungoogled-chromium.overrideAttrs (finalAttrs: previousAttrs: {
    patches = [ ./patches/extension-search-path.patch ];
})
