# ==========================================
# Oh My Zsh Configuration
# ==========================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# ==========================================
# Plugins
# ==========================================

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# ==========================================
# Aliases
# ==========================================

alias ll="ls -lh"
alias la="ls -A"

alias gg="gcc -g"

alias ta="tmux a -t"
alias tnew="tmux new -s"

# ==========================================
# PATH
# ==========================================

export PATH="$HOME/.local/bin:$PATH"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
