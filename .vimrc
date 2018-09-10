set nocompatible
filetype off
set t_Co=256
set encoding=utf-8

if has('nvim')
  let s:editor_root=expand("~/.config/nvim")
else
  let s:editor_root=expand("~/.vim")
endif

" Vundle all the things!
let &rtp = &rtp . ',' . s:editor_root . '/bundle/Vundle.vim'
call vundle#begin(s:editor_root . '/bundle')

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'rust-lang/rust.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'plasticboy/vim-markdown'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-ruby/vim-ruby'
Plugin 'airblade/vim-gitgutter'
Plugin 'sirver/ultisnips'
Plugin 'derekwyatt/vim-scala'
Plugin 'honza/vim-snippets'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'lambdatoast/elm.vim'
Plugin 'autozimu/LanguageClient-neovim'
Plugin 'roxma/nvim-completion-manager'
Plugin 'scrooloose/vim-slumlord'
Plugin 'aklt/plantuml-syntax'

call vundle#end()
filetype plugin indent on

set bg=dark
syntax on
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

au FileType make setlocal noexpandtab
au FileType mkd\|text setlocal spell spelllang=en_gb
au FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4

" Remember location in file
let &viminfo = "'10,\"100,:20,%,n" . s:editor_root . "/info"
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" vim-markdown
let g:vim_markdown_folding_disabled=1

" YouCompleteMe
let g:ycm_confirm_extra_conf=0
highlight SignColumn guibg=darkgrey
highlight SignColumn ctermbg=darkgrey
let g:ycm_rust_src_path = '/home/andy/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/'

" Ultisnips
let g:UltiSnipsExpandTrigger="<C-j>"

" AirLine
let g:airline_theme='murmur'

" Slumlord
let g:slumlord_separate_win=1

" Make sure we use cargo to compile rust code
autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo

" LanguageServer
set hidden
let g:LanguageClient_serverCommands = {
      \  'rust': ['rustup', 'run', 'nightly', 'rls'],
      \}
let g:LanguageClient_autoStart = 1
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>

" Commenting blocks of code.
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
