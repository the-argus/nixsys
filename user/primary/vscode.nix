# unfortunately I need vscode for unity dev
{
  pkgs,
  unstable,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.myPackages.vscodium-wrapper.override {
      additionalPackages = with pkgs; [dotnet-sdk omnisharp-roslyn];
    };
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    userSettings = {
      extensions.autoCheckUpdates = false;
      update.mode = "none";
      workbench.colorTheme = "Catppuccin Mocha";
      workbench.iconTheme = "catppuccin-mocha";
    };

    extensions = with pkgs.vscode-extensions; [
      unstable.vscode-extensions.catppuccin.catppuccin-vsc
      unstable.vscode-extensions.catppuccin.catppuccin-vsc-icons
      editorconfig.editorconfig
      ms-dotnettools.csharp

      # asvetliakov.vscode-neovim
      vscodevim.vim
    ];
  };
}
