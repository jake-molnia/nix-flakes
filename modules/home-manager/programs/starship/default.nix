# home-manager/starship.nix
{ pkgs, ... }:
{
    programs.starship = {
        enable = true;
        settings = builtins.fromTOML (builtins.readFile ./config/starship.toml);
  };

}