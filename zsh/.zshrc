# Setup direnv

eval "$(direnv hook zsh)"

###########
# Antigen #
###########

source $HOME/dotfiles/antigen.zsh

# Sources
antigen use oh-my-zsh

# Bundles
antigen bundle zsh-users/zsh-syntax-highlighting

# Themes
antigen theme cloud

antigen apply

######################
# Path modifications #
######################

export PATH="$PATH:$HOME/scripts"
export PATH="/usr/local/sbin:$PATH"

#############
# Misc ENVs #
#############

# Fix that annoying "problem with 'vi'" thing
export KUBE_EDITOR=/usr/bin/vim

###########
# Aliases #
###########

# Z cmd
. $(brew --prefix)/etc/profile.d/z.sh

# Source mattel-specific configuration and aliases
if [[ -f $HOME/.mattelrc ]]; then source $HOME/.mattelrc; fi
