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
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-haml')
call minpac#add('tpope/vim-obsession')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
" call minpac#add('jiangmiao/auto-pairs')
call minpac#add('rhysd/conflict-marker.vim')
call minpac#add('mbbill/undotree')
call minpac#add('reedes/vim-litecorrect')
call minpac#add('reedes/vim-wordy')
call minpac#add('mattn/webapi-vim')
call minpac#add('majutsushi/tagbar')
call minpac#add('godlygeek/tabular')
call minpac#add('skywind3000/asyncrun.vim')
call minpac#add('machakann/vim-highlightedyank')
call minpac#add('nelstrom/vim-visual-star-search')
call minpac#add('mattn/emmet-vim')

" AI
call minpac#add('Exafunction/codeium.vim', { 'branch': 'main' })
call minpac#add('zbirenbaum/copilot.lua')
call minpac#add('zbirenbaum/copilot-cmp')

" Version control
call minpac#add('tpope/vim-fugitive')
" call minpac#add('airblade/vim-gitgutter')

" Search
call minpac#add('mileszs/ack.vim')

if has('nvim')
  " Colorizer
  call minpac#add('norcalli/nvim-colorizer.lua')

  " Version control decorations
  call minpac#add('lewis6991/gitsigns.nvim')

  " Syntax highlighting
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

" Packages that requires Neovim and plenary.nvim
if has('nvim')
  " Helper functions
  call minpac#add('nvim-lua/plenary.nvim')

  " Fuzzy finder
  call minpac#add('nvim-telescope/telescope.nvim', { 'rev': '0.1.x' })
  call minpac#add('nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' })

  " File browser
  call minpac#add('nvim-telescope/telescope-file-browser.nvim')

  " Linters and formatters
  call minpac#add('jose-elias-alvarez/null-ls.nvim')
  call minpac#add('MunifTanjim/prettier.nvim')

endif

" Javascript
" call minpac#add('MaxMEllon/vim-jsx-pretty')
" call minpac#add('nikvdp/ejs-syntax')
call minpac#add('briancollins/vim-jst') " For JST/EJS syntax

" Applescript
call minpac#add('vim-scripts/applescript.vim')

" Coloschemes and themes
" call minpac#add('morhetz/gruvbox', {'type': 'opt'})
" call minpac#add('sainnhe/gruvbox-material')
call minpac#add('catppuccin/nvim', {'as': 'catppuccin'})
call minpac#add('nvim-tree/nvim-web-devicons')


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
set statusline+=%#PmenuSel#
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

" Codeium key mappings
let g:codeium_no_map_tab = 1
imap <script><silent><nowait><expr> <S-CR> codeium#Accept()
nnoremap <M-/> <Cmd>call codeium#Chat()<CR>
inoremap <M-/> <Cmd>call codeium#Chat()<CR>
vnoremap <M-/> <Cmd>call codeium#Chat()<CR>

" Toggle Undotree
nnoremap <leader>5 :UndotreeToggle<cr>

" Toggle Tagbar
nmap <leader>8 :TagbarToggle<CR>
                                   
" Required by nvim-colorizer
set termguicolors

autocmd VimEnter * CodeiumDisable

" Setup Neovim plugins with not many configurations
if has('nvim')
lua <<EOF
local modules = {
  { name = "nvim-autopairs", setup = { 
       disable_filetype = { "TelescopePrompt", "vim" } 
  }},
  { name = "gitsigns", setup = {} },
  { name = "copilot_cmp", setup = {} },
  { name = "colorizer", setup = {
      'css';
      'javascript';
      html = {
        mode = 'foreground';
      }
  }},
}

for _, module in ipairs(modules) do
  local status, mod = pcall(require, module.name)
  if (not status) then return end
  if type(mod.setup) == "function" then
    mod.setup(module.setup)
  elseif type(mod.setup) == "table" then
    for k, v in pairs(module.setup) do
      mod.setup[k] = v
    end
  end
end

EOF
endif
