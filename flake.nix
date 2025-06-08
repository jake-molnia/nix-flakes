{
  description = "system configs for jake_molnia";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs = { self, nixpkgs, home-manager, darwin, nix-homebrew, homebrew-core,
              homebrew-cask, homebrew-bundle, ... }:
    let
      lib = import ./lib { 
        inherit nixpkgs darwin home-manager nix-homebrew 
                homebrew-core homebrew-cask homebrew-bundle; 
      };
      # FIXME: non homemanager features arent being loaded correctly
      systems = {
        big-boi = {
          system = "aarch64-darwin";
          type = "darwin";
          profiles = [ "desktop" ];
          features = {
            programs = {
              neovim = true;
              git = true;
              zsh = true;
              starship = true;
              alacritty = true;
              ssh = true;
            };
            darwin = {
              homebrew = true;
              fonts = true;
            };
          };
          username = "jake";
          homeDirectory = "/Users/jake";
        };
        # TODO: add a good template for extra systems
      };

      # TODO: actually add correct systems here
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-darwin" 
        "x86_64-linux"
      ];

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

      # TODO: implement this (and make sure it works!)
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