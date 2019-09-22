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

installGRPC() {
  local version=$1
  local downloadDir=$2

  (
    cd "$downloadDir"
    sudo bash -c "curl -sSL \"https://github.com/protocolbuffers/protobuf/releases/download/v${version}/protoc-${version}-osx-x86_64.zip\" > \"protoc-${version}-osx-x86_64.zip\""
    sudo unzip "protoc-${version}-osx-x86_64.zip" -d "${version}"
  )
}

installGHZ() {
  local version=$1
  local downloadDir=$2

  (
    cd "$downloadDir"
    sudo bash -c "curl -sSL \"https://github.com/bojand/ghz/releases/download/v${version}/ghz_${version}_Darwin_x86_64.tar.gz\" > \"ghz_${version}_Darwin_x86_64.tar.gz\""
    sudo mkdir -p "${version}/bin"
    sudo tar xzf "ghz_${version}_Darwin_x86_64.tar.gz" -C "${version}/bin"
  )
}

installHypriotFlash() {
  local version=$1
  local downloadDir=$2

  (
    cd "$downloadDir"
    sudo mkdir -p "${version}/bin"
    sudo bash -c "curl -sSL \"https://github.com/hypriot/flash/releases/download/${version}/flash\" > \"${version}/bin/flash\""
    sudo chmod ugo+x "${version}/bin/flash"
  )
}

go-install() {
  local goroots="/usr/local/goroots"
  local bootstrap_version="1.12.4"
  local bs_tarball="go${bootstrap_version}.darwin-amd64.tar.gz"
  local bs_url="https://dl.google.com/go/${bs_tarball}"
  local version="$1"


  # originally, this called shouldBootstrap, which would determine if this
  # should pull down the bootstrap tarball. Instead, this always does this.
  # Ideally, for each new version of Go, we'd just use git worktrees. Really,
  # this is stretching what belongs in a bash script.
  if true; then
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

  tools=(
    "golang.org/x/tools/cmd/gopls"
    "github.com/smartystreets/goconvey"
    "github.com/gogo/protobuf/proto"
    "github.com/gogo/protobuf/protoc-gen-gogo"
    "github.com/gogo/protobuf/gogoproto"
    "github.com/fullstorydev/grpcui"
    "github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway"
    "github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger"
    "github.com/gobuffalo/packr/v2/packr2"
  )

  version="$1"

  if [[ ! -d "/usr/local/go-global" ]]; then
    log "Creating go${version} global directory..."
    sudo mkdir "/usr/local/go-global"
    sudo chmod g+wx "/usr/local/go-global"
    sudo chgrp -hR gophers "/usr/local/go-global"
  fi

  mkdir "/usr/local/go-global/${version}"
  globalEnvRC "${version}" | tee -a "/usr/local/go-global/${version}/.envrc"

  # Install tools:
  (
  cd "/usr/local/go-global/${version}"
  direnv allow
  eval "$(direnv export bash)"

  export GO111MODULE=off

  set +e
  vim -es "+packadd vim-go" "+verbose GoInstallBinaries" "+q"
  set -e

  # install one-off tools
  log "Installing tools..."
  for t in "${tools[@]}"
  do
    log "Installing ${t##*/}..."
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
userShell=$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')
if [[ "$userShell" != "$zshPath" ]]; then
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
fi

if [[ ! -d "${goroots}/go1.12" ]]; then
  go-install 1.12
fi

if [[ ! -d "${goroots}/go1.13" ]]; then
  go-install 1.13
fi

if [[ ! -d "/usr/local/go-global/1.12" ]]; then
  log "Go 1.12 global directory missing. Setting up..."
  initGoGlobal 1.12
fi

if [[ ! -d "/usr/local/go-global/1.13" ]]; then
  log "Go 1.13 global directory missing. Setting up..."
  initGoGlobal 1.13
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
  log "Installing tmux theme..."
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

##############
# Setup gRPC #
##############

if ! command -v protoc; then
  [[ ! -d /usr/local/protoc ]] && sudo mkdir /usr/local/protoc
  installGRPC 3.8.0 /usr/local/protoc
  sudo bash -c "cd /usr/local/protoc && stow 3.8.0"
fi

#############
# Setup ghz #
#############

if ! command -v ghz; then
  [[ ! -d /usr/local/ghz ]] && sudo mkdir /usr/local/ghz
  installGHZ 0.37.0 /usr/local/ghz
  sudo bash -c "cd /usr/local/ghz && stow 0.37.0"
fi

######################
# Hypriot Flash Tool #
######################

if ! command -v flash; then
  [[ ! -d /usr/local/hypriot_flash ]] && sudo mkdir /usr/local/hypriot_flash
  installHypriotFlash 2.3.0 /usr/local/hypriot_flash
  sudo bash -c "cd /usr/local/hypriot_flash && stow 2.3.0"
fi
