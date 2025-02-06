# hosts/jake-vms-Virtural-Machine/default.nix

{ pkgs, ... }:
{
	# Make sure the nix daemon always runs
	services.nix-daemon.enable = true;

	# if you use zsh (the default on new macOS installations),
	# you'll need to enable this so nix-darwin creates a zshrc sourcing needed environment changes
	programs.zsh.enable = true;

	homebrew = {
		enable = true;

		# updates homebrew packages on activation,
		onActivation = {
			autoUpdate = true;
		};

		# can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
		casks = [
			"visual-studio-code"  
		];
	};

	# This is used for versioning in nix (I am not entirely sure how this works yet)
	system.stateVersion = 6;
	
	# Home manager needs this to be configured
	users.users.jake-vm= {
		name = "jake-vm";
		home = "/Users/jake-vm";
	};

	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.users.jake-vm= { pkgs, ... }: {

		# Home Manager needs a bit of information about you and the
		# paths it should manage.
		home.username = "jake-vm";
		home.homeDirectory = "/Users/jake-vm";

		# This value determines the Home Manager release that your
		# configuration is compatible with. This helps avoid breakage
		# when a new Home Manager release introduces backwards
		# incompatible changes.
		#
		# You can update Home Manager without changing this value. See
		# the Home Manager release notes for a list of state version
		# changes in each release.
		home.stateVersion = "23.05"; 
		
		# Let Home Manager install and manage itself.
		programs.home-manager.enable = true;
	};
}

