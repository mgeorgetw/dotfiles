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
call minpac#add('nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'})

" Python
call minpac#add('yssource/python.vim')

" Search
call minpac#add('mileszs/ack.vim')
call minpac#add('ctrlpvim/ctrlp.vim')

" Markdown
" call minpac#add('tpope/vim-markdown')

" Javascript
" call minpac#add('elzr/vim-json')
" call minpac#add('yuezk/vim-js')
" call minpac#add('leafgarland/typescript-vim')
" call minpac#add('MaxMEllon/vim-jsx-pretty')
" call minpac#add('nikvdp/ejs-syntax')
call minpac#add('briancollins/vim-jst')

" CSS
" call minpac#add('hail2u/vim-css3-syntax')
" call minpac#add('groenewege/vim-less')
call minpac#add('stephenway/postcss.vim')

" Apple
call minpac#add('vim-scripts/applescript.vim')

" Coloschemes and themes
call minpac#add('NLKNguyen/papercolor-theme', {'type': 'opt'})
call minpac#add('morhetz/gruvbox', {'type': 'opt'})

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

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ 'link': 'some_bad_symbolic_links',
      \ }
let g:ctrlp_user_command = 'rg %s --files'        " MacOSX/Linux
let g:ctrLp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" vim-markdown
" Highlight YAML frontmatter of markdown
let g:vim_markdown_frontmatter=1
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_conceal = 0

" Lite correct - Lightweight auto-correction for Vim
augroup litecorrect
  autocmd!
  autocmd FileType markdown,mkd call litecorrect#init()
  autocmd FileType textile call litecorrect#init()
augroup END

" Emmit
let g:user_emmet_settings = {
      \   'javascript.jsx' : {
        \       'extends' : 'jsx',
        \   },
        \}

" Toggle Undotree
nnoremap <F5> :UndotreeToggle<cr>

" Toggle Tagbar
nmap <F8> :TagbarToggle<CR>

" " nvim-Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all" or a list of languages
  ensure_installed = {'css', 'fish', 'html', 'javascript', 'json', 'lua', 'markdown', 'regex', 'scss', 'vim', 'yaml'},

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
