# lib/default.nix
# Library functions for building system configurations

{ nixpkgs, darwin, home-manager, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle }:

let
  # Import individual library modules
  mkHost = import ./mkHost.nix { 
    inherit nixpkgs darwin home-manager nix-homebrew 
            homebrew-core homebrew-cask homebrew-bundle; 
  };
  
  utils = import ./utils.nix { inherit nixpkgs; };

in {
  # Export the host builders
  inherit (mkHost) mkDarwinSystem mkNixosSystem;
  
  # Export utility functions
  inherit (utils) nixpkgsWithConfig;
}