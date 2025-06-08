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
        compression = 9;
        whitespace = "error";
        preloadindex = true;
        editor = "nvim";
        autocrlf = "input";
      };
      advice = {
        addEmptyPathspec = false;
        pushNonFastForward = false;
        statusHints = false;
      };
      color = {
        diff = {
          meta = "black bold";
          frag = "magenta";
          context = "white";
          whitespace = "yellow reverse";
          old = "red";
        };
      };
      pull.rebase = true;
      rebase.autoStash = true;
      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };
      interactive = {
        diffFilter = "diff-so-fancy --patch";
        singlekey = true;
      };
      url = {
        "git@github.com:codingjerk/".insteadOf = "cj:";
        "git@github.com:".insteadOf = "gh:";
      };
      commit = {
        template = "~/.config/git/commit-template";
      };
    };
  };
  xdg.configFile."git/commit-template".text = builtins.readFile ./config/commit-template;
}