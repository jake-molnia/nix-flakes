# TODO:
# - genralize this to work for all setups
# - allow bootstrapping a system

default:
    @just --list

build:
    nix build .#darwinConfigurations.big-boi.system

switch:
    nix build .#darwinConfigurations.big-boi.system
    ./result/sw/bin/darwin-rebuild switch --flake .#big-boi

update:
    nix flake update

check:
    nix flake check --all-systems

clean:
    sudo nix-collect-garbage -d
    rm -f result*