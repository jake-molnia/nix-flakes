# home-manager/zsh.nix
{ pkgs, ... }:
{
    programs.ssh = {
    enable = true;
    #includes = "/Users/jake/.ssh/config_external";
    matchBlocks = {
      "github.com" = {
        identitiesOnly = true;
        extraOptions = {
          AddKeysToAgent = "yes";
        };
        identityFile = "/Users/jake/.ssh/keys/id_github";
      };
    };
  };

}