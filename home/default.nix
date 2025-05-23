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
    mutt
    mutt-oauth
  ] ++ lib.optionals (!stdenv.isDarwin) [
    wslu
    keybase-gui
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.taskwarrior = {
    enable = true;
    config = {};
  };

  programs.gpg = {
    enable = true;
    mutableKeys = true;
  };

  services = lib.mkMerge [
    {
      gpg-agent = let
        day = 86400;
      in {
        enable = true;
        defaultCacheTtl = 1 * day;
        defaultCacheTtlSsh = 1 * day;
        maxCacheTtl = 30 * day;
        maxCacheTtlSsh = 30 * day;
        pinentryPackage = pkgs.pinentry-wsl;
        enableSshSupport = true;
      };
    }

    (lib.mkIf (!pkgs.stdenv.isDarwin) {
      keybase.enable = true;
      kbfs.enable = true;
    })
  ];
}
