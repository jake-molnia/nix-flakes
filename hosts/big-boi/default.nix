{ pkgs, username, homeDirectory, ... }:
{
  imports = [
    ../../profiles/desktop.nix           # System-level desktop profile
    ../../modules/darwin/system          # macOS system settings
    ../../modules/darwin/homebrew        # Homebrew management
    ./hardware.nix                       # Any hardware-specific settings
    ./users.nix                         # User account definitions
  ];
}