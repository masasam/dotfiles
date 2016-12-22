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
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('Shougo/deoplete.nvim')
call dein#add('Shougo/denite.nvim')
call dein#add('soramugi/auto-ctags.vim')
call dein#add('airblade/vim-gitgutter')
call dein#add('itchyny/lightline.vim')
call dein#add('tpope/vim-fugitive')
call dein#add('nanotech/jellybeans.vim')
call dein#add('altercation/vim-colors-solarized')
call dein#add('editorconfig/editorconfig-vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/vimshell')
call dein#add('bronson/vim-trailing-whitespace')
call dein#add('junegunn/vim-easy-align')
call dein#add('jreybert/vimagit')
call dein#add('osyo-manga/vim-anzu')
call dein#add('Jagua/vim-denite-ghq')
call dein#add('neomake/neomake')
call dein#add('fatih/vim-go')
call dein#add('zchee/deoplete-go', {'build': 'make'})
call dein#add('davidhalter/jedi-vim')
call dein#add('tell-k/vim-autopep8')

" You can specify revision/branch/tag.
"call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

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


" -- deoplete.nvim
set runtimepath+=$XDG_CONFIG_HOME/nvim/repos/github.com/Shougo/deoplete.nvim
set completeopt+=noinsert,noselect
set completeopt-=preview

hi Pmenu    gui=NONE    guifg=#c5c8c6 guibg=#373b41
hi PmenuSel gui=reverse guifg=#c5c8c6 guibg=#373b41

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

filetype plugin indent on


" -- deoplete-go
let g:deoplete#sources#go#align_class = 1
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#package_dot = 1


" -- global
map <C-g> :Gtags -g
map <C-k> :Gtags -f %<CR>
map <C-l> :GtagsCursor<CR>
map <C-L> :Gtags -r <C-r><C-w><CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>


" -- Tabulation management
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set ignorecase
set smartcase


" -- base
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
set cursorline
set laststatus=2
set wildmenu
set sh=zsh
set dictionary=/usr/share/dict/cracklib-small
set rtp^=/usr/share/vim/vimfiles/


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


" -- solarized theme
" set background=dark
" try
"     colorscheme solarized
" catch
" endtry


" -- jellybeans theme
set background=dark
try
    colorscheme jellybeans
catch
endtry


" -- Makefile
let _curfile=expand("%:r")
if _curfile == 'Makefile'
  set noexpandtab
endif


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


" -- Denite.nvim
"prefix key
nmap <Space> [denite]
nnoremap <silent> [denite]r :<C-u>Denite<Space>buffer file_mru<CR>
nnoremap <silent> [denite]d :<C-u>Denite<Space>directory_rec<CR>
nnoremap <silent> [denite]b :<C-u>Denite<Space>buffer<CR>
nnoremap <silent> [denite]f :<C-u>Denite<Space>file_rec<CR>
nnoremap <silent> [denite]g :<C-u>Denite grep<CR>
nnoremap <silent> [denite]l :<C-u>Denite<Space>line<CR>
nnoremap <C-x>l :<C-u>Denite ghq<CR>
nnoremap <C-x><C-l> :<C-u>Denite ghq<CR>


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


"-- auto-ctags
let g:auto_ctags = 1
" tagsジャンプの時に複数ある時は一覧表示                                        
nnoremap <C-]> g<C-]>


" -- vim-gitgutter
highlight clear SignColumn
highlight SignColumn ctermbg=0
nmap gn <Plug>GitGutterNextHunk
nmap gp <Plug>GitGutterPrevHunk


" -- Easy align interactive
vnoremap <silent> <Enter> :EasyAlign<cr>


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