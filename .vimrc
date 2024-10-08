set nocompatible
set t_Co=256
set encoding=utf-8

if has('nvim')
  let s:editor_root=expand("~/.config/nvim")
else
  let s:editor_root=expand("~/.vim")
endif

let g:python3_host_prog = expand("~/.virtualenvs/neovim/bin/python")
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0

call plug#begin(s:editor_root . '/plugs')

" Language syntax/assist
Plug 'rust-lang/rust.vim'
Plug 'plasticboy/vim-markdown'
Plug 'vim-ruby/vim-ruby'
Plug 'derekwyatt/vim-scala'
Plug 'ElmCast/elm-vim'
Plug 'idris-hackers/idris-vim'
Plug 'rhysd/vim-llvm'
Plug 'hashivim/vim-terraform'
Plug 'rodjek/vim-puppet'
Plug 'aklt/plantuml-syntax'
Plug 'cespare/vim-toml'
Plug 'nathanalderson/yang.vim', { 'branch': 'main' }
Plug 'pangloss/vim-javascript'
Plug 'towolf/vim-helm'
Plug 'NoahTheDuke/vim-just'
Plug 'github/copilot.vim'

" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Gutters
Plug 'airblade/vim-gitgutter', { 'branch': 'main' }
Plug 'tpope/vim-fugitive'

" Completion
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'
"Plug 'folke/neoconf.nvim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins', }
Plug 'Shougo/deoplete-lsp'

" Parsing
Plug 'nvim-treesitter/nvim-treesitter'

" Tidyup
Plug 'ntpeters/vim-better-whitespace'

" Other???
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'nvim-tree/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'junegunn/fzf'

call plug#end()

set bg=dark
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set cinoptions=g0:0(0
if $TMUX == ''
  set clipboard=unnamedplus
endif
set mouse=a
set list
set listchars=tab:>-
set laststatus=2
set noshowmode
set autowrite
set updatetime=500
set completeopt-=preview

au FileType make,golang,go setlocal noexpandtab
au FileType markdown,mkd,text setlocal spell spelllang=en_gb
au FileType python,json setlocal shiftwidth=4 tabstop=4 softtabstop=4

" Remember location in file
augroup RestoreCursor
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" vim-markdown
let g:vim_markdown_folding_disabled=1

" AirLine
let g:airline_theme='murmur'

" Deoplete
let g:deoplete#enable_at_startup = 1

" Markdown Preview
let g:mkdp_open_to_the_world = 1
let g:mkdp_port = '9000'
let g:mkdp_browser = 'wslview'

" LanguageServer
lua <<EOF
require ( "rust-tools" ).setup( { server = { cmd = { "ra-multiplex", "client", "--server-path", "/home/andy/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer" } } } )
EOF

" TreeSitter
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "toml" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,

  },

  ident = { enable = true }, 
  rainbow = {
    enable = true,

    extended_mode = true,
    max_file_lines = nil,
  }
}
EOF
autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
