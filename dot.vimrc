set nocompatible
scriptencoding utf-8
set encoding=utf-8

"行番号表示
"set number

"タブ
set showtabline=2

"括弧の対応表示時間
set showmatch matchtime=1

"バックアップファイル邪魔
set nowritebackup
set nobackup
set noswapfile

"再読込、vim終了後も継続するアンドゥ(7.3)
if version >= 703
  "Persistent undoを有効化(7.3)
  set undofile
  "アンドゥの保存場所(7.3)
  set undodir=/tmp/undo
endif

"8進数を無効にする。<C-a>,<C-x>に影響する
set nrformats-=octal

"キーコードやマッピングされたキー列が完了するのを待つ時間(ミリ秒)
set timeoutlen=3500

"クリップボードを共有
set clipboard+=unnamed

"編集結果非保存のバッファから、新しいバッファを開くときに警告を出さない
set hidden

"日本語の行の連結時には空白を入力しない
set formatoptions+=mM

"Visual blockモードでフリーカーソルを有効にする
set virtualedit=block

"バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start

"□や○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double

"コマンドライン補完するときに強化されたものを使う
set wildmenu

set wildmode=list:longest,full

"スプラッシュ(起動時のメッセージ)を表示しない
set shortmess+=I

"正規表現の * + などをエスケープしないで
"set magic

"ペースト "neocomplcache が動かないらしい
"set paste

"強制全保存終了を無効化
nnoremap ZZ <Nop>

"単語の定義
set iskeyword+=45

"新しいウィンドウを下・右に
set splitbelow
set splitright

"保存時に行末の空白を除去する
function! s:trim()
  let s:cursor = getpos(".")
  %s/\s\+$//e
  call setpos(".", s:cursor)
endfunction
autocmd BufWritePre * call s:trim()
"保存時にtabをスペースに変換する
function! s:tabToSpace()
  let s:cursor = getpos(".")
  %s/\t/  /ge
  call setpos(".", s:cursor)
endfunction
autocmd BufWritePre
  \ [^M]*\|M[^a]*\|Ma[^k]*\|Mak[^e]*\|Make[^f]*\|Makef[^i]*\|Makefi[^l]*\|Makefil[^e]*
  \ call s:tabToSpace()
" TeX 用
function! s:replace_comma_dot()
  let s:cursor = getpos(".")
  %s/、/，/ge
  %s/。/．/ge
  call setpos(".", s:cursor)
endfunction
autocmd BufWritePre *.tex call s:replace_comma_dot()

"検索の時に大文字小文字を区別しない
"ただし大文字小文字の両方が含まれている場合は大文字小文字を区別する
set ignorecase
set smartcase
"検索時にファイルの最後まで行ったら最初に戻る
set wrapscan
"インクリメンタルサーチ
set incsearch
"検索文字の強調表示
set hlsearch
"エラー時の音とビジュアルベルの抑制(gvimは.gvimrcで設定)
set noerrorbells
set novisualbell
set visualbell t_vb=
"マクロ実行中などの画面再描画を行わない
"set lazyredraw
"Windowsでディレクトリパスの区切り文字表示に / を使えるようにする
set shellslash
"自動的にインデントする
set autoindent
set smartindent
set shiftwidth=2
"Tab 幅
set expandtab
set tabstop=2
"タイトルを非表示 (Thanks for flying Vim)
set notitle
"コマンドラインの高さ (gvimはgvimrcで指定)
set cmdheight=1
set laststatus=2
"コマンドをステータス行に表示
set showcmd
"画面最後の行をできる限り表示する
set display=lastline

" ハイライトを有効にする
syntax on

"ステータスラインに文字コードやBOM、16進表示等表示
"iconvが使用可能の場合、カーソル上の文字コードをエンコードに応じた表示にするFencB()を使用
set statusline=%<%F\ %m\ %r%h%w%=%{'['.(&fenc!=''?&fenc:&enc).(&bomb?':BOM':'').']['.&ff.']'}[0x%{FencB()}](%l:%v)/%L
function! FencB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return s:Byte2hex(s:Str2byte(c))
endfunction
function! s:Str2byte(str)
  return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction
function! s:Byte2hex(bytes)
  return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
endfunction

"折り畳みやめて
set foldlevel=10000
"set foldmethod=marker

