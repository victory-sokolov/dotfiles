" Plugins
call plug#begin('~/.vim/autoload')

Plug 'mattn/emmet-vim'

call plug#end()


" Basic settings

set encoding=utf-8 nobomb
set fileformat=unix " Line endings
filetype plugin on
syntax on
set number
set cursorline
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
set tabstop=4 " Default indentation is 4 spaces long and uses tabs, not spaces


" Shortcuts

"Shift-Enter for inserting a line before the current line
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>