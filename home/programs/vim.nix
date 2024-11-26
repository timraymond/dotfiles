{ config, lib, pkgs, ... }:
{
    programs.vim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        vim-fugitive
        vim-unimpaired
        vim-surround
        vim-dispatch
        vim-abolish
        vim-easymotion
        vim-gitgutter
        nerdcommenter
        tabular
        ale
        tagbar
        vim-go
        pkgs.space-vim-theme
        fzf-vim
        tagbar
        taboo-vim
        vim-helm
        pkgs.vim-bicep
        vim-terraform
        ultisnips
      ];
      extraConfig = ''
        colorscheme space_vim_theme
        set background=dark

        let mapleader = "\<Space>"

        set directory=~/.vim/swapfiles

        let g:UltiSnipsSnippetDirectories = ["snips"]

        map <Leader>e <Plug>(easymotion-prefix)

        nnoremap <leader>gs :Git<CR>
        nnoremap <leader>gb :Git blame<CR>
        nnoremap <leader>gd :Gdiff<CR>
        nnoremap <leader>T :tabe<CR>

        nnoremap <leader>r :GoTest<CR>
        nnoremap <leader>R :GoTestFunc<CR>
        nnoremap <leader>gr :GoReferrers<CR>
        nnoremap <leader>gc :GoCallers<CR>

        nnoremap <leader>f :FZF<CR>

        nnoremap <leader>t :TagbarToggle<CR>

        set wildmode=longest,full
        set wildmenu
        set wildignore+=.git
        set wildoptions=tagfile

        cabbrev E Explore

        autocmd InsertEnter * :set number
        autocmd InsertLeave * :set relativenumber
        autocmd BufRead * :set relativenumber
        autocmd BufNewFile * :set relativenumber

        set ttymouse=xterm2
        let &t_SI = "\<Esc>[6 q"
        let &t_SR = "\<Esc>[3 q"
        let &t_EI = "\<Esc>[2 q"
        set mouse=a
      '';
    };
}
