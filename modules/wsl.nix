{ config, lib, pkgs, ... }:
{
  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  time.timeZone = lib.mkDefault "America/New_York";

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "nixos" ];
    };
  };

  system.stateVersion = "23.11";

  virtualisation.docker.enable = true;

  users.users.nixos = {
    extraGroups = [ "docker" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
}
