" -- vim/plugged -------------------------
call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'nanotech/jellybeans.vim'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'
Plug 'soramugi/auto-ctags.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/vim-easy-align'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neocomplete.vim'
Plug 'jreybert/vimagit'
Plug 'osyo-manga/vim-anzu'
Plug 'Jagua/vim-denite-ghq'
Plug 'Shougo/neoyank.vim'
Plug 'neomake/neomake'
Plug 'fatih/vim-go'

call plug#end()
" -----------------------------------------


" -- global
map <C-g> :Gtags -g
map <C-k> :Gtags -f %<CR>
map <C-l> :GtagsCursor<CR>
map <C-L> :Gtags -r <C-r><C-w><CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>


" -- solarized theme
set background=dark
try
    colorscheme solarized
catch
endtry


" -- jellybeans theme
" set background=dark
" try
"     colorscheme jellybeans
" catch
" endtry


" -- Tabulation management
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set ignorecase
set smartcase


" -- base
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
set cursorline
set laststatus=2
set wildmenu
set sh=zsh
set dictionary=/usr/share/dict/cracklib-small


" -- lightline
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified', 'anzu' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?" ":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'component_function': {
      \   'anzu': 'anzu#search_status'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': ' ' }
      \ }


" -- Makefile
let _curfile=expand("%:r")
if _curfile == 'Makefile'
  set noexpandtab
endif


" -- elscreen
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]k :tabclose<CR>
" tk タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ


" -- vim-gitgutter
highlight clear SignColumn
highlight SignColumn ctermbg=0
nmap gn <Plug>GitGutterNextHunk
nmap gp <Plug>GitGutterPrevHunk


" -- Easy align interactive
vnoremap <silent> <Enter> :EasyAlign<cr>


" -- Denite.nvim
"prefix key
nmap <Space> [denite]
nnoremap <silent> [denite]r :<C-u>Denite<Space>buffer file_mru<CR>
nnoremap <silent> [denite]d :<C-u>Denite<Space>directory_rec<CR>
nnoremap <silent> [denite]b :<C-u>Denite<Space>buffer<CR>
nnoremap <silent> [denite]f :<C-u>Denite<Space>file_rec<CR>
nnoremap <silent> [denite]g :<C-u>Denite grep<CR>
nnoremap <silent> [denite]l :<C-u>Denite<Space>line<CR>
nnoremap <silent> [denite]y :<C-u>Denite neoyank<CR>
nnoremap <C-x>l :<C-u>Denite ghq<CR>
nnoremap <C-x><C-l> :<C-u>Denite ghq<CR>


" -- grep
" Change file_rec command.
call denite#custom#var('file_rec', 'command',
\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
" For ripgrep
" Note: It is slower than ag
" call denite#custom#var('file_rec', 'command',
" \ ['rg', '--files', '--glob', '!.git'])

" Ripgrep command on grep source
" call denite#custom#var('grep', 'command', ['rg'])
" call denite#custom#var('grep', 'recursive_opts', [])
" call denite#custom#var('grep', 'final_opts', [])
" call denite#custom#var('grep', 'separator', ['--'])
" call denite#custom#var('grep', 'default_opts',
"      \ ['--vimgrep', '--no-heading'])

call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'default_opts', ['--follow', '--no-group', '--no-color'])


"-- auto-ctags
let g:auto_ctags = 1
" tagsジャンプの時に複数ある時は一覧表示                                        
nnoremap <C-]> g<C-]>


" -- neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_underbar_completion = 1
let g:neocomplete#enable_camel_case_completion  =  1
let g:neocomplete#max_list = 20
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#auto_completion_start_length = 2
let g:neocomplete#enable_auto_close_preview = 0
let g:neocomplete#max_keyword_width = 10000


" インサートモードのEscをjjにバインド
inoremap <silent> jj <ESC>


" -- vim-anzu
nmap n <Plug>(anzu-n)
nmap N <Plug>(anzu-N)
nmap * <Plug>(anzu-star)
nmap # <Plug>(anzu-sharp)
augroup vim-anzu
" 一定時間キー入力がないとき、ウインドウを移動したとき、タブを移動したときに
" 検索ヒット数の表示を消去する
    autocmd!
    autocmd CursorHold,CursorHoldI,WinLeave,TabLeave * call anzu#clear_search_status()
augroup END


" -- neomake/neomake
autocmd! BufWritePost * Neomake


" -- vim-go
let g:go_fmt_command = 'goimports'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_term_enabled = 1
let g:go_highlight_build_constraints = 1
autocmd FileType go nmap <leader>gb <Plug>(go-build)
autocmd FileType go nmap <leader>gt <Plug>(go-test)
autocmd FileType go nmap <Leader>ds <Plug>(go-def-split)
autocmd FileType go nmap <Leader>dv <Plug>(go-def-vertical)
autocmd FileType go nmap <Leader>dt <Plug>(go-def-tab)
autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
