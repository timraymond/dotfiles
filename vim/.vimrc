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
call minpac#add('tpope/vim-dispatch')
call minpac#add('Lokaltog/vim-easymotion')
call minpac#add('airblade/vim-gitgutter', {'rev': 'main'})
call minpac#add('scrooloose/nerdcommenter')
call minpac#add('godlygeek/tabular')
call minpac#add('junegunn/fzf')
call minpac#add('w0rp/ale')
call minpac#add('liuchengxu/space-vim-theme')
call minpac#add('preservim/tagbar')
call minpac#add('jremmen/vim-ripgrep')
call minpac#add('gcmt/taboo.vim')

" Optional plugins
call minpac#add('hsanson/vim-openapi', {'type': 'opt'})
call minpac#add('cespare/vim-toml', {'type': 'opt'})
call minpac#add('hashivim/vim-terraform', {'type': 'opt'})
call minpac#add('jasontbradshaw/pigeon.vim', {'type': 'opt'})
call minpac#add('ledger/vim-ledger', {'type': 'opt'})
call minpac#add('plasticboy/vim-markdown', {'type': 'opt'})
call minpac#add('carlsmedstad/vim-bicep', {'type': 'opt'})
call minpac#add('fatih/vim-go', {'type': 'opt'})
call minpac#add('xavierchow/vim-swagger-preview', {'type': 'opt'})


call minpac#add('tomasr/molokai')
colorscheme space_vim_theme

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
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>T :tabe<CR>
nnoremap <leader>gi :GoImports<CR>
nnoremap <leader>r :GoTest<CR>
nnoremap <leader>R :GoTestFunc<CR>
nnoremap <leader>gI :GoInstall<CR>
nnoremap <leader>gr :GoReferrers<CR>
nnoremap <leader>gc :GoCallers<CR>
nnoremap <leader>p :set paste<CR>
nnoremap <leader>P :set nopaste<CR>
nnoremap <leader>f :FZF<CR>
nnoremap <leader>bl :set background=light<CR>
nnoremap <leader>bd :set background=dark<CR>

autocmd FileType go set foldmethod=syntax
autocmd FileType go packadd vim-go

autocmd FileType bicep packadd vim-bicep

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

" Default background to dark
set background=dark

" gopls

let g:go_gopls_gofumpt = v:true
let g:go_gopls_local = "dnc/"
let g:ale_go_gopls_init_options = {
  \  'ui.diagnostic.analyses': {
    \ 'unusedparams': v:true,
    \ 'nilness': v:true,
    \ 'unusedwrite': v:true,
    \ 'useany': v:true,
  \ },
\}

" ALE
let g:ale_linters = {
  \ 'go': ['gopls'],
  \ 'proto': ['prototool-lint'],
  \ 'yaml': ['yamllint'],
  \ 'openapi': ['ibm_validator'],
  \ 'sh': ['shellcheck'],
  \}

"let g:ale_go_golangci_lint_executable = 'golangci-lint'
"let g:ale_go_golangci_lint_options = '--fast --skip-dirs-use-default --new'

" I run this from docker because node is a nightmare
let g:ale_openapi_ibm_validator_executable = 'docker run --rm jamescooke/openapi-validator'
let g:ale_yaml_yamllint_options = '-d "{extends: relaxed, rules: {line-length: disable}}'

"let g:ale_lint_on_save = 1

" Mouse
set mouse=a

" Fix Easymotion stomping on :E for :Explore
cabbrev E Explore

" Ledger
function LoadLedger()
  packadd vim-ledger
  set ft=ledger
  set foldmethod=syntax
  nnoremap <leader>st :call ledger#transaction_state_toggle(line('.'), ' *?!')<CR>
endfunction

autocmd BufRead *.ledger call LoadLedger()

" Remap paragraph-wise moves for transactions
autocmd FileType ledger noremap { ?^\d<CR>
autocmd FileType ledger noremap } /^\d<CR>

autocmd FileType ledger inoremap <silent> <Tab> <C-r>=ledger#autocomplete_and_align()<CR>
autocmd FileType ledger vnoremap <silent> <Tab> :LedgerAlign<CR>

" Taboo
let g:taboo_renamed_tab_format = " %N:[%l]%m "

augroup folds
  au!
  au InsertEnter * let w:oldfdm = &l:foldmethod | setlocal foldmethod=manual
  au InsertLeave *
        \ if exists('w:oldfdm') |
        \   let &l:foldmethod = w:oldfdm |
        \   unlet w:oldfdm |
        \ endif |
        \ normal! zv
augroup END