"""NeoBundle
filetype off
if has('vim_starting')
  set runtimepath+=~/.vim/neobundle.vim
  call neobundle#rc(expand('~/.bundle'))
endif

"""Bundle
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/vimproc'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'eagletmt/ghcmod-vim'
NeoBundle 'ujihisa/neco-ghc'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'tpope/vim-surround'
NeoBundle 'dag/vim2hs'
NeoBundle 'mattn/wiseman-f-vim'
NeoBundle 'thinca/vim-tabrecent'
NeoBundle 'vim-scripts/Align'
NeoBundle 'vim-scripts/gtags.vim'

"""colorscheme
"NeoBundle 'altercation/vim-colors-solarized'
"NeoBundle 'croaker/mustang-vim'
"NeoBundle 'jeffreyiacono/vim-colors-wombat'
NeoBundle 'nanotech/jellybeans.vim'
"NeoBundle 'w0ng/vim-hybrid'
"NeoBundle 'vim-scripts/Lucius'
"NeoBundle 'vim-scripts/Zenburn'
"NeoBundle 'mrkn/mrkn256.vim'
"NeoBundle 'jpo/vim-railscasts-theme'
"NeoBundle 'therubymug/vim-pyte'
"NeoBundle 'tomasr/molokai'
"NeoBundle 'wgibbs/vim-irblack'
"NeoBundle 'Lokaltog/vim-distinguished'
"NeoBundle 'matthewtodd/vim-twilight.git'

filetype plugin on

"色設定
function! BadSpace()
  highlight BadSpace ctermbg=red
endfunction
if has('syntax')
  augroup BadSpace
    autocmd!
    " 背景色は #161616 (22,22,22) ぽいけど Mac では (18,18,18) で綺麗に見える？
    colorscheme jellybeans
    "悪いスペース類
    autocmd VimEnter,WinEnter * match BadSpace /\(\s\+$\)\|　/
  augroup END
  call BadSpace()
endif
"81,82桁目をハイライト
set textwidth=80
if exists('&colorcolumn')
  set colorcolumn=81,82 " vim2hs で textwidth=75 されている…
  highlight ColorColumn ctermbg=52 guibg=darkred
endif
" ステータスライン
"highlight statusline   term=NONE cterm=NONE ctermfg=black ctermbg=yellow
highlight statuslineNC term=NONE cterm=NONE ctermfg=black ctermbg=240
" タブとスペース
set list
set listchars=tab:^\ ,trail:\ ,
" ビジュアルモードハイライト
highlight Visual term=NONE cterm=NONE ctermbg=18

" カーソル行列を自動でハイライト
highlight CursorLine term=NONE cterm=NONE ctermbg=235
highlight CursorColumn term=NONE cterm=NONE ctermbg=236
augroup HighlightCursorLineColumn
  function! NoHighlightCursorLineColumn()
    if s:highlight > 0
      let s:updatetime = &updatetime
      set updatetime=500
      setlocal nocursorline
      setlocal nocursorcolumn
      let s:highlight = 0
    endif
  endfunction
  function! HighlightCursorLineColumn()
    "カーソル行列ハイライト
    setlocal cursorline
    setlocal cursorcolumn
    if exists('s:updatetime')
      let &updatetime = s:updatetime
      unlet s:updatetime
    endif
    let s:highlight = 1
    " カーソルを動かしたらハイライトやめる
    autocmd CursorMoved,CursorMovedI,WinLeave * call NoHighlightCursorLineColumn()
  endfunction
  autocmd CursorHold * call HighlightCursorLineColumn()
  autocmd CursorHoldI * call HighlightCursorLineColumn()
augroup END
" TODO: 起動時にカーソルハイライトしたい
if has('vim_starting')
  call HighlightCursorLineColumn()
endif

"""neocomplcache.
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_ignore_case = 1
"TAB, S-TAB で候補の選択
inoremap <expr><TAB>    pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

augroup vimrcEx
  autocmd!
  """ファイルを開いたら前回のカーソル位置へ移動
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line('$') |
    \   exe "normal! g`\"" |
    \ endif
  """自動的に cd
  au BufEnter * execute ":lcd " . expand("%:p:h")
augroup END

"""バイナリ編集(xxd)モード（vim -b での起動）
augroup BinaryXXD
  autocmd!
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END

"""Markdown
autocmd BufNewFile,BufRead *.txt set ft=markdown

