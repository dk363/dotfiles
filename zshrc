# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme (see https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
ZSH_THEME="robbyrussell"

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias ll="ls -lh"
alias la="ls -A"
alias gg="gcc -g"
alias ta="tmux a -t"
alias tnew="tmux new -s"

# Paths and environment
export PATH=/home/hsu/.opencode/bin:$PATH
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# Set system language to English
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
