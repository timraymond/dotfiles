{ config, lib, pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "nixos" ];
    };
  };

  # System configuration
  system = {
    stateVersion = 4;
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };
      dock = {
        autohide = false;
        showhidden = true;
        mru-spaces = false;
      };
      finder = {
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
      };
    };
  };

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  users.users.tim = {
    name = "tim";
    home = "/Users/tim";
  };
}
