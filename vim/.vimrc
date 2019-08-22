if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/autoload')
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'pangloss/vim-javascript'
Plug 'christoomey/vim-tmux-navigator'
Plug 'zchee/deoplete-jedi'
call plug#end()


" Basic settings
set autoindent
set smartindent
set encoding=utf-8 nobomb
set fileformat=unix
filetype plugin on
syntax on
set number
set modifiable
set cursorline
set ruler
set title
set clipboard+=unnamed
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
set tabstop=2 " Default indentation is 2 spaces long and uses tabs, not spaces
set history=1000 " Increase the undo limit.
set spell
set wildignorecase
set smartcase
# increase vim responsiveness
set -sg escape-time 0


" VIM Diff
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=11 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=11 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=11 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

"Shortcuts
"Shift-Enter for inserting a line before the current line
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
"nmap <DOWN> <NOP> - press down key no operation
map <F5> :NERDTreeToggle<CR>
map <C-a> <esc>ggVG<CR> #select all

