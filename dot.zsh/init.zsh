function err() {
    echo $* > /dev/stderr
}

# /usr/local などと同様に認識させたいディレクトリ
function make_path() {
    LOCAL_DIR=("$HOME/local" "$HOME/brew" "$HOME/dotfiles")
    str=""
    for i in $LOCAL_DIR; do
        [[ -d "$i/$1" ]] && str="$str$i/$1:"
    done
    echo $str
}

# eval once
if [ "$TERM" != "xterm-256color" ]; then
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
    export PATH=$HOME/.rbenv/shims:$PATH
    RUBY_VERSION=1.9
    export RUBYLIB=$HOME/local/lib/ruby/$RUBY_VERSION
    # rubygems
    export GEM_HOME=$HOME/.gem/$RUBY_VERSION
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
fi

# alias
alias rm='mv -f --backup=numbered --target-directory /tmp/trash'
alias here="open ."
alias crontab='crontab -i'
alias ack='ack -i'
alias vi='vim -u NONE --noplugin'
alias json='python -mjson.tool'
alias xml='xmllint --format -'
alias simplehttpserver='python -m SimpleHTTPServer'

# hogehoge G で hogehoge | grep になるとか
alias -g G=' | grep'
alias -g X=' | xargs'
alias -g D=' | diff -wy -'
alias -g XG=' -type f -print0 | xargs -0 grep '

which gmv &> /dev/null && alias mv='gmv'
if which gls &> /dev/null; then alias ls="gls $LSOPTION"
else alias ls="ls $LSOPTION"; fi

