{ pkgs, username, homeDirectory, ... }:
{
  imports = [
    ../../profiles/desktop.nix           # System-level desktop profile
    ../../modules/darwin/system          # macOS system settings
    ../../modules/darwin/homebrew        # Homebrew management
    ./hardware.nix                       # Any hardware-specific settings
    ./users.nix                         # User account definitions
  ];

  # Host-specific overrides only
  system.computerName = "big-boi";
  
  # Home-manager for this host
  home-manager.users.${username} = {
    imports = [
      ../../modules/home-manager/programs/git
      ../../modules/home-manager/programs/neovim
      ../../modules/home-manager/programs/zsh
      ../../modules/home-manager/programs/starship
      ../../modules/home-manager/programs/alacritty
      ../../modules/home-manager/programs/ssh
    ];
  };
}