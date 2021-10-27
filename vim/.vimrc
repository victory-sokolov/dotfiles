if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/autoload')
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'HerringtonDarkholme/yats.vim' " TypeScript syntax
Plug 'christoomey/vim-tmux-navigator'
Plug 'zchee/deoplete-jedi'
Plug 'FootSoft/vim-argwrap' " breaks func arguments each on new line
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'drewtempelmeyer/palenight.vim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'vim-syntastic/syntastic'
Plug 'ryanoasis/vim-devicons'
Plug 'jiangmiao/auto-pairs'
Plug 'ap/vim-css-color'
call plug#end()


colorscheme palenight

" Basic settings
set autoindent " Copy indent from last line when starting new line
set smartindent
set smartcase " Ignore 'ignorecase' if search patter contains uppercase characters
set smarttab " At start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces
set encoding=utf-8 nobomb
set fileformat=unix
filetype plugin on
syntax on
set number
set modifiable
set cursorline
set ruler " Show the cursor position
set title " Show the filename in the window titlebar
set clipboard+=unnamed
set hlsearch " Highlight searches
set showmatch " Highlights matching brackets
set foldenable " Use folding
set ignorecase " Ignore case of searches
set tabstop=2 " Default indentation is 2 spaces long and uses tabs, not spaces
set history=1000 " Increase the undo limit.
set nospell
set wildignorecase
set noswapfile
set nobackup
set magic " Enable extended regexes
set noerrorbells " Disable error bells

set t_Co=256	"Set number of colors.
set showmatch "highlights matching brackets
set incsearch "search as characters are entered
set nohlsearch "remove highlight

" disable bell
set visualbell
set t_vb=
" don't bell or blink
set noerrorbells
set vb t_vb=

" display all matching files when we tab complete
set wildmenu

" Invisible character colors
hi NonText ctermfg=238
hi SpecialKey ctermfg=238

" Hightlight search result
hi Search ctermbg=NONE ctermfg=red
" Highlight matches as you type
set incsearch
set showtabline=2 " Always display tabline even if there is only one tab
set laststatus=2 " Show the status line all the time

" http://vim.wikia.com/wiki/Toggle_auto-indenting_for_code_paste
set pastetoggle=<F2>

set autoread " auto-reload files when changed

set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/smarty/*,*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/.sass-cache/*,*/log/*,*/tmp/*,*/build/*,*/ckeditor/*,*/doc/*,*/source_maps/*,*/dist/*

" Emmet trigger
let g:user_emmet_leader_key=','

" Autocomletion
let g:ycm_python_binary_path = '/usr/bin/python3'

" VIM Diff
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=11 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=11 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=11 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

" Autocommands
" autocmd BufRead,BufNewFile * start "Switch to Insert mode when open a file

" format JSON =j
nmap =j :%!python3 -m json.tool

" Markdown
nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle

" Powerline
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

" Open NerdTree when file not specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Highlight .dotfiles
autocmd BufNewFile,BufRead *.aliases,*.functions set syntax=sh

"Shortcuts
"Shift-Enter for inserting a line before the current line
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
"nmap <DOWN> <NOP> - press down key no operation
map <F5> :NERDTreeToggle<CR>
map <C-a> <esc>ggVG<CR> #select all


