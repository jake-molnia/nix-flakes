# homebrew/brews.nix
{ pkgs, ... }:
{
  homebrew.brews = [
    # Add your brew packages here
    "tailscale"      
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
  ];
}
