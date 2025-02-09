# Template for adding a new system
# To use:
# 1. Copy this directory to hosts/your-hostname/
# 2. Add your system to the systems attribute in flake.nix:
#    my-new-system = {
#      system = "aarch64-darwin";    # or appropriate architecture
#      type = "darwin";              # or "nixos"
#      hostPath = ./hosts/HOSTNAME;
#      username = "yourusername";
#      homeDirectory = "/Users/yourusername";  # or /home/yourusername for Linux
#    };

# hosts/HOSTNAME/default.nix
{ pkgs, homebrew-core, homebrew-cask, homebrew-bundle, username, homeDirectory, ... }:
{
  imports = [
    ./homebrew    # Remove for NixOS        # For homebrew management
    ./system.nix                            # For system settings 
    ./home-manager                          # Directory for dotfile managment
  ];

  # Pass the homebrew inputs to the homebrew module (remove for NixOS)
  _module.args = {
    inherit homebrew-core homebrew-cask homebrew-bundle username homeDirectory;
  };
}


# hosts/HOSTNAME/home-manager/
# ├── default.nix          # Optional: For home-manager wide settings
# ├── git.nix             # Git configuration
# ├── zsh.nix             # Zsh configuration
# ├── nvim.nix            # Neovim configuration
# └── files/              # Directory for static config files
#     ├── .zshrc
#     └── .config/
#         └── nvim/       # Recursive nvim config directory