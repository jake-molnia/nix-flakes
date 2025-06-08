# lib/utils.nix

{ nixpkgs }:

{
  # basic nixpkgs with basic config
  nixpkgsWithConfig = system: import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
}