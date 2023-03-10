{original-kitty, ...}:
if original-kitty == null
then abort "kitty override cannot be called normally"
else
  original-kitty.overrideAttrs (oa: {
    patches =
      oa.patches
      ++ [
        ./allow-bitmap-fonts.patch
      ];
  })
