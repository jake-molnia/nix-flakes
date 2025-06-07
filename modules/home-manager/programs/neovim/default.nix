# home-manager/nvim.nix
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    
    # This will automatically source all files from the nvim directory
    extraConfig = ''
      ${builtins.readFile ./files/nvim/init.lua}
    '';
  };

  # This creates a symlink of your entire nvim config directory in the right place
  xdg.configFile."nvim" = {
    source = ./files/nvim;
    recursive = true;   # This ensures all subdirectories are included
  };
}