# そのプロセスがいなければ立ち上げる
function run_unless() {
    if [ -z "$2" ]; then
        run=$1
    else
        run=$2
    fi
    [[ -z "`ps aux | grep $1 | grep $USER | grep -v grep`" ]] && $run &> /dev/null &
}
# cd したあとに ls
function cd() {
    if [[ "$1" =~ "^-[1-9][0-9]*/.+" ]]; then
        num=`echo $1 | cut -f1 -d'/'`
        other=`echo $1 | sed -e "s/$num\///"`
        builtin cd $num &> /dev/null
        builtin cd $other && ls
    else
        builtin cd $@ && ls
    fi
}
# OSX 用 tmux (reattach-to-user-namespace) をかませるか否か
function tmux() {
    if [[ "$1" == "a" ]]; then
        command tmux $*
    elif [[ ( $OSTYPE == darwin* ) && ( -x $(which reattach-to-user-namespace 2>/dev/null 2>&1) ) ]]; then
        tweaked_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))

        command tmux $* -f <(echo "$tweaked_config")
    else
        command tmux $*
    fi
}
# 競技プログラミング用
function test() {
    file=$1
    if [ -f $file.cpp ]; then
        src=$file.cpp
    elif [ -f $file.cc ]; then
        src=$file.cc
    elif [ -f $file.c ]; then
        src=$file.c
    else
        err "$file source file doen't exist."
        return 1
    fi

    err "compiling..."
    g++ -O2 -std=c++11 $src -o $file
    if [ $? != 0 ]; then
        err "compilation failed."
        return 1
    else
        err "success!"
    fi

    if [ "$2" != "" ]; then
        in=$2
    elif [ -f $file.in ]; then
        in=$file.in
    else
        err "input file doesn't exist."
        return 1
    fi
    time ./$file < $in
}
# git status -s で表示した n 行目のファイルを取ってくる。
# git checkout `g 2 3` のように使う
function g() {
    str=`git status -s`
    out=
    while [ -n "$1" ]; do
        k=$(echo $str | awk "{print \$2}" | awk "NR==$1")
        out="$out $k"
        shift
    done
    echo $out
}
# cabal-dev install <executable package>
# cabal-dev でインストールしたあと、実行バイナリを $HOME/local/bin に simlink
function cabal-dev-install-executable() {
    local package_path=$HOME/local/cabal-dev
    local executable_path=$HOME/local/bin
    if [ $# != 1 ]; then
        err "Usage: cabal-dev-install <package>"
        err "    Please specify only one package."
        err "    The package will be installed to $package_path,"
        err "    and the executables will be symlinked to $executable_path."
        return 1
    fi
    local install_path=$package_path/$1
    [[ ! -d $install_path ]] && mkdir -p $install_path
    cd $install_path
    cabal-dev update
    cabal-dev install $1
    [[ ! -d $executable_path ]] && mkdir -p $executable_path
    [[ -d $install_path/cabal-dev/bin ]] && ln -sf $install_path/cabal-dev/bin/* $executable_path
}
function c() {
    local package_path=cabal-dev/packages-${GHC_VERSION}.conf:
    local sub=$1
    if [ "$sub" = "run" ]; then
        shift
        GHC_PACKAGE_PATH=$package_path runghc $*
    elif [ "$sub" = "compile" ]; then
        shift
        GHC_PACKAGE_PATH=$package_path ghc $*
    else
        cabal-dev $*
    fi
}
# セパレータ
# http://qiita.com/items/674b8582772747ede9c3
function separate(){
    echo -n $fg_bold[yellow]
    for i in $(seq 1 $COLUMNS); do
        echo -n '~'
    done
    echo -n $reset_color
}

# always home directory
if [ "`pwd`" = "/" ]; then
    builtin cd $HOME
fi

# zsh っぽい設定
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
bindkey -e
function tcsh-backward-delete-word() {
    local WORDCHARS=
    zle backward-delete-word
}
zle -N tcsh-backward-delete-word
bindkey '' tcsh-backward-delete-word
bindkey '' tcsh-backward-delete-word
bindkey ";5C" forward-word # M-f
bindkey ";5D" backward-word # M-b

autoload history-search-end # ヒストリ検索
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
stty stop undef # C-s でロックされるのを防ぐ

## cdr system stuff.
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

. $HOME/.zsh/z/z.sh

# 補完
# http://gihyo.jp/dev/serial/01/zsh-book/0005
autoload -Uz colors; colors
autoload -Uz compinit; compinit

#setopt complete_aliases # エイリアス補完 # z.sh が動かないようなので
setopt magic_equal_subst # = のあとパス名を補完
setopt auto_cd    # ディレクトリ名で cd
setopt auto_pushd # cd - <TAB> でディレクトリ履歴
setopt pushd_minus # cd + <TAB> と cd - <TAB> を交換 cd - <TAB> で最近のディレクトリから選択するようになる
setopt correct    # 存在しないコマンド修正
setopt list_packed # 詰めて表示
setopt nolistbeep # ビープうぜえ
setopt auto_remove_slash auto_name_dirs
setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys pushd_ignore_dups
setopt share_history inc_append_history
setopt sun_keyboard_hack # 行末の`(バッククォート)を無視するようになる。

zstyle ':completion:*' format '%BCompleting %d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*' users
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*:(processes|jobs|options|directory-stack)' menu yes select=1
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:*' menu yes select=1
zstyle ':completion:*' completer _expand _complete _prefix _approximate _list

# http://www.zsh.org/mla/users/2009/msg01019.html
zmodload zsh/complist
bindkey -M menuselect '' .accept-line # メニューの後1回の Enter で決定
bindkey -M menuselect '[Z' reverse-menu-complete
bindkey -M menuselect ' ' accept-line

unsetopt sh_wordsplit

# vcs_info 設定

my_vcs_info=""

autoload -Uz vcs_info
autoload -Uz is-at-least
autoload -Uz colors

# 以下の3つのメッセージをエクスポートする
#   $vcs_info_msg_0_ : 通常メッセージ用 (緑)
#   $vcs_info_msg_1_ : 警告メッセージ用
#   $vcs_info_msg_2_ : エラーメッセージ用 (赤)
zstyle ':vcs_info:*' max-exports 3

zstyle ':vcs_info:*' enable git svn hg bzr
# 標準のフォーマット(git 以外で使用)
# misc(%m) は通常は空文字列に置き換えられる
zstyle ':vcs_info:*' formats '(%s)[%b]'
zstyle ':vcs_info:*' actionformats '(%s)[%b]' '%m' '<!%a>'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

if is-at-least 4.3.10; then
    # git 用のフォーマット
    # git のときはステージしているかどうかを表示
    zstyle ':vcs_info:git:*' formats '(%s)[%b]' '%c%u%m'
    zstyle ':vcs_info:git:*' actionformats '(%s)[%b]' '%c%u%m' '<!%a>'
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "%F{magenta}[+]%f"    # %c で表示する文字列
    zstyle ':vcs_info:git:*' unstagedstr "%F{magenta}[-]%f"  # %u で表示する文字列
fi

# hooks 設定
if is-at-least 4.3.11; then
    # git のときはフック関数を設定する

    # formats '(%s)-[%b]' '%c%u %m' , actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
    # のメッセージを設定する直前のフック関数
    # 今回の設定の場合はformat の時は2つ, actionformats の時は3つメッセージがあるので
    # 各関数が最大3回呼び出される。
    zstyle ':vcs_info:git+set-message:*' hooks \
                                            git-hook-begin \
                                            git-untracked \
                                            git-push-status \
                                            git-nomerge-branch \
                                            git-stash-count

    # フックの最初の関数
    # git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする
    # (.git ディレクトリ内にいるときは呼び出さない)
    # .git ディレクトリ内では git status --porcelain などがエラーになるため
    function +vi-git-hook-begin() {
        # 0以外を返すとそれ以降のフック関数は呼び出されない
        [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]] && return 1

        return 0
    }

    # untracked ファイル表示
    function +vi-git-untracked() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        [[ "$1" != "1" ]] && return 0

        if command git status --porcelain 2> /dev/null \
            | awk '{print $1}' \
            | command grep -F '??' &> /dev/null ; then

            # unstaged (%u) に追加
            hook_com[unstaged]+='%F{magenta}[?]%f'
        fi
    }

    # push していないコミットの件数表示
    function +vi-git-push-status() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        [[ "$1" != "1" ]] && return 0

        # master ブランチでない場合は何もしない
        [[ "${hook_com[branch]}" != "master" ]] && return 0

        # push していないコミット数を取得する
        local ahead
        ahead=$(command git rev-list origin/master..master 2>/dev/null \
            | wc -l \
            | tr -d ' ')

        [[ "$ahead" -gt 0 ]] && hook_com[misc]+="%F{yellow}[p${ahead}]%f"
    }

    # マージしていない件数表示
    function +vi-git-nomerge-branch() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        [[ "$1" != "1" ]] && return 0

        # master ブランチの場合は何もしない
        [[ "${hook_com[branch]}" == "master" ]] && return 0

        local nomerged
        nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')

        [[ "$nomerged" -gt 0 ]] && hook_com[misc]+="%F{yellow}[m${nomerged}]%f"
    }


    # stash 件数表示
    function +vi-git-stash-count() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        [[ "$1" != "1" ]] && return 0

        local stash
        stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')

        [[ "${stash}" -gt 0 ]] && hook_com[misc]+="%F{yellow}[S${stash}]%f"
    }

fi

function _update_vcs_info_msg() {
    [[ ! -z "`realpath . | grep /Dropbox/memo`" ]] && return
    local -a messages
    local prompt

    LANG=en_US.UTF-8 vcs_info

    if [[ -z ${vcs_info_msg_0_} ]]; then
        # vcs_info で何も取得していない場合はプロンプトを表示しない
        prompt=""
    else
        # vcs_info で情報を取得した場合
        # $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
        # それぞれ緑、黄色、赤で表示する
        [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
        [[ -n "$vcs_info_msg_1_" ]] && messages+=( "${vcs_info_msg_1_}" )
        [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

        # 間にスペースを入れて連結する
        prompt="${(j::)messages}"
    fi
    my_vcs_info="${prompt}"
}
add-zsh-hook precmd _update_vcs_info_msg

count_prompt_characters() {
    print -n -P -- "$1" | sed -e $'s/\e\[[0-9;]*m//g' | wc -m | sed -e 's/ //g'
}
update_prompt() {
    local color="%{%(?.%F{green}.%F{red})%}"
    local prompt_bar_left="${color}<%D{%Y-%m-%d %H:%M:%S}>%f"

    local bar_left_length=$(count_prompt_characters "$prompt_bar_left")
    local bar_rest_length=$[COLUMNS - bar_left_length]

    local bar_left="$prompt_bar_left"

    LANG=C my_vcs_info_function >&/dev/null
    local prompt_bar_right="${my_vcs_info}[%~]"

    local bar_right_without_path="${prompt_bar_right:s/%~//}"
    local bar_right_without_path_length=$(count_prompt_characters "$bar_right_without_path")
    local max_path_length=$[bar_rest_length - bar_right_without_path_length]
    bar_right=${prompt_bar_right:s/%~/%(C,%${max_path_length}<...<%~%<<,)/}
    local separator="${(l:${bar_rest_length}::-:)}"
    bar_right="%${bar_rest_length}<<${separator}${bar_right}%<<"

    PROMPT="${bar_left}${bar_right}"$'\n'"${color}%n@%m %% %f"
    RPROMPT=
}
add-zsh-hook precmd update_prompt
