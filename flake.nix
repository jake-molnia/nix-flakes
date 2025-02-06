{
  description = "My first nix flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # newest version as of may 2023, probably needs to get updated in november
      home-manager.url = "github:nix-community/home-manager/"; # ...
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
      darwin.url = "github:lnl7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
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
	outputs = { self, nixpkgs, home-manager, darwin, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, ...}: {

	  darwinConfigurations."jake-vms-Virtual-Machine" = darwin.lib.darwinSystem {
	  # you can have multiple darwinConfigurations per flake, one per hostname

	    system = "aarch64-darwin"; # "x86_64-darwin" if you're using a pre M1 mac
	    modules = [ 
		nix-homebrew.darwinModules.nix-homebrew
		{
		  nix-homebrew = {
		    # Install Homebrew under the default prefix
		    enable = true;

		    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
		    enableRosetta = true;

		    # User owning the Homebrew prefix
		    user = "jake-vm";

		    # Optional: Declarative tap management
		    taps = {
		      "homebrew/homebrew-core" = homebrew-core;
		      "homebrew/homebrew-cask" = homebrew-cask;
		      "homebrew/homebrew-bundle" = homebrew-bundle;
		    };

		    # Optional: Enable fully-declarative tap management
		    #
		    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
		    mutableTaps = false;
		  };
		}
		home-manager.darwinModules.home-manager
		./hosts/jake-vms-Virtual-Machine/default.nix ]; # will be important later
	  };
	};
}
