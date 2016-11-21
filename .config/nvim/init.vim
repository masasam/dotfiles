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
set laststatus=2
set statusline=%F%m%=[%p%%]\ (%l,%c)\ %{fugitive#statusline()}\ %{'['.(&fenc!=''?&fenc:&enc).']\ ['.&fileformat.']'}

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
call dein#add('tpope/vim-fugitive')
call dein#add('vim-scripts/twilight')

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

" When insert mode, change statusline.
let g:hi_insert = 'hi StatusLine gui=None guifg=Black guibg=Yellow cterm=None ctermfg=Black ctermbg=Yellow'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction


syntax on
highlight StatusLine term=none cterm=none ctermfg=white ctermbg=black
"highlight StatusLine term=none cterm=none ctermfg=grey ctermbg=black
