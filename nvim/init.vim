call plug#begin('~/.local/share/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'machakann/vim-highlightedyank'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'petRUShka/vim-sage'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'tpope/vim-fugitive'
Plug 'norcalli/snippets.nvim'
Plug 'morhetz/gruvbox'  
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
colorscheme gruvbox

set guicursor=
set shiftwidth=4

"disables useless status bar
set laststatus=0 ruler

" nerdtree config
let g:NERDTreeShowHidden = 0
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nnoremap <silent> <C-G> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

"lsp stuff
lua << EOF
require'snippets'.use_suggested_mappings()
local lsp = require'lspconfig'
lsp.bashls.setup{}
lsp.pyright.setup{}
lsp.cmake.setup{}
lsp.dockerls.setup{}
lsp.jsonls.setup{}
lsp.sqlls.setup{
  cmd = {"sql-language-server","up","--method","stdio"}
}
lsp.tsserver.setup{}
lsp.vimls.setup{}
lsp.vuels.setup{}
lsp.yamlls.setup{}
lsp.ccls.setup{}
lsp.groovyls.setup{
    cmd = { "java", "-jar", "/home/s3np41k1r1t0/.builds/groovy-language-server/build/libs/groovy-language-server-all.jar" },
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lsp.html.setup {
  capabilities = capabilities,
}
lsp.rust_analyzer.setup{}
EOF

"autocomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:completion_enable_auto_popup = 1
set completeopt=longest,menuone,noinsert,noselect
autocmd BufEnter * lua require'completion'.on_attach()

"snippets stuff
let g:completion_enable_snippet = 'snippets.nvim'

"fzf stuff
nnoremap <silent> <C-M> :BTags<CR>
