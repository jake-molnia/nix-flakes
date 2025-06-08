# lib/mkHost.nix
# Host builder functions that handle profiles and features

{ nixpkgs, darwin, home-manager, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle }:

let
  utils = import ./utils.nix { inherit nixpkgs; };

  # Build home-manager configuration based on profiles and features
  mkHomeManagerConfig = { system, type, profiles, features, username, homeDirectory }:
    { pkgs, ... }: {
      home.stateVersion = "23.11";
      
      imports = 
        # Import profile modules (if they have home-manager config)
        (map (profile: ../profiles/${profile}.nix) profiles) ++
        # Import feature modules (home-manager programs) based on enabled features
        (builtins.filter (x: x != null) (nixpkgs.lib.mapAttrsToList (name: enabled: 
          if enabled then ../modules/home-manager/programs/${name} else null
        ) features));
      
      _module.args = { inherit username homeDirectory; };
    };

  # Build system modules based on configuration (SYSTEM LEVEL ONLY)
  mkSystemModules = { system, type, profiles, features, username, homeDirectory }:
    let
      # Auto-load base modules based on system type
      baseModules = {
        darwin = [
          ../modules/darwin/system      # Always load for any Darwin system
          ../modules/darwin/homebrew    # Always available (profile controls usage)
        ];
        nixos = [
          ../modules/nixos/system
          # Add nixos modules here when you create them
        ];
      };

      # Profile-based modules (these modify behavior of base modules)
      profileModules = map (profile: ../profiles/${profile}.nix) profiles;
      
      # NOTE: Feature modules are handled in mkHomeManagerConfig, not here
      
    in (baseModules.${type} or []) ++ profileModules;

in {
  # Darwin System Builder
  mkDarwinSystem = { system, type, profiles ? [], features ? {}, username, homeDirectory, ... }: 
    darwin.lib.darwinSystem {
      inherit system;
      pkgs = utils.nixpkgsWithConfig system;
      
      modules = [
        # Core nix-darwin modules
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        
        # System configuration modules (auto-loaded based on type)
      ] ++ (mkSystemModules { inherit system type profiles features username homeDirectory; }) ++ [
        
        # Home-manager configuration
        {
          home-manager.users.${username} = mkHomeManagerConfig {
            inherit system type profiles features username homeDirectory;
          };
          
          # Pass through our configuration parameters
          _module.args = { 
            inherit homebrew-core homebrew-cask homebrew-bundle username homeDirectory;
          };
        }
      ];
    };

  # NixOS System Builder  
  mkNixosSystem = { system, type, profiles ? [], features ? {}, username, homeDirectory, ... }: 
    nixpkgs.lib.nixosSystem {
      inherit system;
      
      modules = [
        # Core home-manager module
        home-manager.nixosModules.home-manager
        
        # System configuration modules (auto-loaded based on type)
      ] ++ (mkSystemModules { inherit system type profiles features username homeDirectory; }) ++ [
        
        # Home-manager configuration
        {
          home-manager.users.${username} = mkHomeManagerConfig {
            inherit system type profiles features username homeDirectory;
          };
          
          # Pass through configuration parameters
          _module.args = { inherit username homeDirectory; };
        }
      ];
    };
}