# Setup direnv

eval "$(direnv hook zsh)"

###########
# Antigen #
###########

source /usr/local/share/antigen/antigen.zsh

# Sources
antigen use oh-my-zsh

# Bundles
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle agkozak/zsh-z

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

#############
# z command #
#############

. $HOME/.scripts/z/z.sh
echo MANPATH="$MANPATH:$HOME/.scripts/z"

###########
# Aliases #
###########

##########
# Editor #
##########
export EDITOR=vim
