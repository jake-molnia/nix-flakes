# system.nix
# Comprehensive system configuration for Darwin (macOS)
{ pkgs, ... }:
{
  # =============================================================================
  # Core System Services
  # =============================================================================

  # Enable the Nix daemon service
  # services.nix-daemon.enable = true;

  # Enable zsh as default shell (default on mac)
  programs.zsh.enable = true;

  # System state version (increment only when necessary)
  system.stateVersion = 6;

  system.primaryUser = "jake";

  # Configure the primary user account
  users.users.jake = {
    name = "jake";
    home = "/Users/jake";
  };

  # =============================================================================
  # Nix Package Manager Configuration
  # =============================================================================
  nix = {
    package = pkgs.nix;

    # Security and binary cache settings
    settings = {
      # Users allowed to perform privileged Nix operations
      trusted-users = [ "@admin" "jake" ];

      # Binary cache servers for faster package downloads
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];

      # Public keys for verifying binary caches
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };

    # Automatic garbage collection configuration
    gc = {
      automatic = true;
      # Run GC weekly on Sunday at 2:00 AM
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      # Remove generations older than 30 days
      options = "--delete-older-than 30d";
    };

    # Enable experimental features
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Disable NixPath verification (needed for flakes)
  system.checks.verifyNixPath = false;

  # =============================================================================
  # macOS System Preferences
  # =============================================================================
  system.defaults = {
    # Global Domain Settings (System-wide preferences)
    NSGlobalDomain = {
      # File System Visibility
      AppleShowAllExtensions = true;                          # Show all file extensions
      AppleShowAllFiles = true;                               # Show hidden files

      # Keyboard Settings
      ApplePressAndHoldEnabled = false;                       # Disable press-and-hold for keys
      KeyRepeat = 2;                                          # Key repeat rate (2 = fastest, 120 = slowest)
      InitialKeyRepeat = 15;                                  # Delay before key repeat (15 = shortest)

      # Regional Settings
      AppleTemperatureUnit = "Celsius";                       # Use Celsius for temperature
      AppleICUForce24HourTime = true;                         # Use 24-hour clock format

      # UI/UX Settings
      NSAutomaticWindowAnimationsEnabled = false;             # Disable window animations
      NSTableViewDefaultSizeMode = 1;                         # Finder sidebar icon size (1 = smallest)
      PMPrintingExpandedStateForPrint = true;                 # Expand print panel by default
      _HIHideMenuBar = false;                                 # Show menu bar

      # Input Device Settings
      "com.apple.mouse.tapBehavior" = 1;                      # Enable tap to click
      "com.apple.swipescrolldirection" = true;                # Natural scrolling direction

      # Sound Settings
      "com.apple.sound.beep.volume" = 0.0;                    # System beep volume
      "com.apple.sound.beep.feedback" = 0;                    # Disable audio feedback

      # Theme
      AppleInterfaceStyle = "Dark";                           # Enable dark mode
    };

    # Dock Configuration
    dock = {
      autohide = true;                                        # Automatically hide the dock
      show-recents = false;                                   # Don't show recent applications
      launchanim = true;                                      # Enable launch animation
      orientation = "left";                                   # Place dock on the left side
      tilesize = 1;                                           # Smallest possible dock icons
    };

    # Finder Preferences
    finder = {
      _FXShowPosixPathInTitle = false;                        # Hide POSIX path in window title
      FXDefaultSearchScope = "SCcf";                          # Search in current folder by default
      FXEnableExtensionChangeWarning = false;                 # Don't warn when changing extensions
      FXPreferredViewStyle = "clmv";                          # Use column view by default
      NewWindowTarget = "Home";                               # New windows open to home folder
      ShowPathbar = true;                                     # Show path bar in Finder
    };

    # Trackpad Settings
    trackpad = {
      Clicking = true;                                        # Enable tap to click
      TrackpadThreeFingerDrag = true;                         # Enable three-finger drag
    };

    # Menu Bar Clock Settings
    menuExtraClock = {
      Show24Hour = true;                                      # Use 24-hour format
      ShowDate = 2;                                           # Show date in menu bar
      ShowDayOfMonth = false;                                 # Don't show day of month
      ShowDayOfWeek = false;                                  # Don't show day of week
      ShowSeconds = false;                                    # Don't show seconds
    };

    # System Update Settings
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;   # Auto-install updates

    # Window Management
    WindowManager.EnableStandardClickToShowDesktop = false;   # Disable click to show desktop
  };

  # =============================================================================
  # Additional System Settings
  # =============================================================================

  # Disable startup sound
  system.startup.chime = false;

  # Enable Touch ID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = with pkgs; [
] ++ (import ../../../packages/core.nix { inherit pkgs; });

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

}
