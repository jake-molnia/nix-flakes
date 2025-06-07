# lib/mkHost.nix
# Host builder functions that handle profiles and features

{ nixpkgs, darwin, home-manager, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle }:

let
  utils = import ./utils.nix { inherit nixpkgs; };

  # Build home-manager configuration based on profiles and features
  mkHomeManagerConfig = { system, profiles, features, username, homeDirectory }:
    { pkgs, ... }: {
      home.stateVersion = "23.11";
      
      imports = 
        # Import profile modules
        (map (profile: ../profiles/${profile}.nix) profiles) ++
        # Import feature modules based on enabled features
        (builtins.filter (x: x != null) (nixpkgs.lib.mapAttrsToList (name: enabled: 
          if enabled then ../modules/home-manager/programs/${name} else null
        ) features));
      
      _module.args = { inherit username homeDirectory; };
    };

  # Build system modules based on configuration
  mkSystemModules = { system, profiles, features, username, homeDirectory }:
    let
      # Base system modules
      baseModules = if nixpkgs.lib.hasSuffix "darwin" system 
        then [ ../modules/darwin/system ]
        else [ ../modules/nixos/system ];
      
      # Optional modules based on features
      optionalModules = nixpkgs.lib.optionals (features.homebrew or false) [
        ../modules/darwin/homebrew
      ];
      
    in baseModules ++ optionalModules;

in {
  # Darwin System Builder
  mkDarwinSystem = { system, profiles ? [], features ? {}, username, homeDirectory, ... }: 
    darwin.lib.darwinSystem {
      inherit system;
      pkgs = utils.nixpkgsWithConfig system;
      
      modules = [
        # Core nix-darwin modules
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        
        # System configuration modules
      ] ++ (mkSystemModules { inherit system profiles features username homeDirectory; }) ++ [
        
        # Home-manager configuration
        {
          home-manager.users.${username} = mkHomeManagerConfig {
            inherit system profiles features username homeDirectory;
          };
          
          # Pass through our configuration parameters
          _module.args = { 
            inherit homebrew-core homebrew-cask homebrew-bundle username homeDirectory;
          };
        }
      ];
    };

  # NixOS System Builder  
  mkNixosSystem = { system, profiles ? [], features ? {}, username, homeDirectory, ... }: 
    nixpkgs.lib.nixosSystem {
      inherit system;
      
      modules = [
        # Core home-manager module
        home-manager.nixosModules.home-manager
        
        # System configuration modules  
      ] ++ (mkSystemModules { inherit system profiles features username homeDirectory; }) ++ [
        
        # Home-manager configuration
        {
          home-manager.users.${username} = mkHomeManagerConfig {
            inherit system profiles features username homeDirectory;
          };
          
          # Pass through configuration parameters
          _module.args = { inherit username homeDirectory; };
        }
      ];
    };
}