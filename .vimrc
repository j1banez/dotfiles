set nocompatible
filetype plugin indent on

set expandtab tabstop=4 softtabstop=4 shiftwidth=4 smartindent

" UI
set number
set mouse=a
set ruler
set nowrap
set colorcolumn=80
set nocursorline

" Search
set incsearch
set hlsearch
" Remove highlights
nnoremap <Esc><Esc> :nohlsearch<CR>

" Editing
set noerrorbells
set backspace=2
set encoding=utf-8
set completeopt=menuone,noinsert,noselect

" Display useless whitespaces
set list
set listchars=tab:»·,trail:·
highlight SpecialKey ctermfg=darkred

" `gf` opens file under cursor in a new vertical split
nnoremap gf :vertical wincmd f<CR>

" Headers as C files
let g:c_syntax_for_h = 1

set termguicolors
syntax on
set background=dark

" Tab / Shift-Tab completion in Insert mode
function! s:TabComplete() abort
  if pumvisible()
    return "\<C-n>"
  endif
  if getline('.')[0 : col('.')-2] =~# '^\s*$'
    return "\<Tab>"
  endif
  return "\<C-n>"
endfunction
inoremap <expr> <Tab> <SID>TabComplete()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
