# home-manager/default.nix
{ pkgs, username, homeDirectory, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    
    users.${username} = { pkgs, ... }: {
      imports = [
        # User specific packages (see ../packages.nix for global packages)
        ./${username}/packages.nix
        # Dotfiles
        ./${username}/alacritty.nix
        ./${username}/git.nix
        ./${username}/nvim.nix
        ./${username}/ssh.nix
        ./${username}/starship.nix
        ./${username}/zsh.nix
      ];

      home = {
        inherit username homeDirectory;
        stateVersion = "23.05";
      };
      
      programs.home-manager.enable = true;
    };
  };
}
