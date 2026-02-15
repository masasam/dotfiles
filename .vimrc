colorscheme default
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double
set wildmenu
set clipboard=unnamedplus
set number
set title
set hidden
set showmatch
set expandtab
set tabstop=4
set noswapfile
set shiftwidth=4
set smartindent
set ignorecase
set smartcase
set nowrapscan
set hlsearch
set wrap
set incsearch
set ruler
set showcmd
set hidden
set history=2000
inoremap <silent> jj <esc>
set sh=zsh
set laststatus=2
set statusline=%F%m%=[%p%%]\ (%l,%c)\ %{'['.(&fenc!=''?&fenc:&enc).']\ ['.&fileformat.']'}
set nocompatible
filetype plugin indent on
syntax enable
syntax on
highlight StatusLine term=none cterm=none ctermfg=white ctermbg=black
let _curfile=expand("%:r")
if _curfile == 'Makefile'
  set noexpandtab
endif