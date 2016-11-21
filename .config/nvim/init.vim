set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac 
set number
set title
set showmatch
set noexpandtab
set tabstop=4
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
set paste
set cursorline
syntax on
"filetype plugin on
"filetype indent on
set laststatus=2
set statusline=%F%m%=%l/%L,%c\ %{'['.(&fenc!=''?&fenc:&enc).']\ ['.&fileformat.']'}


"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/masa/.config/nvim/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('/home/masa/.config/nvim')

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Add or remove your plugins here:
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('Shougo/deoplete.nvim')
call dein#add('Shougo/denite.nvim')
call dein#add('thinca/vim-quickrun')

" You can specify revision/branch/tag.
call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------
