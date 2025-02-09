# home-manager/git.nix
{ pkgs, ... }:
{
    programs.git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = "Jacob Molnia";
    userEmail = "jrmolnia@wpi.edu";
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
	    editor = "vim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };
}