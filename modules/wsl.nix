{ config, lib, pkgs, ... }:
{
  wsl = {
    enable = true;
    defaultUser = "tim";
  };

  time.timeZone = lib.mkDefault "America/New_York";

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "tim" ];
    };
  };

  system.stateVersion = "23.11";

  virtualisation.docker.enable = true;

  users.groups.tim = {};
  users.users.tim = {
    group = "tim";
    isNormalUser = true;
    extraGroups = [ "docker" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
}
