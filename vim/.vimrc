if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/autoload')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree'		" File explorer
Plug 'scrooloose/nerdcommenter'		" Comment stuff
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'					" JSX support
Plug 'HerringtonDarkholme/yats.vim' " TypeScript syntax highlight
Plug 'christoomey/vim-tmux-navigator'
"Plug 'zchee/deoplete-jedi'
Plug 'FootSoft/vim-argwrap'			" breaks func arguments each on new line
Plug 'prettier/vim-prettier', {'do': 'yarn install' }
Plug 'iamcco/markdown-preview.nvim',{'do': { -> mkdp#util#install() },'for': ['markdown', 'vim-plug']}
Plug 'drewtempelmeyer/palenight.vim'
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'junegunn/fzf', {'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'				" Fuzzy search
Plug 'vim-syntastic/syntastic'
Plug 'ryanoasis/vim-devicons'		" DevIcons in NerdTree
Plug 'jiangmiao/auto-pairs'
Plug 'ap/vim-css-color'				" CSS color highlight
Plug 'SirVer/ultisnips'				" Snippets
Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive'			" Git
" Plug 'dense-analysis/ale' 		" Linting
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'Pocco81/AutoSave.nvim'		" Autosave files
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
set tabstop=4 " Default indentation is 2 spaces long and uses tabs, not spaces
set softtabstop=4
set shiftwidth=4
set history=1000 " Increase the undo limit.
set nospell
set wildignorecase
set noswapfile
set nobackup
set noundofile
set magic " Enable extended regexes
set noerrorbells " Disable error bells
setlocal spell
set t_Co=256   " Set number of colors.
set showmatch  " highlights matching brackets
set incsearch  " search as characters are entered
set nohlsearch " remove highlight
set mouse=a  " enable mouse
set undofile " save undo history
set termguicolors " better gui colors
set autoread

" Spelling
set spelllang=en
setlocal spell
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
" disable bell
set visualbell
set t_vb=
" don't bell or blink
set noerrorbells
set vb t_vb=

" display all matching files when we tab complete
set wildmenu
set wildmode=longest:full,full
set updatetime=300

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
set pastetoggle=<F1>

set autoread " auto-reload files when changed

set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/smarty/*,*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/.sass-cache/*,*/log/*,*/tmp/*,*/build/*,*/ckeditor/*,*/doc/*,*/source_maps/*,*/dist/*

" Backup, swaps
set backupdir=.backup/,~/.backup/,/tmp//
set directory=.swp/,~/.swp/,/tmp//
set undodir=.undo/,~/.undo/,/tmp//

" NerdTree
let NERDTreeShowHidden=1 " Show hidden files
let NERDTreeQuitOnOpen=1   " Hide NerdTree when file is opened 
let g:NERDTreeGitStatusWithFlags=1
let g:NERDTreeMinimalUI=1

" Open NerdTree when file not specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Nerdcommenter
nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle<CR>gv

" Emmet trigger
let g:user_emmet_leader_key=','

" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-pyright',
  \ 'coc-css'
  \ ]

" prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Autocomletion
let g:ycm_python_binary_path = '/usr/bin/python3'

" Cursor
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Trigger snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

set guifont=DroidSansMono\ Nerd\ Font\ 11

" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP'

" FZF settings
let g:fzf_preview_window = ['right:50%', 'ctrl-t']
" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

nmap <C-p> :GFiles<CR>

" RIPGrep
nnoremap <C-g> :Ag<Cr>

" VIM Diff
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=11 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=11 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=11 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

" Ale linter configs
let g:ale_linters= {'javascript' : ['prettier'], 'python': ['flake8']}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\}


" Autosave configs
lua << EOF
local autosave = require("autosave")
autosave.setup({
	enabled = true,
	events = { 'InsertLeave', 'TextChanged' }
})
EOF


let g:ale_fix_on_save = 1
" Autocommands
" autocmd BufRead,BufNewFile * start "Switch to Insert mode when open a file

" format JSON =j
nmap =j :%!python3 -m json.tool

" Nerd commenter
map <Leader>c <Plug>NERDCommenterComment

" Markdown
nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
" nmap <C-p> <Plug>MarkdownPreviewToggle

" Powerline
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup


" Highlight .dotfiles
autocmd BufNewFile,BufRead *.aliases,*.functions set syntax=sh

"Shortcuts
"Shift-Enter for inserting a line before the current line
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
"nmap <DOWN> <NOP> - press down key no operation
map <F5> :NERDTreeToggle<CR>
map <C-a> <esc>ggVG<CR> #select all

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <leader>. :CtrlPTag<cr>

" Move lines up and down
nnoremap <C-Down> :m .+1<CR>==
nnoremap <C-Up> :m .-2<CR>==
inoremap <C-Down> <Esc>:m .+1<CR>==gi
inoremap <C-Up> <Esc>:m .-2<CR>==gi
vnoremap <C-Down> :m '>+1<CR>gv=gv
vnoremap <C-Up> :m '<-2<CR>gv=gv
