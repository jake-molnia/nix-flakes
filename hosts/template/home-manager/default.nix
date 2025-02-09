# hosts/HOSTNAME/home-manager/default.nix
{ pkgs, username, homeDirectory, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = { pkgs, ... }: {
    imports = [
      # Add your home-manager modules here
      ./home-manager/git.nix
      ./home-manager/zsh.nix
      ./home-manager/nvim.nix
      # etc...
    ];

    home = {
      inherit username homeDirectory;
      stateVersion = "23.05";
    };

    programs.home-manager.enable = true;
  };
}