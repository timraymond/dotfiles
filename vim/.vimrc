set nocompatible

" requied by vim-go
filetype plugin indent on
syntax on

" Whitespace
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab

set modeline

"Squirrel away swapfiles to ~/.vim/tmp
set directory=$HOME/.vim/tmp/ 
set t_Co=256

" Plugins

" add the minpac opt plugin and init:
packadd minpac
call minpac#init()

" self-manage minpac
call minpac#add('k-takata/minpac', {'type': 'opt'})

" required plugins
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-surround')
call minpac#add('Lokaltog/vim-easymotion')
call minpac#add('airblade/vim-gitgutter')
call minpac#add('scrooloose/nerdcommenter')
call minpac#add('godlygeek/tabular')
call minpac#add('junegunn/fzf')
call minpac#add('fatih/vim-go')

" Optional plugins
call minpac#add('cespare/vim-toml', {'type': 'opt'})
call minpac#add('hashivim/vim-terraform', {'type': 'opt'})


call minpac#add('tomasr/molokai')
colorscheme molokai

" mappings
let mapleader = "\<Space>"

" Plugin remappings
map <Leader>e <Plug>(easymotion-prefix)
nnoremap <C-L> <C-w>l
nnoremap <C-H> <C-w>h
nnoremap <C-J> <C-w>j
nnoremap <C-K> <C-w>k

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

autocmd FileType go set foldmethod=syntax
autocmd FileType go packadd vim-go

" Relative Line numbers on all windows
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
autocmd BufRead * :set relativenumber
autocmd BufNewFile * :set relativenumber

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
