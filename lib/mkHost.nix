# lib/mkHost.nix

{ nixpkgs, darwin, home-manager, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle }:

let
  utils = import ./utils.nix { inherit nixpkgs; };

  mkHomeManagerConfig = { system, type, profiles, features, username, homeDirectory }:
    { pkgs, ... }: {
      # TODO: look at this number 
      home.stateVersion = "23.11";
      
      imports = 
        (map (profile: ../profiles/${profile}.nix) profiles) ++
        (builtins.filter (x: x != null) (nixpkgs.lib.mapAttrsToList (name: enabled: 
          if enabled then ../modules/home-manager/programs/${name} else null
        ) (features.programs or {})));
      
      _module.args = { inherit username homeDirectory; };
    };

  mkSystemModules = { system, type, profiles, features, username, homeDirectory }:
    let
      baseModules = {
        darwin = [
          # FIXME: this will be split into multiple files and then this line is broken
          ../modules/darwin/system      
        ] ++ (if (features.darwin.homebrew or false) 
              then [ ../modules/darwin/homebrew ] 
              else []);
        nixos = [
          ../modules/nixos/system
        ];
      };

      profileModules = map (profile: ../profiles/${profile}.nix) profiles;
      
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