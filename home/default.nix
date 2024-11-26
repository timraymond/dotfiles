{ config, lib, pkgs, ... }:
{
  imports = [
    ./programs/tmux.nix
    ./programs/git.nix
    ./programs/vim.nix
    ./programs/zsh.nix
  ];

  home.stateVersion = "18.09";

  home.file.".vim/swapfiles/.keep" = {
    enable = true;
    text = "keep";
  };

  home.file.".vim/snips/.keep" = {
    enable = true;
    text = "keep";
  };

  home.packages = with pkgs; [
    ripgrep
    gh
    kubectl
    k9s
    kind
    docker
    git-credential-manager
    kubernetes-helm
    keybase
    kbfs
    comma
    tig
    difftastic
    universal-ctags
    tmux-themepack
    git-bug
  ] ++ lib.optionals (!stdenv.isDarwin) [
    wslu
    keybase-gui
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gpg = {
    enable = true;
    mutableKeys = true;
  };

  services = lib.mkMerge [
    {
      gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        pinentryPackage = pkgs.pinentry-curses;
        enableSshSupport = true;
      };
    }

    (lib.mkIf (!pkgs.stdenv.isDarwin) {
      keybase.enable = true;
      kbfs.enable = true;
    })
  ];
}
