##########
# Chruby #
##########

source /usr/local/share/chruby/chruby.sh

##########
# Golang #
##########

export GOPATH=$HOME/go
export PATH=$HOME/scripts:$PATH

###########
# Antigen #
###########

source $HOME/.dotfiles/antigen/antigen.zsh

# Sources
antigen use oh-my-zsh

# Bundles
antigen bundle zsh-users/zsh-syntax-highlighting

# Themes
antigen theme cloud

antigen apply

###########
# Aliases #
###########

alias dsql="docker run -it --link theguide_pg_1:postgres --rm postgres:9.4 sh -c 'exec psql -h \"\$POSTGRES_PORT_5432_TCP_ADDR\" -p \"\$POSTGRES_PORT_5432_TCP_PORT\" -U postgres'"

# Z cmd
. `brew --prefix`/etc/profile.d/z.sh
