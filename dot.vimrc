set nocompatible
scriptencoding utf-8
set encoding=utf-8
set showtabline=2
set showmatch matchtime=1
set nowritebackup
set nobackup
set noswapfile
if version >= 703
  set undofile
  set undodir=/tmp/undo
endif
set nrformats-=octal
set timeoutlen=3500
set hidden
set formatoptions+=mM
set virtualedit=block
set backspace=indent,eol,start
set ambiwidth=double
set wildmenu
set wildmode=list:longest,full
set scrolloff=10
set shortmess+=I
nnoremap ZZ <Nop>
set splitbelow
set splitright
set ignorecase
set wildignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch
set noerrorbells
set novisualbell
set visualbell t_vb=
set shellslash
set autoindent
set smartindent
set shiftwidth=2
set expandtab
set tabstop=2
set notitle
set cmdheight=1
set laststatus=2
set showcmd
set display=lastline
set foldlevel=10000

function! s:trim()
  let s:cursor = getpos(".")
  %s/\s\+$//e
  call setpos(".", s:cursor)
endfunction
autocmd BufWritePre * call s:trim()

function! s:tabToSpace()
  let s:cursor = getpos(".")
  %s/\t/  /ge
  call setpos(".", s:cursor)
endfunction
let blacklist = ['make', 'go']
autocmd BufWritePre * if index(blacklist, &ft) < 0 | call s:tabToSpace() | endif

function! s:replace_comma_dot()
  let s:cursor = getpos(".")
  %s/、/，/ge
  %s/。/．/ge
  call setpos(".", s:cursor)
endfunction
autocmd BufWritePre *.tex call s:replace_comma_dot()

syntax on
autocmd BufEnter * :syntax sync fromstart

" display encoding, BOM, hex code
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

""" Plug
call plug#begin('~/.vim/plugged')
Plug 'Shougo/vimproc'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-surround'
Plug 'thinca/vim-tabrecent'
Plug 'vim-scripts/Align'
Plug 'Shougo/unite.vim'
Plug 'h1mesuke/unite-outline'
Plug 'osyo-manga/unite-quickfix'
Plug 'hewes/unite-gtags'
Plug 'derekwyatt/vim-scala'
Plug 'Shougo/vimshell.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'Shougo/neomru.vim'
Plug 'tpope/vim-abolish'
Plug 'solarnz/thrift.vim'
Plug 'leafgarland/typescript-vim'
Plug 'rust-lang/rust.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-goimports'

"""colorscheme
"Plug 'altercation/vim-colors-solarized'
"Plug 'croaker/mustang-vim'
"Plug 'jeffreyiacono/vim-colors-wombat'
Plug 'nanotech/jellybeans.vim'
"Plug 'w0ng/vim-hybrid'
"Plug 'vim-scripts/Lucius'
"Plug 'vim-scripts/Zenburn'
"Plug 'mrkn/mrkn256.vim'
"Plug 'jpo/vim-railscasts-theme'
"Plug 'therubymug/vim-pyte'
"Plug 'tomasr/molokai'
"Plug 'wgibbs/vim-irblack'
"Plug 'Lokaltog/vim-distinguished'
"Plug 'matthewtodd/vim-twilight.git'
call plug#end()

""" complete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

filetype plugin on

function! BadSpace()
  highlight BadSpace ctermbg=red
endfunction
if has('syntax')
  augroup BadSpace
    autocmd!
    " 背景色は #161616 (22,22,22) ぽいけど Mac では (18,18,18) で綺麗に見える？
    autocmd BufEnter * colorscheme jellybeans
    " colorscheme jellybeans
    autocmd VimEnter,WinEnter * match BadSpace /\(\s\+$\)\|　/
  augroup END
  call BadSpace()
endif

set textwidth=80
if exists('&colorcolumn')
  set colorcolumn=81,82 " vim2hs で textwidth=75 されている…
  highlight ColorColumn ctermbg=52 guibg=darkred
endif

"highlight statusline   term=NONE cterm=NONE ctermfg=black ctermbg=yellow
highlight statuslineNC term=NONE cterm=NONE ctermfg=black ctermbg=240

set list
set listchars=tab:^\ ,trail:\ ,

highlight Visual term=NONE cterm=NONE ctermbg=18

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
    setlocal cursorline
    setlocal cursorcolumn
    if exists('s:updatetime')
      let &updatetime = s:updatetime
      unlet s:updatetime
    endif
    let s:highlight = 1
    autocmd CursorMoved,CursorMovedI,WinLeave * call NoHighlightCursorLineColumn()
  endfunction
  autocmd CursorHold * call HighlightCursorLineColumn()
  autocmd CursorHoldI * call HighlightCursorLineColumn()
augroup END
if has('vim_starting')
  call HighlightCursorLineColumn()
endif

"""QuickRun
" C++11
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = '-std=c++11 -lm'
let g:quickrun_config = {}
let g:quickrun_config['cpp/g++11'] = {
  \ 'cmdopt': '-std=c++11 -lm',
  \ 'type': 'cpp/g++'
    \ }
let g:quickrun_config['cpp'] = {'type': 'cpp/g++11'}

augroup vimrcEx
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line('$') |
    \   exe "normal! g`\"" |
    \ endif
  au BufEnter * execute ":lcd " . expand("%:p:h")
augroup END

augroup BinaryXXD
  autocmd!
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r
  autocmd BufWritePre * set ft=xxd | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END