"""haskell
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
let g:necoghc_enable_detailed_browse = 1
let g:haskell_conceal = 0

"""キーバインド
nnoremap [Prefix] <NOP>
nmap <Space> [Prefix]

" x, X キーでヤンクしない
nnoremap x "_x
vnoremap x "_x
nnoremap X "_X
vnoremap X "_X

" カーソルをj k では物理行で移動する。論理行移動は<C-n>,<C-p>
nnoremap <Down> gj
nnoremap <Up>   gk
nnoremap j      gj
nnoremap k      gk
vnoremap <Down> gj
vnoremap <Up>   gk
vnoremap j      gj
vnoremap k      gk
" BS, SPC, h, l で行末・行頭を超えることができる
set whichwrap=b,s,h,l,<,>,[,]

" タブ
" tmux のコマンドと大体同じに
nnoremap [TABCMD]        <NOP>
nmap     t               [TABCMD]
nnoremap [TABCMD]n       :<C-u>tabnext<CR>
nnoremap [TABCMD]p       :<C-u>tabprevious<CR>
nnoremap [TABCMD]e       :<C-u>tabedit  <BS>
nnoremap [TABCMD]c       :<C-u>tabedit  <BS>
nnoremap [TABCMD]h       <C-w>h
nnoremap [TABCMD]j       <C-w>j
nnoremap [TABCMD]k       <C-w>k
nnoremap [TABCMD]l       <C-w>l
nnoremap [TABCMD]s       :<C-u>sp<CR>
nnoremap [TABCMD]v       :<C-u>vsp<CR>
nnoremap [TABCMD]<Space> :<C-u>sp<CR>
nnoremap [TABCMD]m       :<C-u>vsp<CR>
nnoremap [TABCMD]<CR>    :<C-u>vsp<CR>
nnoremap [TABCMD]t       v
vnoremap q               <ESC>

" 右手だけでスクロールできるように
nnoremap [Prefix]<Space> zz
nnoremap [Prefix]j       <C-f>
nnoremap [Prefix]k       <C-b>
nnoremap ,               0
nnoremap .               $
vnoremap ,               0
vnoremap .               $

nnoremap [Prefix]s :<C-u>source ~/.vimrc<CR>

" 操作を楽・直感的にする系
noremap <CR> ^
inoremap jj  <ESC>
cnoremap jj  <ESC>
nnoremap ;   :
vnoremap ;   :
nnoremap :   ;
vnoremap :   ;
nnoremap #   *N

nnoremap //  :<C-u>Migemo<CR>

nnoremap [Prefix]n :<C-u>cn<CR>
nnoremap [Prefix]p :<C-u>cp<CR>
nnoremap [Prefix]c :<C-u>cc<CR>

nnoremap [Prefix]o :<C-u>on<CR>

" insert mode で Emacs キーバインド
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Delete>
inoremap <C-h> <BS>
inoremap <C-m> <CR>
inoremap <C-o> <CR><Up>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Delete>
cnoremap <C-h> <BS>
cnoremap <C-m> <CR>
cnoremap <C-o> <CR><Up>

" insert mode で補完
inoremap <C-Space>   <C-n>
inoremap <C-S-Space> <C-p>

" Haskell
nnoremap [Haskell] <NOP>
nmap [Prefix]h [Haskell]
noremap [Haskell]tt :<C-u>GhcModType<CR>
noremap [Haskell]tc :<C-u>GhcModTypeClear<CR>
noremap [Haskell]ti :<C-u>GhcModTypeInsert<CR>
noremap [Haskell]c :<C-u>GhcModCheckAndLintAsync<CR>
noremap [Haskell]e :<C-u>GhcModExpand<CR>
noremap [Haskell]ii :<C-u>GhcModInfo<CR>
noremap [Haskell]ip :<C-u>GhcModInfoPreview<CR>
noremap [Haskell]s :<C-u>%!stylish-haskell<CR>
au FileType haskell set shiftwidth=4
au FileType haskell set tabstop=4

" QuickRun
nnoremap [Prefix]r :<C-u>QuickRun<CR><C-w>j

" gtags
noremap [Prefix]gg :<C-u>Gtags<CR>
noremap [Prefix]gf :<C-u>Gtags -f %<CR>
noremap [Prefix]gc :<C-u>GtagsCursor<CR>
