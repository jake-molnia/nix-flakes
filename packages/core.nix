{ pkgs }:

with pkgs; [
  # Terminal Essentials
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
  devenv # Development environments
  docker
  docker-compose
  just
  # Terminal Applications
  zed # Modern editor

  # Development Dependencies
  mpdecimal
  openssl
  readline
  sqlite
  xz

  # CLI Tools from Homebrew
  tailscale # VPN service
  # thefuck # Corrects previous console command
  zsh-autosuggestions # Command suggestions
  zsh-syntax-highlighting # Syntax highlighting
  diff-so-fancy

  # GUI Applications
  vscode # Code editor
  obsidian # Note-taking app
  spotify # Music streaming
  discord # Communication platform

  # Python Development
  python313 # Python 3.13
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
  neovim # Text editor
]
