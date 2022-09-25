{
  pkgs,
  settings,
  ...
}: let
  inherit (settings.optimization) USE arch useClang useNative;
  mkStdenv = march: stdenv:
  # adds -march flag to the global USE flags and creates stdenv
    pkgs.withCFlags
    (USE ++ ["-march=${march}" "-mtune=${march}"])
    stdenv;

  # same thing but use -march=native
  mkNativeStdenv = stdenv:
    pkgs.impureUseNativeOptimizations
    (pkgs.stdenvAdapters.withCFlags USE stdenv);

  optimizedStdenv = mkStdenv arch pkgs.stdenv;
  optimizedClangStdenv =
    mkStdenv arch pkgs.llvmPackages_14.stdenv;

  optimizedNativeClangStdenv =
    nixpkgs.lib.warn ''
      using native optimizations, forfeiting reproducibility
    ''
    mkNativeStdenv
    pkgs.llvmPackages_14.stdenv;
  optimizedNativeStdenv =
    nixpkgs.lib.warn ''
      using native optimizations, forfeiting reproducibility
    ''
    mkNativeStdenv
    pkgs.stdenv;
in
  if useNative
  then
    if useClang
    then optimizedNativeClangStdenv
    else optimizedNativeStdenv
  else if useClang
  then optimizedClangStdenv
  else optimizedStdenv
