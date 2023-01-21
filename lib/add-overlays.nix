{
  pkgs,
  pkgsInputs,
  selections,
  override,
  ...
}:
override pkgsInputs {
  overlays =
    pkgsInputs.overlays
    ++ [(_: original: (selections pkgs original))];
}
