{ config, lib, pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "tim" ];
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

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
    };

    casks = [
      "dash"
      "autodesk-fusion"
      "microsoft-office"
    ];

    masApps = {
      "1password" = 443987910;
      "OmniFocus" = 1346203938;
    };
  };

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  services.tailscale = {
    enable = true;
    overrideLocalDns = true;
  };

  users.users.tim = {
    name = "tim";
    home = "/Users/tim";
  };
}
