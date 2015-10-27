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
inoremap tk <ESC>
nnoremap <leader>n :Explore<CR>
nnoremap <leader>h :noh<CR>

" Swap comma-separated list items with gh and gl
nnoremap <silent> gl "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>
nnoremap <silent> gh "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>

" airline
let g:airline_powerline_fonts = 1
set laststatus=2

" golang
autocmd FileType go autocmd BufWritePre <buffer> Fmt
