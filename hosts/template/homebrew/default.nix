# hosts/HOSTNAME/homebrew/default.nix
# Remove this file for NixOS systems
{ pkgs, homebrew-core, homebrew-cask, homebrew-bundle, username, ... }:
{
  imports = [
    ./casks.nix
    ./brews.nix
  ];

  homebrew = {
    # This will enable nix-darwin to manage your homebrew casks, brews and formulae
    enable = true;
    # This is used for homebrew to check for new versions with every rebuild. This takes more time during rebuild (so disable for faster changes, but I forget otherwise)
    onActivation.autoUpdate = true;
  };

  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;
    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = username;

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
    
    # Optional: Enable fully-declarative tap management
    #
    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };
}
