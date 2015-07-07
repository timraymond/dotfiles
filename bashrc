source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby ruby-2.1.2
. `brew --prefix`/etc/profile.d/z.sh

# Add GOROOT-based binaries to PATH
export PATH=$PATH:/usr/local/opt/go/libexec/bin
