{ config, lib, pkgs, ... }:
{
    programs.tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      historyLimit = 100000;
      extraConfig = ''
      # remap prefix to C-a
      set -g prefix C-a
      unbind C-b
      bind C-a send-prefix

      # bind | and - to split commands
      bind | split-window -h
      bind - split-window -v

      # status bar on top
      set-option -g status-position top

      # vi-mode mappings
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
      bind-key -T copy-mode-vi 'y' send-keys -X copy-selection

      # mouse mode
      set -g mouse on

      # vim resize
      bind H resize-pane -L 5
      bind J resize-pane -D 5
      bind K resize-pane -U 5
      bind L resize-pane -R 5

      # vim move
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # no window rename
      set-option -g allow-rename off

      # theme
      source-file ${pkgs.tmux-themepack}/share/tmux-themepack/powerline/default/blue.tmuxtheme
      '';
    };
}
