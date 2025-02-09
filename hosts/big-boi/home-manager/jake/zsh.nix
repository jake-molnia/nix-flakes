# home-manager/zsh.nix
{ pkgs, ... }:
{
    # For importing existing dotfiles
    #home.file.".zshrc".source = ./files/.zshrc;
    
    # Or configure directly in nix:
    programs.zsh = {
      enable = true;
      autocd = false;
      enableCompletion = true;

      initExtraFirst = ''
        # Path Configuration
        export PATH="$PATH:/Users/jake/.local/bin"
        export PATH="$PATH:/usr/local/texlive/2024/bin/universal-darwin"
        export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

        # Theme Configuration
        ZSH_THEME="" # Disabled to use Starship instead

        # Plugin Configuration
        plugins=(
            git
            ssh
        )

        source $ZSH/oh-my-zsh.sh
        source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

        # Custom Aliases
        alias code="code -n"
        alias cat="bat"
        alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

        # Bat Theme Configuration
        export BAT_THEME="gruvbox-dark"

        # Initialize Starship
        eval "$(starship init zsh)"

        # >>> mamba initialize >>>
        # !! Contents within this block are managed by 'mamba init' !!
        export MAMBA_EXE='/Users/jake/.nix-profile/bin/micromamba';
        export MAMBA_ROOT_PREFIX='/Users/jake/micromamba';
        __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__mamba_setup"
        else
            alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
        fi
        unset __mamba_setup
        # <<< mamba initialize <<<
      '';
  };

}