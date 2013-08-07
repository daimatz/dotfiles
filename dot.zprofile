# /usr/local などと同様に認識させたいディレクトリ
function make_path() {
    LOCAL_DIR=("$HOME/local" "$HOME/brew" "$HOME/dotfiles")
    str=""
    for i in $LOCAL_DIR; do
        [[ -d "$i/$1" ]] && str="$str$i/$1:"
    done
    echo $str
}

export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
export WORDCHARS='*?[]~=&;!#$%^(){}<>'

export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export LSOPTION='-F --color=auto --si --show-control-char'
export PATH=`make_path bin`$PATH
export EDITOR=vim
export LANG=ja_JP.UTF-8
export PAGER=less

export _Z_CMD=j
export _Z_NO_RESOLVE_SYMLINKS=1

# for heroku
# Download Heroku Toolbelt standalone
export PATH=$PATH:/usr/local/heroku/bin

# for Ruby, migemo
# eval "$(rbenv init -)" is too late
export PATH=$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH
# rubygems
RUBY_VERSION=$(ruby -e 'print RUBY_VERSION.gsub(/(\d)\.(\d)\.(\d)/, "\\1.\\2")')
export GEM_HOME=$HOME/.gems/$RUBY_VERSION
export PATH=$GEM_HOME/bin:$PATH

# for Perl
export PERL5LIB=$HOME/local

# for Haskell
export PATH=$HOME/.cabal/bin:$PATH
export GHC_VERSION=`ghc --version 2> /dev/null | awk '{ print $8 }'`

# for D
export PATH=$HOME/.denv/shims:$HOME/.denv/bin:$PATH

[[ ! -d /tmp/trash ]] && mkdir /tmp/trash
[[ ! -d /tmp/undo ]] && mkdir /tmp/undo

## 色設定
TERM=xterm-256color
# LANG=C perl ~/.zsh/256colors2.pl > /dev/null
