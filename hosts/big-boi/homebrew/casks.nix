# homebrew/casks.nix
{ pkgs, ... }:
{
  homebrew.casks = [
    # macOS-specific applications
    "alt-tab"              # Window switcher
    "arc"                  # Modern web browser
    "arduino-ide"          # Arduino development
    "battery-buddy"        # Battery health monitor
    "monitorcontrol"       # Display management
    "copilot"              # GitHub Copilot app
    "git-credential-manager" # Git authentication
    "itsycal"              # Menu bar calendar
    "logi-options+"        # Logitech peripheral manager
    "maccy"                # Clipboard manager
    "microsoft-teams"      # Microsoft Teams
    "raycast"              # Spotlight replacement
    "rectangle"            # Window management
    "slack"                # Business communication
    "smoothscroll"         # Smooth scrolling utility
    "steam"                # Gaming platform
    "teamviewer"           # Remote desktop
    "tempbox"              # Temporary email generator
    "utm"                  # Virtualization
    "whatsapp"             # Messaging app
    "zoom"                 # Video conferencing
    "obs"
    "ghostty"
  ];
}
