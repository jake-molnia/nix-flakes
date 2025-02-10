{ pkgs, homebrew-core, homebrew-cask, homebrew-bundle, username, ... }:
{
  imports = [
    ./casks.nix
    ./brews.nix
    ./masApps.nix
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
    
    mutableTaps = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };
  };
}
