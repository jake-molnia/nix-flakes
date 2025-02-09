# default.nix
{ pkgs, homebrew-core, homebrew-cask, homebrew-bundle, username, homeDirectory, ... }:
{
  imports = [
    ./homebrew                              # For homebrew management
    ./system.nix                            # For system settings 
    ./home-manager                          # Directory for dotfile managment
  ];

  # Pass the homebrew inputs to the homebrew module (remove for NixOS)
  _module.args = {
    inherit homebrew-core homebrew-cask homebrew-bundle username homeDirectory;
  };
}