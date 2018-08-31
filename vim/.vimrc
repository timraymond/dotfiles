set nocompatible
filetype off

" Whitespace
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab

set modeline

"Squirrel away swapfiles to ~/.vim/tmp
set directory=$HOME/.vim/tmp/ 
set t_Co=256

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-surround'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'kchmck/vim-coffee-script'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'goldfeld/vim-seek'
Plugin 'edkolev/tmuxline.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'tomasr/molokai'
Plugin 'skalnik/vim-vroom'
Plugin 'scrooloose/nerdcommenter'
Plugin 'fatih/vim-go'
Plugin 'mileszs/ack.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-scripts/summerfruit256.vim'
Plugin 'majutsushi/tagbar'
Plugin 'rizzatti/dash.vim'
Plugin 'nathanielc/vim-tickscript'
Plugin 'cespare/vim-toml'
Plugin 'rstacruz/sparkup'
Plugin 'mxw/vim-jsx'
Plugin 'moll/vim-node'
Plugin 'ternjs/tern_for_vim'
Plugin 'ajmwagar/vim-dues'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'nelstrom/vim-markdown-folding'
Plugin 'godlygeek/tabular'
Plugin 'hashivim/vim-terraform'

call vundle#end()            " required
syntax on
filetype plugin indent on    " required

" set background=light
" colorscheme PaperColor
colorscheme molokai

"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" mappings
let mapleader = "\<Space>"

" Plugin remappings
map <Leader>e <Plug>(easymotion-prefix)
" nmap <C-[> <Plug>DashSearch
" nmap <C-{> <Plug>DashGlobalSearch
nnoremap <C-L> <C-w>l
nnoremap <C-H> <C-w>h
nnoremap <C-J> <C-w>j
nnoremap <C-K> <C-w>k

" Insert mappings
" inoremap tk <ESC>

" Leader bindings
nnoremap <leader>d :Explore<CR>
nnoremap <leader>H :noh<CR>
nnoremap <leader>h :set hlsearch<CR>
nnoremap <leader><leader> zA
nnoremap <leader>v :sp $MYVIMRC<CR>
nnoremap <leader>s :source $MYVIMRC<CR>
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>T :tabe<CR>
nnoremap <leader>gi :GoImports<CR>
nnoremap <leader>r :!tt<CR>
nnoremap <leader>R :GoTestFunc<CR>
nnoremap <leader>gI :GoInstall<CR>
nnoremap <leader>gr :GoReferrers<CR>
nnoremap <leader>gc :GoCallers<CR>
nnoremap <leader>p :set paste<CR>
nnoremap <leader>P :set nopaste<CR>

" Swap comma-separated list items with gh and gl
nnoremap <silent> gl "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>
nnoremap <silent> gh "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>

" airline
let g:airline_powerline_fonts = 1
set laststatus=2

" golang
set path+=~/go/src
autocmd FileType go set foldmethod=syntax

" The Silver Searcher
let g:ackprg = 'ag --nogroup --nocolor --column'

" Relative Line numbers on all windows
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
autocmd BufRead * :set relativenumber
autocmd BufNewFile * :set relativenumber

" JSX
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" Wildmode / Wildmenu
" 
" Sets the cool tabcomplete on buffer switching
set wildmode=longest,full
set wildmenu
set wildignore+=.git
set wildoptions=tagfile

" SuperRetab
" Allows retabbing of only the first column

command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g