"""Markdown
autocmd BufNewFile,BufRead *.txt set ft=markdown
au FileType markdown setlocal shiftwidth=4
au FileType markdown setlocal tabstop=4
let g:markdown_fenced_languages = [
\  'c', 'cpp', 'cc=cpp', 'cs',
\  'css',
\  'erb=eruby',
\  'erlang', 'erl=erlang',
\  'go',
\  'groovy',
\  'haskell', 'hs=haskell',
\  'html', 'xml',
\  'javascript', 'js=javascript', 'json=javascript',
\  'ml=ocaml',
\  'perl', 'pl=perl',
\  'php',
\  'python', 'py=python',
\  'ruby', 'rb=ruby',
\  'scala',
\  'scheme', 'scm=scheme',
\  'sh', 'bash=sh',
\  'sql',
\]

"""haskell
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
let g:necoghc_enable_detailed_browse = 1
let g:haskell_conceal = 0

"""golang
let g:goimports_simplify = 1  " 保存時に`gofmt -s`を実行する

set pastetoggle=<C-z>
nnoremap <CR>         <ESC>
nnoremap [Prefix]     <NOP>
nnoremap [Prefix]<CR> <ESC>
nmap     <Space>      [Prefix]
nnoremap [Prefix]<CR> <ESC>
vnoremap [Prefix]     <NOP>
vmap     <Space>      [Prefix]
vnoremap [Prefix]<CR> <ESC>
vnoremap <CR>         <ESC>

nnoremap x "_x
vnoremap x "_x
nnoremap X "_X
vnoremap X "_X

nnoremap <Down> gj
nnoremap <Up>   gk
nnoremap j      gj
nnoremap k      gk
vnoremap <Down> gj
vnoremap <Up>   gk
vnoremap j      gj
vnoremap k      gk
set whichwrap=b,s,h,l,<,>,[,]

nnoremap [TABCMD]        <NOP>
nmap     t               [TABCMD]
nnoremap [TABCMD]n       :<C-u>tabnext<CR>
nnoremap [TABCMD]p       :<C-u>tabprevious<CR>
nnoremap [TABCMD]e       :<C-u>tabedit  <BS>
nnoremap [TABCMD]c       :<C-u>tabedit  <BS>
nnoremap [TABCMD]d       :<C-u>sp<CR><C-w>T<CR>
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
nnoremap [TABCMD]=       <C-w>=
nnoremap [TABCMD]N       :<C-u>tabmove +1<CR>
nnoremap [TABCMD]P       :<C-u>tabmove -1<CR>
nnoremap [TABCMD]f       :<C-u>tabedit .<CR>

vnoremap q               <ESC>

nnoremap <BS>  ^
vnoremap <BS>  ^
nnoremap <C-h> ^
vnoremap <C-h> ^
inoremap jj    <ESC>
cnoremap jj    <ESC>
nnoremap ;     :
vnoremap ;     :
nnoremap :     ;
vnoremap :     ;
nnoremap #     *Nzz
nnoremap n     nzz
nnoremap N     Nzz
cmap w!! w !sudo tee > /dev/null %

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

inoremap <C-@> <C-n>

command -range ToCamel :%s#\%V\%(\%(\k\+\)\)\@<=_\(\k\)#\u\1#g
command -range ToSnake :%s#\%V\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g

" Utility Keybinds
nnoremap [Util]          <NOP>
vmap     [Prefix]<Space> [Util]
nnoremap [Prefix]<CR>    <ESC>
nmap     [Prefix]<Space> [Util]
" QuickRun
nnoremap [Util]r         m`:<C-u>QuickRun -outputter quickfix -hook/time/enable 1<CR>:cclose<CR>:Unite -direction=botright quickfix<CR>
" Insert Date
nnoremap [Util]d         <ESC>I<C-R>=strftime("## %Y-%m-%d (%a) %H:%M")<CR><CR><CR><ESC>
" Unite
nnoremap [Util]o         m`:<C-u>Unite -direction=botright outline<CR>
nnoremap [Util]q         m`:<C-u>Unite -direction=botright quickfix<CR>
nnoremap [Util]Q         m`:<C-u>q<CR>:<C-u>Unite -direction=botright quickfix<CR>
nnoremap [Util]b         :<C-u>Unite -direction=botright buffer<CR>
nnoremap [Util]f         :<C-u>Unite -direction=botright file_mru<CR>
nnoremap [Util]g         :<C-u>Unite -direction=botright -buffer-name=search-buffer grep:.<CR>
nnoremap [Util]u         :<C-u>UniteResume search-buffer<CR>
nnoremap [Util]l         :<C-u>Unite -direction=botright location_list<CR>

if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

" VimFiler
let g:vimfiler_as_default_explorer = 1

" gtags
noremap [Gtags]     <NOP>
nmap    [Prefix]g   [Gtags]
noremap [Gtags]<CR> <ESC>
noremap [Gtags]g    :<C-u>Unite -direction=botright -default-action=tabopen gtags/def<CR>
noremap [Gtags]G    :<C-u>Unite -direction=botright -default-action=tabopen gtags/def:
noremap [Gtags]r    :<C-u>Unite -direction=botright -default-action=tabopen gtags/ref<CR>
noremap [Gtags]R    :<C-u>Unite -direction=botright -default-action=tabopen gtags/ref:
