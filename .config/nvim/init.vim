"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$XDG_CONFIG_HOME/nvim/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('$XDG_CONFIG_HOME/nvim')

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Add or remove your plugins here:
call dein#add('Shougo/denite.nvim')
call dein#add('airblade/vim-gitgutter')
call dein#add('editorconfig/editorconfig-vim')
call dein#add('Shougo/neomru.vim')
call dein#add('bronson/vim-trailing-whitespace')
call dein#add('junegunn/vim-easy-align')
call dein#add('neomake/neomake')
call dein#add('thinca/vim-quickrun')
call dein#add('itchyny/lightline.vim')

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


" -- global ----------------------------------------------------
map <C-g> :Gtags -g
map <C-k> :Gtags -f %<CR>
map <C-l> :GtagsCursor<CR>
map <C-L> :Gtags -r <C-r><C-w><CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>


" -- Tabulation management -------------------------------------
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set ignorecase
set smartcase


" -- base ------------------------------------------------------
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
syntax on
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double
set clipboard=unnamedplus
set number
set title
set hidden
set showmatch
set nowrapscan
set hlsearch
set wrap
set incsearch
set ruler
set showcmd
set hidden
set history=2000
set sh=zsh
set laststatus=2
set wildmenu
set sh=zsh
set dictionary=/usr/share/dict/cracklib-small
set rtp^=/usr/share/vim/vimfiles/


" -- Makefile -----------------------------------------------------
let _curfile=expand("%:r")
if _curfile == 'Makefile'
  set noexpandtab
endif


" -- grep ---------------------------------------------------------
" Change file_rec command.
call denite#custom#var('file_rec', 'command',
\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'default_opts', ['--follow', '--no-group', '--no-color'])


" -- Denite.nvim ----------------------------------------------------
"prefix key
nmap <Space> [denite]
nnoremap <silent> [denite]r :<C-u>Denite<Space>buffer file_mru<CR>
nnoremap <silent> [denite]d :<C-u>Denite<Space>directory_rec<CR>
nnoremap <silent> [denite]b :<C-u>Denite<Space>buffer<CR>
nnoremap <silent> [denite]f :<C-u>Denite<Space>file_rec<CR>
nnoremap <silent> [denite]g :<C-u>Denite grep<CR>
nnoremap <silent> [denite]l :<C-u>Denite<Space>line<CR>


" -- vim-gitgutter -----------------------------------------------------
highlight clear SignColumn
highlight SignColumn ctermbg=0
nmap gn <Plug>GitGutterNextHunk
nmap gp <Plug>GitGutterPrevHunk


" -- Easy align interactive --------------------------------------------
vnoremap <silent> <Enter> :EasyAlign<cr>


" Binding Esc in insert mode to jj -----------------------------------
inoremap <silent> jj <ESC>


" -- Erase the search highlight with esc ------------------------------
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[


" -- neomake/neomake --------------------------------------------------
autocmd! BufWritePost * Neomake


" -- vim-quickrun ------------------------------------------------------
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \ 'outputter/buffer/split'  : ':rightbelow 8sp',
      \ 'outputter/buffer/close_on_empty' : 1,
      \ }
