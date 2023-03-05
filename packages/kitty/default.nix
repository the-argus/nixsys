{original-kitty, ...}:
original-kitty.overrideAttrs (oa: {
  patches =
    oa.patches
    ++ [
      ./allow-bitmap-fonts.patch
    ];
})
