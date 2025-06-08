# home-manager/nvim.nix
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    # TODO: is this actually needed? or is the xdg load fine?    
    extraConfig = ''${builtins.readFile ./config/init.lua}'';
  };

  # This creates a symlink of your entire nvim config directory in the right place
  xdg.configFile."nvim" = {
    source = ./config; 
    recursive = true;   # This ensures all subdirectories are included
  };
}