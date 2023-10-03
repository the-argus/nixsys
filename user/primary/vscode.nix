# unfortunately I need vscode for unity dev
{
  pkgs,
  unstable,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      unstable.vscode-extensions.catppuccin.catppuccin-vsc
      unstable.vscode-extensions.catppuccin.catppuccin-vsc-icons
      editorconfig.editorconfig
      ms-dotnettools.csharp
    ];
  };
}
