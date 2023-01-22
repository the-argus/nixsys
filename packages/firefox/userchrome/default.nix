{callPackage, ...}: {
  # creates userChrome strings based on input
  mkOriginal = callPackage ./original.nix;
  mkCascade = callPackage ./cascade;
}
