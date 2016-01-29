set nocompatible
filetype off

" Whitespace
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab

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
Plugin 'goldfeld/vim-seek'
Plugin 'edkolev/tmuxline.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'tomasr/molokai'
Plugin 'skalnik/vim-vroom'
Plugin 'vim-scripts/ruby-matchit'
Plugin 'scrooloose/nerdcommenter'
Plugin 'fatih/vim-go'
Plugin 'mileszs/ack.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-scripts/summerfruit256.vim'
Plugin 'majutsushi/tagbar'
Plugin 'rizzatti/dash.vim'
Plugin 'nathanielc/vim-tickscript'
Plugin 'cespare/vim-toml'

call vundle#end()            " required
syntax on
filetype plugin indent on    " required
colorscheme molokai
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

runtime macros/matchit.vim

" mappings
let mapleader = "\<Space>"

" Plugin remappings
map <Leader>e <Plug>(easymotion-prefix)
nmap <C-[> <Plug>DashSearch
nmap <C-{> <Plug>DashGlobalSearch

" Insert mappings
inoremap tk <ESC>

" Leader bindings
nnoremap <leader>d :Explore<CR>
nnoremap <leader>h :noh<CR>
nnoremap <leader>H :set hlsearch<CR>
nnoremap <leader><leader> za
nnoremap <leader>v :sp $MYVIMRC<CR>
nnoremap <leader>s :source $MYVIMRC<CR>
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>T :tabe<CR>
nnoremap <leader>o<leader> zO
nnoremap <leader>gi :GoImports<CR>
nnoremap <leader>r :GoTest ./...<CR>

" Swap comma-separated list items with gh and gl
nnoremap <silent> gl "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>
nnoremap <silent> gh "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>

" Pry
nnoremap <leader>p :normal orequire 'pry'; binding.pry<ESC>
nnoremap <leader>P :normal Orequire 'pry'; binding.pry<ESC>

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
