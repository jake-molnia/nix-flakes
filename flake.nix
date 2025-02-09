# =============================================================================
# Multi-System Nix Configuration
# =============================================================================
#
# Author: Jacob Molnia
# Last Updated: 2024
#
# This configuration manages multiple systems including Darwin (macOS) and NixOS.
# It provides a unified way to handle different architectures and system types
# while maintaining separate configurations for each host.
#
# Prerequisites:
#   - Nix package manager with flakes enabled
#   - Git for repository access
#   - For macOS: Xcode Command Line Tools
#
# Usage:
#   1. Clone this configuration
#   2. Modify the systems configuration to match your hosts
#   3. Run `nix build .` to build the configuration
#   4. Apply the configuration with:
#      - Darwin: `./result/sw/bin/darwin-rebuild switch --flake .`
#      - NixOS: `nixos-rebuild switch --flake .`

{
  # Brief description of the flake's purpose
  description = "Jake's Nix flake configuration for Darwin and NixOS systems";

  # =============================================================================
  # Input Sources
  # =============================================================================
  #
  # These define where Nix should fetch its dependencies. Each input represents
  # a different source that provides functionality to our system.
  
  inputs = {
    # ---------------------------------------------------------------------
    # Core Components
    # ---------------------------------------------------------------------
    
    # The main Nix package collection. We use unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home-manager: Manages user environment configuration
    # This includes user-specific packages, dotfiles, and program settings
    home-manager = {
      url = "github:nix-community/home-manager/";
      # Use the same nixpkgs instance as our system
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ---------------------------------------------------------------------
    # Darwin (macOS) Specific Components
    # ---------------------------------------------------------------------
    
    # nix-darwin: Provides macOS system configuration capabilities
    # Similar to NixOS, but for macOS systems
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew integration for managing macOS packages that aren't in nixpkgs
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Required Homebrew sources - these are marked as non-flakes
    # as they don't follow the flake convention
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
  #
  # This section defines the actual system configurations and how they should
  # be built. It takes the inputs defined above and produces concrete system
  # configurations.
  
  outputs = { self, nixpkgs, home-manager, darwin, nix-homebrew, homebrew-core, 
              homebrew-cask, homebrew-bundle, ... }:
    let
      # ---------------------------------------------------------------------
      # System Definitions
      # ---------------------------------------------------------------------
      #
      # Define all the systems we want to manage. Each system has:
      # - system: The system architecture (e.g., aarch64-darwin)
      # - type: The OS type (darwin or nixos)
      # - hostPath: Path to the host-specific configuration
      # - username: The primary user account
	  # - homeDirectory: The primary users home directory
      
      systems = {
        # Apple Silicon MacBook Configuration
        big-boi = {
          system = "aarch64-darwin";    # Apple Silicon Macs
          type = "darwin";              # macOS system
          hostPath = ./hosts/big-boi;
          username = "jake";
		      homeDirectory = "/Users/jake"; 
        };
		/* 
        # Intel Mac Configuration (e.g., for work)
        work-intel-mac = {
          system = "x86_64-darwin";     # Intel architecture
          type = "darwin";
          hostPath = ./hosts/work-mac;
          username = "jake-work";
        };

        # Linux Gaming Desktop Configuration
        desktop-gaming = {
          system = "x86_64-linux";      # Standard x86_64 Linux
          type = "nixos";
          hostPath = ./hosts/desktop;
          username = "jake";
        };
		*/
      };

      # ---------------------------------------------------------------------
      # Helper Functions
      # ---------------------------------------------------------------------
      
      # Generate attributes for all supported system types
      # This helps us create configurations for each architecture
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"   # Apple Silicon Macs
        "x86_64-darwin"    # Intel Macs
        "x86_64-linux"     # Standard Linux systems
      ];

      # ---------------------------------------------------------------------
      # System Builders
      # ---------------------------------------------------------------------
      
      # Darwin (macOS) System Builder
      # This function creates a complete Darwin system configuration including:
      # - Basic system configuration
      # - Homebrew integration
      # - Home-manager user configuration
      mkDarwinSystem = { system, hostPath, username, homeDirectory, ... }: darwin.lib.darwinSystem {
        inherit system;
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          # Enable Homebrew management through Nix
          nix-homebrew.darwinModules.nix-homebrew
          # Enable home-manager integration
          home-manager.darwinModules.home-manager
          # Import the host-specific configuration
          (import (hostPath + /default.nix) {
            pkgs = nixpkgs.legacyPackages.${system};
            inherit homebrew-core homebrew-cask homebrew-bundle username homeDirectory;
          })
        ];
      };

      # NixOS System Builder
      # Creates a complete NixOS system configuration including:
      # - System services and configuration
      # - Home-manager user configuration
      mkNixosSystem = { system, hostPath, username, homeDirectory, ... }: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Enable home-manager integration
          home-manager.nixosModules.home-manager
          # Import the host-specific configuration
          (import (hostPath + /default.nix) {
            inherit username;
          })
        ];
      };

      # Filter systems by their type for easier management
      darwinSystems = nixpkgs.lib.filterAttrs (n: v: v.type == "darwin") systems;
      nixosSystems = nixpkgs.lib.filterAttrs (n: v: v.type == "nixos") systems;
    in
    {
      # ---------------------------------------------------------------------
      # Output Definitions
      # ---------------------------------------------------------------------
      
      # Define packages for each supported system
      # This combines both Darwin and NixOS packages into a single attribute set
      packages = forAllSystems (system:
        # Darwin system packages
        (builtins.mapAttrs (name: _: self.darwinConfigurations.${name}.system) darwinSystems) //
        # NixOS system packages
        (builtins.mapAttrs (name: _: self.nixosConfigurations.${name}.config.system.build.toplevel) nixosSystems)
      );

      # Final system configurations
      darwinConfigurations = builtins.mapAttrs (name: config: mkDarwinSystem config) darwinSystems;
      nixosConfigurations = builtins.mapAttrs (name: config: mkNixosSystem config) nixosSystems;
    };
}
