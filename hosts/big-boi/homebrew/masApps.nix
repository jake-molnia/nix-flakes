# homebrew/masApps.nix

# These app IDs are from using the mas CLI app
# mas = mac app store
# https://github.com/mas-cli/mas
#
# $ nix shell nixpkgs#mas
# $ mas search <app name>
#
# If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
# you may receive an error message "Redownload Unavailable with This Apple ID".
# This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)


# Notice due to the nature of these Apps you will need to sign into the app store
{ pkgs, ... }:
{
  homebrew.masApps = {
    # Add more masApps here
    "Bitwarden" = 1352778147;                 	# Password manager
    "Commander One" = 1035236694;            		# Dual-pane file manager
    "Hidden Bar" = 1452453066;                	# Hide menu bar items
    "Microsoft Remote Desktop" = 1295203466;   	# Remote access to Windows PCs
    "Omnivore" = 1564031042;                  	# Read-it-later and web content saving
    "TickTick" = 966085870;                   	# Task management and to-do lists
    "XCode" = 497799835;                     		# Apple's IDE for iOS/macOS development
    "Goodnotes" = 1444383602;                 	# Digital note-taking app
    "Amphetamine" = 937984704; 
  };
}
