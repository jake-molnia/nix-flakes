# lib/utils.nix
# Utility functions for system configuration

{ nixpkgs }:

{
  # Create nixpkgs with consistent configuration
  nixpkgsWithConfig = system: import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      # Add more Nixpkgs configuration here as needed
    };
  };
}