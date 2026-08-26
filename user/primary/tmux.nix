{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color"; # or screen-256color? not sure of the difference
    historyLimit = 100000; # default 2K, 100K is more than enough
    # Address vim mode switching delay (http://superuser.com/a/252717/65504)
    escapeTime = 0;
    keyMode = "vi"; # could also be emacs, supposedly emacs is better for status-keys for entering commands (the : menu). that is set in extraConfig
    focusEvents = true;
    aggressiveResize = true;

    plugins = with pkgs.tmuxPlugins; [
      resurrect
      continuum

      better-mouse-mode
      yank # copy to system clipboard
      # TODO: vim-tmux-navigator, requires integration with neovim
      tmux-fzf
      prefix-highlight
      mode-indicator

      fuzzback # default keybind is ctrl+B and ?
    ];

    tmux-which-key = {
      enable = true;
      # to see what is wrong with settings, run `nix log`, according  to the readme for tmux-which-key
      settings = import ./tmux-which-key.nix;
    };

    extraConfig = ''
      # fuzzback plugin config
      set -g @fuzzback-popup 1
      set -g @fuzzback-popup-size '90%'

      # resize current pane by five units with prefix + <shift + hjkl>
      bind-key -r H resize-pane -L 5
      bind-key -r J resize-pane -D 5
      bind-key -r K resize-pane -U 5
      bind-key -r L resize-pane -R 5

      # tmux-sensible options ------------------------------------------------

      # Refresh 'status-left' and 'status-right' more often, from every 15s to 5s
      set -g status-interval 5

      # Increase tmux messages display duration from 750ms to 4s
      set -g display-time 4000

      # Emacs key bindings in tmux command prompt (prefix + :) are better than
      # vi keys, even for vim users
      set -g status-keys emacs
    '';
  };
}
