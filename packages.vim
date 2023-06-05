" Normally this if-block is not needed, because `:set nocp` is done
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
call minpac#add('neoclide/coc.nvim', {'branch': 'release'})
call minpac#add('machakann/vim-highlightedyank')
call minpac#add('nelstrom/vim-visual-star-search')
call minpac#add('airblade/vim-gitgutter')
call minpac#add('mattn/emmet-vim')
call minpac#add('honza/vim-snippets')

if has('nvim')
  call minpac#add('nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'})
endif

" Search
call minpac#add('mileszs/ack.vim')

if has('nvim')
  call minpac#add('nvim-lua/plenary.nvim')
  call minpac#add('nvim-telescope/telescope.nvim', { 'rev': '0.1.x' })
  call minpac#add('nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' })
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

" " nvim-Treesitter
if has('nvim')
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all" or a list of languages
  ensure_installed = {'css', 'bash', 'fish', 'html', 'javascript', 'typescript', 'tsx', 'json', 'lua', 'markdown', 'regex', 'scss', 'vim', 'yaml', 'python'},

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = { "" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = { enable = true },
  indent = { enable = true },
}
EOF
endif
