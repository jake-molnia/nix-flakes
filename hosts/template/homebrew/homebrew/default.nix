{ pkgs, homebrew-core, homebrew-cask, homebrew-bundle, username, ... }:
{
  imports = [
    ./casks.nix
    ./brews.nix
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
    
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
    
    mutableTaps = false;
  };

  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
}
