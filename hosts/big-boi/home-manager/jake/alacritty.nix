# home-manager/alacritty.nix
{ pkgs, ... }: {
    programs.alacritty = {
    enable = true;
    settings = {
      cursor = {
        style = "Beam";
        thickness = 0.15;
      };

      window = {
        opacity = 1.0;
        padding = {
          x = 12;
          y = 12;
        };
      };

      font = {
        normal = {
          family = "Hack Nerd Font";
        };
        size = 12;
      };

      colors = {
        primary = {
          background = "0x282828"; # Gruvbox dark background
          foreground = "0xebdbb2"; # Gruvbox light foreground
        };

        normal = {
          black = "0x282828";   # Dark background
          red = "0xcc241d";     # Gruvbox red
          green = "0x98971a";   # Gruvbox green
          yellow = "0xd79921";  # Gruvbox yellow
          blue = "0x458588";    # Gruvbox blue
          magenta = "0xb16286"; # Gruvbox purple
          cyan = "0x689d6a";    # Gruvbox aqua
          white = "0xa89984";   # Gruvbox light gray
        };

        bright = {
          black = "0x928374";   # Gruvbox gray
          red = "0xfb4934";     # Bright red
          green = "0xb8bb26";   # Bright green
          yellow = "0xfabd2f";  # Bright yellow
          blue = "0x83a598";    # Bright blue
          magenta = "0xd3869b"; # Bright purple
          cyan = "0x8ec07c";    # Bright aqua
          white = "0xebdbb2";   # Bright foreground
        };
      };
    };
  };
}