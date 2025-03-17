{ pkgs }:

with pkgs; [
  # Terminal Essentials
  alacritty # Modern terminal emulator
  starship # Cross-shell prompt
  tmux # Terminal multiplexer

  # Shell Utilities
  eza # Modern replacement for ls
  bat # Better cat with syntax highlighting
  btop # System monitor
  htop # Process viewer
  ripgrep # Fast text search
  tree # Directory structure viewer
  ranger # Terminal file manager
  nmap

  # Development Tools
  #vscode       # Code editor
  devenv # Development environments
  docker
  docker-compose

  # Python Development
  python3
  pipx # Python application installer
  micromamba # Lightweight conda alternative
  jupyter # Interactive computing
  cargo

  # File Operations
  wget # File downloader
  zip
  unzip
  #unrar

  # Shell Customization
  oh-my-zsh # Zsh configuration framework
  tlrc # Terminal configuration tool
  neovim # Text editor (commented but working)
]
