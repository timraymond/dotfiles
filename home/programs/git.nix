{ config, lib, pkgs, ... }:
{
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      userName = "Timothy J. Raymond";
      userEmail = "traymond@microsoft.com";
      difftastic = {
        enable = true;
        background = "dark";
      };
      extraConfig = {
        merge = {
          conflictstyle = "diff3";
        };
        credential = {
          "https://github.com" = {
            credentialStore = "cache";
            helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
          };
          "https://github.com/azure-networking" = {
            credentialStore = "cache";
            helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
          };
        };
      };
    };
}
