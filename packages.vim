" Normally this if-block is not needed, because `:set nocp` is donepacknvim-lua/plenary.nvim
" automatically when .vimrc is found. However, this might be useful
" when you execute `vim -u .vimrc` from the command line.
if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
endif

" Custom commands to update and clean plugins
command! PackUpdate packadd minpac | source $MYVIMRC | redraw | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

" Temporarily disable a plugin
" let g:loaded_airline = 1

" Initiate Plugins {{{
set packpath^=~/.vim
packadd minpac

if !exists('g:loaded_minpac')
  finish
endif

call minpac#init()
" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

" General enhancements
call minpac#add('tpope/vim-commentary')
call minpac#add('suy/vim-context-commentstring')
" call minpac#add('tpope/vim-dispatch')
" call minpac#add('radenling/vim-dispatch-neovim')
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-haml')
call minpac#add('tpope/vim-obsession')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('jiangmiao/auto-pairs')
call minpac#add('rhysd/conflict-marker.vim')
call minpac#add('mbbill/undotree')
call minpac#add('reedes/vim-litecorrect')
call minpac#add('reedes/vim-wordy')
call minpac#add('mattn/webapi-vim')
call minpac#add('majutsushi/tagbar')
call minpac#add('godlygeek/tabular')
call minpac#add('skywind3000/asyncrun.vim')
" call minpac#add('neoclide/coc.nvim', {'branch': 'release'})
call minpac#add('machakann/vim-highlightedyank')
call minpac#add('nelstrom/vim-visual-star-search')
call minpac#add('airblade/vim-gitgutter')
call minpac#add('mattn/emmet-vim')
" call minpac#add('honza/vim-snippets')

" Search
call minpac#add('mileszs/ack.vim')

if has('nvim')
  call minpac#add('nvim-telescope/telescope.nvim', { 'rev': '0.1.x' })
  call minpac#add('nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' })
endif

if has('nvim')
  call minpac#add('nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'})

  " Autotag and autopair with nvim-treesitter
  call minpac#add('windwp/nvim-ts-autotag')
  call minpac#add('windwp/nvim-autopairs')

  " Language Server Protocol
  call minpac#add('williamboman/mason.nvim', { 'do': ':MasonUpdate' })
  call minpac#add('williamboman/mason-lspconfig.nvim')
  call minpac#add('neovim/nvim-lspconfig')

  " Completion and snippets
  call minpac#add('hrsh7th/nvim-cmp')
  call minpac#add('hrsh7th/cmp-nvim-lsp')
  call minpac#add('hrsh7th/cmp-buffer')
  call minpac#add('saadparwaiz1/cmp_luasnip')
  call minpac#add('L3MON4D3/LuaSnip', {'tag': 'v1.*', 'do': 'make install_jsregexp'})
endif

" Install linters, formatters and snippets
if has('nvim')
  call minpac#add('nvim-lua/plenary.nvim')
  call minpac#add('jose-elias-alvarez/null-ls.nvim')
  call minpac#add('MunifTanjim/prettier.nvim')
endif

" Javascript
" call minpac#add('MaxMEllon/vim-jsx-pretty')
" call minpac#add('nikvdp/ejs-syntax')
call minpac#add('briancollins/vim-jst') " For JST/EJS syntax

" Apple
call minpac#add('vim-scripts/applescript.vim')

" Coloschemes and themes
" call minpac#add('morhetz/gruvbox', {'type': 'opt'})
" call minpac#add('sainnhe/gruvbox-material')
call minpac#add('catppuccin/nvim', {'as': 'catppuccin'})

""" Plugin configurations
" Fugitive and status line
set statusline=
set statusline+=%#PmenuSel#
set statusline+=\ %{FugitiveStatusline()}\ 
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\ 
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

" Lite correct - Lightweight auto-correction for Vim
augroup litecorrect
  autocmd!
  autocmd FileType markdown,mkd call litecorrect#init()
  autocmd FileType textile call litecorrect#init()
augroup END

" Emmit
let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \    'extends' : 'jsx',
      \  },
      \}

" Toggle Undotree
nnoremap <F5> :UndotreeToggle<cr>

" Toggle Tagbar
nmap <F8> :TagbarToggle<CR>
