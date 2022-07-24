{ pkgs, ... }:
pkgs.ungoogled-chromium.overrideAttrs (finalAttrs: previousAttrs: {
    patches = previousAttrs.patches ++ [ ./patches/extension-search-path.patch ];
})
