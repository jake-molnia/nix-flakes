# =============================================================================
# Multi-System Nix Configuration
# =============================================================================
#
# Author: Jacob Molnia
# Last Updated: 2025
#
# This configuration manages multiple systems including Darwin (macOS) and NixOS.
# It provides a unified way to handle different architectures and system types
# while maintaining separate configurations for each host.

{
  description = "Jake's Nix flake configuration for Darwin and NixOS systems";

  # =============================================================================
  # Input Sources
  # =============================================================================
  inputs = {
    # Core Components
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin (macOS) Specific Components
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew integration
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  # =============================================================================
  # System Configuration
  # =============================================================================
  outputs = { self, nixpkgs, home-manager, darwin, nix-homebrew, homebrew-core,
              homebrew-cask, homebrew-bundle, ... }:
    let
      # Import our library functions
      lib = import ./lib { 
        inherit nixpkgs darwin home-manager nix-homebrew 
                homebrew-core homebrew-cask homebrew-bundle; 
      };

      # System Definitions - Now declarative and clean
      systems = {
        big-boi = {
          system = "aarch64-darwin";
          type = "darwin";
          profiles = [ "desktop" ];
          features = {
            #homebrew = true;
            neovim = true;
            git = true;
            zsh = true;
            starship = true;
            alacritty = true;
          };
          username = "jake";
          homeDirectory = "/Users/jake";
        };

        # Example of how to add more systems easily
        # work-mac = {
        #   system = "x86_64-darwin";
        #   type = "darwin";
        #   profiles = [ "minimal" "development" ];
        #   features = {
        #     homebrew = false;
        #     docker = true;
        #     neovim = true;
        #   };
        #   username = "jake-work";
        #   homeDirectory = "/Users/jake-work";
        # };
      };

      # Generate attributes for all supported system types
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-darwin" 
        "x86_64-linux"
      ];

      # Filter systems by type
      darwinSystems = nixpkgs.lib.filterAttrs (n: v: v.type == "darwin") systems;
      nixosSystems = nixpkgs.lib.filterAttrs (n: v: v.type == "nixos") systems;

    in {
      # =============================================================================
      # Output Definitions
      # =============================================================================

      # System configurations using our library builders
      darwinConfigurations = builtins.mapAttrs (name: config: 
        lib.mkDarwinSystem config
      ) darwinSystems;

      nixosConfigurations = builtins.mapAttrs (name: config: 
        lib.mkNixosSystem config
      ) nixosSystems;

      # Package outputs for each system
      packages = forAllSystems (system:
        (builtins.mapAttrs (name: _: 
          self.darwinConfigurations.${name}.system
        ) darwinSystems) //
        (builtins.mapAttrs (name: _: 
          self.nixosConfigurations.${name}.config.system.build.toplevel
        ) nixosSystems)
      );

      # Development shells
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixpkgs-fmt
              nix-tree
              just
            ];
          };
        }
      );
    };
}