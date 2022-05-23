if !exists("g:vscode")
  call plug#begin('~/.local/share/nvim/plugged')
  Plug 'scrooloose/nerdtree'
  Plug 'machakann/vim-highlightedyank'
  Plug 'drewtempelmeyer/palenight.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/fzf'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': 'TSUpdate' }
  call plug#end()

  " general config
  set splitright
  set splitbelow

  set mouse=a
  set clipboard=unnamedplus
  set number
  set relativenumber

  syntax enable
  set background=dark
  set termguicolors
  set background=dark
  colorscheme palenight

  set guicursor=
  set shiftwidth=2
  set tabstop=2

  set timeoutlen=500

  "disables useless status bar
  set laststatus=0 ruler

  " nerdtree config
  let g:NERDTreeShowHidden = 0
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeIgnore = []
  " Automaticaly close nvim if NERDTree is only thing left open
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  nnoremap <silent> <C-G> :NERDTreeToggle<CR>
  let NERDTreeQuitOnOpen=1

  lua << EOF
  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { "c", "lua", "cpp" },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- List of parsers to ignore installing (for "all")
    ignore_install = { "javascript" },
    highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
    },
  }

EOF

  nnoremap <silent> <expr> <C-F> (len(system("git rev-parse")) ? ":Files" : ":GFiles")."\<CR>"

endif



set clipboard=unnamedplus
set number
set relativenumber
