# My Nix flake Configuration

Personal system configuration using Nix flakes for macOS (Darwin) with home-manager integration.

## Features

- **Cross-platform support**: Darwin (macOS) with potential for NixOS
- **Declarative system management**: System preferences, packages, and dotfiles
- **Homebrew integration**: Seamless management of macOS-specific applications
- **Home-manager**: User environment and dotfile management
- **Modern development setup**: Neovim with LazyVim, Zsh with Starship prompt

## Quick Start

1. **Install Nix** with flakes enabled:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Clone this repository**:
   ```bash
   git clone <your-repo-url> ~/.config/nix-config
   cd ~/.config/nix-config
   ```

3. **Build and apply** the configuration:
   ```bash
   nix build .#darwinConfigurations.big-boi.system
   ./result/sw/bin/darwin-rebuild switch --flake .
   ```

## Configuration Overview

- **System**: macOS preferences, dock, finder, and keyboard settings
- **Packages**: Development tools, terminal utilities, and applications
- **Shell**: Zsh with Oh My Zsh, Starship prompt, and useful aliases
- **Editor**: Neovim with LazyVim and Gruvbox theme
- **Terminal**: Alacritty with Gruvbox colors and Hack Nerd Font

## Customization

To adapt this configuration for your own use:

1. Update the system definition in `flake.nix`
2. Modify user-specific settings in `hosts/big-boi/home-manager/jake/`
3. Adjust package selections in `hosts/big-boi/packages.nix`
4. Customize homebrew apps in `hosts/big-boi/homebrew/`

## Structure

```
├── flake.nix              # Main flake configuration
├── hosts/
│   ├── big-boi/           # Primary system configuration
│   └── template/          # Template for new systems
└── flake.lock             # Pinned dependencies
```

## Updates

Update all inputs and rebuild:
```bash
nix flake update
darwin-rebuild switch --flake .
```