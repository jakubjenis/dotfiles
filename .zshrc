# move prompt to the bottom
#print ${(pl:$LINES::\n:):-}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  dotnet
  gitfast
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias editconfig="code ~/.zshrc"
alias reload='source ~/.zshrc'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------ FZF -----------
# Set up fzf key bindings and fuzzy completion
export FZF_TMUX=1
export FZF_TMUX_OPTS='-p80%,60%'
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--height 100% --layout=default \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

fzf() {
  command fzf-tmux --reverse -p 80% "$@"
}

fzf-tmux() {
  command fzf-tmux --reverse -p 80% "$@"
}

# -- Use fd instead of fzf --
# # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# # - The first argument to the function ($1) is the base path to start traversal
# # - See the source code (completion.{bash,zsh}) for the details.
# _fzf_compgen_path() {
#   fd --hidden --exclude .git . "$1"
# }

# # Use fd to generate the list for directory completion
# _fzf_compgen_dir() {
#   fd --type=d --hidden --exclude .git . "$1"
# }

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

alias ff='$(fd . ~/repos --min-depth 1 --max-depth 2 --type d | fzf --preview "eza --tree --level=1 --color=always {} | head -200")'
alias ss='sesh connect $(sesh list | fzf)'
alias v='fd . --type f --hidden --exclude .git | fzf --preview "bat -n --color=always --line-range :500 {}"| xargs nvim'
alias c='fd . --type f --hidden --exclude .git | fzf --preview "bat -n --color=always --line-range :500 {}" | xargs code'

eval "$(fzf --zsh)"

# ------------ Zoxide -------------
alias cd='z'

# ------------ Eza -----------
if [ -x "$(command -v eza)" ]; then
    alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
    alias la="eza --long --all --group --color=always --long --git --icons=always"
fi

# ------------ Bat -----------
if [ -x "$(command -v bat)" ]; then
    alias cat="bat"
fi

# export BAT_THEME="Visual Studio Dark+"
export BAT_THEME="Catppuccin Mocha"

# preview themes
# bat --list-themes | fzf --preview="bat --theme={} --color=always /path/to/file"

# rebuild cache after installing theme
# bat cache --build

# ------------ TheFuck -------------
# Setup up fuck as alias for thefuck
eval $(thefuck --alias)

# ------------ LazyGit --------------
alias gg='lazygit'

# ------------- MC ----------------
alias mc='mc -u'

# ------------ Terraform --------------
alias tf='terraform'
alias tg='terragrunt'

PATH=~/.console-ninja/.bin:$PATH
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
