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
call plug#end()


colorscheme palenight

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
set nospell
set wildignorecase
set smartcase
set noswapfile
set nobackup
set showmatch " highlights matching brackets

set ai " auto indent
set si " smart indent

set showmatch "highlights matching brackets
set incsearch "search as characters are entered
set nohlsearch "remove highlight

" disable bell
set visualbell
set t_vb=

" don't bell or blink
set noerrorbells
set vb t_vb=

" Invisible character colors
hi NonText ctermfg=238
hi SpecialKey ctermfg=238

" Hightlight search result
hi Search ctermbg=NONE ctermfg=red
" Highlight matches as you type
set incsearch

" Always display statusline in all windows
set laststatus=2

" Always display tabline even if there is only one tab
set showtabline=2

" Show the status line all the time
set laststatus=2

" http://vim.wikia.com/wiki/Toggle_auto-indenting_for_code_paste
set pastetoggle=<F2>

" auto-reload files when changed
set autoread

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


