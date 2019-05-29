#!/usr/bin/env bash

set -euo pipefail

unamestr=$(uname)

setupSSH() {
  mkdir "$HOME/.ssh"
  ssh-keygen -t rsa
}

setHostname() {
  local name
  name=$1
  sudo scutil --set LocalHostName "$name"
  sudo scutil --set ComputerName "$name"
  sudo dscacheutil -flushcache
}

install_tmux_themes() {
  local color="$1"
  git clone https://github.com/jimeh/tmux-themepack.git "$HOME/.tmux-themepack"
  echo "source-file ${HOME}/.tmux-themepack/powerline/default/${color}.tmuxtheme" | tee -a "$HOME/.tmux-theme"
}

setupVim() {
  set -x
  # subshell
  (
    mkdir -p "${HOME}/.vim/pack/minpac/opt"

    (
      cd "${HOME}/.vim/pack/minpac/opt"
      git clone https://github.com/k-takata/minpac.git
    )

    vim -V -es -i NONE "+source $HOME/.vimrc" "+call minpac#update()" "+q"
    # install fzf binary
    "${HOME}"/.vim/pack/minpac/start/fzf/install --bin
  )
  set +x
}

go-install() {
  local goroots="/usr/local/goroots"
  local bootstrap_version="1.12.4"
  local bs_tarball="go${bootstrap_version}.darwin-amd64.tar.gz"
  local bs_url="https://dl.google.com/go/${bs_tarball}"
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

globalEnvRC() {
  cat <<EOF
PATH_add /usr/local/go-global/${1}/bin
PATH_add /usr/local/goroots/go${1}/bin
export GO111MODULE=off
layout go
EOF
}

initGoGlobal() {
  local version

  version="$1"

  log "Creating go${version} global directory..."
  sudo mkdir "/usr/local/go-global"
  sudo chmod g+wx "/usr/local/go-global"
  sudo chgrp -hR gophers "/usr/local/go-global"

  mkdir "/usr/local/go-global/${version}"
  globalEnvRC "${version}" | tee -a "/usr/local/go-global/${version}/.envrc"

  # Install tools:
  (
  cd "/usr/local/go-global/${version}"
  direnv allow
  eval "$(direnv export bash)"
  vim -es "+packadd vim-go" "+GoInstallBinaries" "+q"

  # install one-off tools
  tools=(
    "golang.org/x/tools/cmd/gopls"
    "github.com/smartystreets/goconvey"
  )
  for t in "${tools[@]}"
  do
    echo "Installing ${t##*/}"
    go get -u "$t"
  done
  )
}

shouldBootstrap() {
  local dirCount
  dirCount=$(find /usr/local/goroots -mindepth 1 -maxdepth 1 -type d | wc -l)
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

if [[ ! -d "$HOME/.vim" ]]; then
  log "Setting up vim..."
  setupVim
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

  go-install 1.12
fi

if [[ ! -d "/usr/local/go-global/1.12" ]]; then
  log "Go 1.12 global directory missing. Setting up..."
  initGoGlobal 1.12
fi

if [[ ! -d "$HOME/.ssh" ]]; then
  stow ssh
  setupSSH
fi

##############
# Setup tmux #
##############

# Setup tmux themes
if [[ ! -d "$HOME/.tmux-themepack" ]]; then
  read -rp "Enter desired powerline color:" color
  install_tmux_themes "$color"
fi

################
# Set Hostname #
################

targetHostname="proteus"
currentHostname=$(scutil --get LocalHostName)
if [[ "$currentHostname" != "$targetHostname" ]]; then
  log "Setting hostname to $targetHostname"
  setHostname "$targetHostname"
fi
