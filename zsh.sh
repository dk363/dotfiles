#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC_SOURCE="${DOTFILES_DIR}/zshrc"
ZSHRC_TARGET="${HOME}/.zshrc"
OH_MY_ZSH_DIR="${HOME}/.oh-my-zsh"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-${OH_MY_ZSH_DIR}/custom}"

log() {
  printf "%s\n" "$*"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

install_packages() {
  if have_cmd apt-get; then
    sudo apt-get update
    sudo apt-get install -y zsh git curl
    return
  fi

  if have_cmd dnf; then
    sudo dnf install -y zsh git curl
    return
  fi

  if have_cmd pacman; then
    sudo pacman -Sy --noconfirm zsh git curl
    return
  fi

  if have_cmd zypper; then
    sudo zypper install -y zsh git curl
    return
  fi

  if have_cmd brew; then
    brew install zsh git curl
    return
  fi

  log "No supported package manager found. Install zsh, git, and curl manually."
}

install_oh_my_zsh() {
  if [[ -d "${OH_MY_ZSH_DIR}" ]]; then
    log "oh-my-zsh already exists at ${OH_MY_ZSH_DIR}"
    return
  fi

  git clone https://github.com/ohmyzsh/ohmyzsh.git "${OH_MY_ZSH_DIR}"
}

install_plugins() {
  mkdir -p "${ZSH_CUSTOM_DIR}/plugins"

  if [[ ! -d "${ZSH_CUSTOM_DIR}/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      "${ZSH_CUSTOM_DIR}/plugins/zsh-syntax-highlighting"
  fi

  if [[ ! -d "${ZSH_CUSTOM_DIR}/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git \
      "${ZSH_CUSTOM_DIR}/plugins/zsh-autosuggestions"
  fi
}

link_zshrc() {
  if [[ ! -f "${ZSHRC_SOURCE}" ]]; then
    log "Missing ${ZSHRC_SOURCE}."
    exit 1
  fi

  if [[ -L "${ZSHRC_TARGET}" ]]; then
    local target
    target="$(readlink "${ZSHRC_TARGET}")"
    if [[ "${target}" == "${ZSHRC_SOURCE}" ]]; then
      log "${ZSHRC_TARGET} already points to ${ZSHRC_SOURCE}"
      return
    fi
  fi

  if [[ -e "${ZSHRC_TARGET}" ]]; then
    local backup
    backup="${ZSHRC_TARGET}.bak-$(date +%Y%m%d%H%M%S)"
    mv "${ZSHRC_TARGET}" "${backup}"
    log "Backed up existing .zshrc to ${backup}"
  fi

  ln -s "${ZSHRC_SOURCE}" "${ZSHRC_TARGET}"
  log "Linked ${ZSHRC_TARGET} -> ${ZSHRC_SOURCE}"
}

ensure_default_shell() {
  if ! have_cmd zsh; then
    log "zsh not found after install step."
    return
  fi

  if [[ "${SHELL:-}" == "$(command -v zsh)" ]]; then
    return
  fi

  if have_cmd chsh; then
    chsh -s "$(command -v zsh)" "${USER}"
    log "Default shell set to zsh. You may need to log out and back in."
    return
  fi

  log "chsh not available. Set your default shell manually to $(command -v zsh)."
}

main() {
  install_packages
  install_oh_my_zsh
  install_plugins
  link_zshrc
  ensure_default_shell
  log "Done. Start a new terminal or run: zsh"
}

main "$@"
