#!/usr/bin/env bash

set -euo pipefail

unamestr=$(uname)

install_tmux_themes() {
  local color="$1"
  git clone https://github.com/jimeh/tmux-themepack.git "$HOME/.tmux-themepack"
  echo "source-file ${HOME}/.tmux-themepack/powerline/default/${color}.tmuxtheme" | tee -a "$HOME/.tmux-theme"
}

go-install() {
  local goroots="/usr/local/goroots"
  local bootstrap_version="1.12.4"
  local bs_tarball="go${bootstrap_version}.darwin-amd64.tar.gz"
  local bs_url="https://dl.google.com/go/${bs_tarball}"
  local bs_sha256="50af1aa6bf783358d68e125c5a72a1ba41fb83cee8f25b58ce59138896730a49"
  local version="$1"


  if shouldBootstrap; then
    (
      cd "$goroots"
      curl -sL "${bs_url}" -o "${bs_tarball}"
      tar xzf "${bs_tarball}"
      rm "${bs_tarball}"
      git clone https://go.googlesource.com/go "${goroots}/go${version}"

      cd "${goroots}/go${version}"
      git checkout "release-branch.go${version}"
      cd "${goroots}/go${version}/src"
      GOROOT_BOOTSTRAP="${goroots}/go" ./make.bash
      rm -rf "${goroots}/go"
    )
  fi
}

shouldBootstrap() {
  local dirCount=$(find /usr/local/goroots -mindepth 1 -maxdepth 1 -type d | wc -l)
  if [[ "$dirCount" -eq 0 ]]; then
    return 0
  fi
  return 1
}

log() {
	echo ">>> $1"
}

if [[ "$unamestr" != "Darwin" ]]; then
	log "This script is for macOS only"
	exit 1
fi

# Install Homebrew
if ! command -v brew >/dev/null; then
	log ">>> Installing Homebrew..."
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install brew bundle deps
if ! brew bundle check >/dev/null; then
	log "Installing brew dependencies from Brewfile..."
	brew bundle
fi

#############
# Setup ZSH #
#############
zshPath=$(command -v zsh)
shellFile="/etc/shells"

# Add Homebrew's zsh to /etc/shells
if ! grep "$zshPath" "$shellFile"; then
	log "Using sudo to add $zshPath to /etc/shells..."
	sudo bash -c "echo \"$zshPath\" | tee -a \"/etc/shells\""
fi

# Switch shell to zsh
if [[ "$SHELL" != "$zshPath" ]]; then
	log "Changing shell for $USER to zsh"
	chsh -s "$zshPath" "$USER"
fi

##################
# Setup Dotfiles #
##################

if [[ ! -f "$HOME/.zshrc" ]]; then
	log "Setting up zshrc..."
	stow zsh
fi

if [[ ! -f "$HOME/.vimrc" ]]; then
	log "Setting up vimrc..."
	stow vim
fi

if [[ ! -d "$HOME/.config/karabiner" ]]; then
	log "Setting up karabiner config..."
	stow karabiner
fi

if [[ ! -d "$HOME/.tmux.conf" ]]; then
	log "Setting up tmux config..."
	stow tmux
fi

#############
# Setup Vim #
#############

# Setup Vim swapfile location
swapfileDir="$HOME/.vim/tmp"
if [[ ! -d "$swapfileDir" ]]; then
  log "Setting up vim swapfile directory"
  mkdir -p "$swapfileDir"
fi

# The following taken from "Modern Vim" - Drew Neil
# See p. 18

VIMCONFIG="$HOME/.vim"
minpacDir="$VIMCONFIG/pack/minpac/opt"

# Install minpac
if [[ ! -d "$minpacDir" ]]; then
  log "Setting up minpac for vim..."
  minpacRepo="https://github.com/k-takata/minpac.git"
  mkdir -p "$minpacDir"
  git clone "$minpacRepo" "$minpacDir/minpac"
fi

############
# Setup Go #
############

goroots="/usr/local/goroots"

log "Setting up Go..."

# Create go install management group:
if ! sudo dseditgroup -o read gophers >/dev/null; then
  log "Creating gophers group..."
  sudo dseditgroup -o create gophers

  # Add current user to gophers
  sudo dseditgroup -o edit -a "$USER" -t user gophers
fi

if [[ ! -d "${goroots}" ]]; then
  log "Creating goroots..."
  sudo mkdir -p "${goroots}"
  sudo chmod g+wx "${goroots}"
  sudo chgrp -hR gophers "${goroots}"

  set -x
  go-install 1.12
  set +x
fi

##############
# Setup tmux #
##############

# Setup tmux themes
if [[ ! -d "$HOME/.tmux-themepack" ]]; then
  read -p "Enter desired powerline color:" color
  install_tmux_themes "$color"
fi
