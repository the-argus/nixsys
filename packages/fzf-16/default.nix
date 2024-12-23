{
  stdenvNoCC,
  fzf-original,
  buildPackages,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "${fzf-original.name}-wrapper";
  version = fzf-original.version;

  src = fzf-original;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [buildPackages.makeWrapper];

  postInstall = ''
    mkdir $out/bin -p
    ln -sf $src/share $out/share
    ln -sf $src/bin/fzf $out/bin/fzf
    ln -sf $src/bin/fzf-share $out/bin/fzf-share
    ln -sf $src/bin/fzf-tmux $out/bin/fzf-tmux

    wrapProgram $out/bin/fzf --add-flags "--color=16"
  '';
}
