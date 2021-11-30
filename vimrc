set shell=/usr/local/bin/fish
filetype plugin indent on
runtime macros/matchit.vim " Build in 'Match it' extension

source ~/dotfiles/packages.vim

" Editing {{{
set encoding=utf-8
set virtualedit=all
au FileType crontab setlocal bkc=yes  " enable saving crontab file
set nrformats= " Enables adding numbers with padding zeroes

" Disable IME when switching to normal mode. Does not work with NeoVim.
set noimdisable
autocmd! InsertLeave * set imdisable|set iminsert=0
autocmd! InsertEnter * set noimdisable|set iminsert=0
autocmd BufEnter * silent! lcd %:p:h
" Enable mouse
if has('mouse')
    set mouse=a
endif
" Live substitution
if has('nvim')
    set inccommand=split
endif
" Highlight yanked text
augroup LuaHighlight
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END
" highlightedyank - make it work with older Vim
if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
endif

" Spaces and Tabs
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬
"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59
set tabstop=4       " number of visual spaces per TAB
set shiftwidth=4
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set backspace=indent,eol,start " make backspace work again

" Only do this part when compiled with support for autocommands
if has("autocmd")
    " Syntax of these languages is fussy over tabs Vs spaces
    autocmd FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
    autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    " Customisations based on house-style (arbitrary)
    autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType css setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
    autocmd FileType javascript.jsx setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
    autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    " Treat .rss files as XML
    autocmd BufNewFile,BufRead *.rss setfiletype xml
    autocmd BufNewFile,BufRead *.txt setfiletype markdown
endif

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
    let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
    if l:tabstop > 0
        let &l:sts = l:tabstop
        let &l:ts = l:tabstop
        let &l:sw = l:tabstop
    endif
    call SummarizeTabs()
endfunction
function! SummarizeTabs()
    try
        echohl ModeMsg
        echon 'tabstop='.&l:ts
        echon ' shiftwidth='.&l:sw
        echon ' softtabstop='.&l:sts
        if &l:et
            echon ' expandtab'
        else
            echon ' noexpandtab'
        endif
    finally
        echohl None
    endtry
endfunction

" Tidying whitespace (http://vimcasts.org/episodes/tidying-whitespace/)
function! Preserve(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
nmap _= :call Preserve("normal gg=G")<CR>
" }}}

" UI Layout {{{
" Apply GUI font only to MacVim because VimR does not like it.
if has("gui_macvim")
    set guifont=PragmataPro:h14
    set antialias
    set gcr+=a:blinkon0
endif
" Enable True Color support
if (empty($TMUX))
    if (has("nvim"))
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    if (has("termguicolors"))
        set termguicolors
    endif
endif
silent! colorscheme gruvbox  " Default theme
set hidden
let g:airline_theme='gruvbox'
set background=light
" Choose theme according to Mac's dark mode
" if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
"     set background=dark
" else
"     set background=light
" endif
set t_Co=256
set number              " show line numbers
" set relativenumber      " turn on relative line number
set showcmd             " show command in bottom bar
set nocursorline        " do not highlight current line, drastically improves speed
set wildmenu            " visual autocomplete for command menu
set wildmode=full
set showmatch           " highlight matching [{()}]
set splitbelow          " More natural split opening
set splitright

" Customize Coc colors
" func! s:my_colors_setup() abort
"     hi CocInfoSign ctermfg=3 guifg=#808000
" endfunc
" augroup colorscheme_coc_setup | au!
"     au ColorScheme * call s:my_colors_setup()
" augroup END

" Show relative number in normal mode
" augroup numbertoggle
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"   autocmd BufEnter,FocusLost,InsertEnter * set norelativenumber
" augroup END

" Cursor changes between modes.
let &t_SI.="\e[6 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[2 q" "EI = NORMAL mode (ELSE)
" }}}

" Navigation {{{
command CWD cd %:p:h    " CWD = Change to Currently working directory
" set autochdir           " working directory is always the same as the file editing
" Opening files located in the same directory as the current file
cnoremap <expr> %%  getcmdtype() == ':' ? fnameescape(expand('%:h')).'/' : '%%'
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%
" Mappings to Quickly Traverse Vim's Buffer Lists
nnoremap <silent> [b :bprevious <CR>
nnoremap <silent> ]b :bnext <CR>
nnoremap <silent> [B :bfirst <CR>
nnoremap <silent> ]B :blast <CR>
if has('nvim')
    " Getting out of Terminal mode
    tnoremap <Esc> <C-\><C-n>
    tnoremap <A-[> <Esc>
    " Switch between windows
    " Terminal mode:
    tnoremap <M-h> <c-\><c-n><c-w>h
    tnoremap <M-j> <c-\><c-n><c-w>j
    tnoremap <M-k> <c-\><c-n><c-w>k
    tnoremap <M-l> <c-\><c-n><c-w>l
    " Insert mode:
    inoremap <M-h> <Esc><c-w>h
    inoremap <M-j> <Esc><c-w>j
    inoremap <M-k> <Esc><c-w>k
    inoremap <M-l> <Esc><c-w>l
    " Visual mode:
    vnoremap <M-h> <Esc><c-w>h
    vnoremap <M-j> <Esc><c-w>j
    vnoremap <M-k> <Esc><c-w>k
    vnoremap <M-l> <Esc><c-w>l
    " Normal mode:
    nnoremap <M-h> <c-w>h
    nnoremap <M-j> <c-w>j
    nnoremap <M-k> <c-w>k
    nnoremap <M-l> <c-w>l
endif
" }}}

" Search and replace {{{
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set smartcase           " when uppercase included, search becomes case-sensitive
"set path+=**            " Search down in subfolders
set wildignore+=**/node_modules/** " Ignores node_modules while searching with :find
set history=200         " Saves command history up to 200 records
" Use Ripgrep with Ack.vim
let g:ackprg = 'rg --vimgrep --no-heading'
" Enables history filtering with <C-p> <C-n>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" Search for the Current Selection
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction
" Replay substitution with & while preserving flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>
" }}}

" Folding {{{
set foldenable          " enable folding
set foldlevelstart=3    " open most folds by default
set foldnestmax=10      " 10 nested fold max
" space open/closes folds
nnoremap <space> za
set foldmethod=indent   " fold based on indent level
" }}}

" Movement {{{
" move vertically by visual line
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
" highlight last inserted text
nnoremap gV `[v`]
" }}}

" Leader Shortcuts {{{
let mapleader=","       " leader is comma
" remap comma for reverse character search
noremap \ ,
" edit vimrc/fish and load vimrc bindings
nnoremap <leader>vc :vsp ~/.vim/vimrc<CR>
nnoremap <leader>fc :vsp ~/.config/fish/config.fish<CR>
" reload vim
nnoremap <leader>rl :so $MYVIMRC<CR>
" go to the previous/next buffer
nnoremap <leader>p :bp<CR>
nnoremap <leader>n :bn<CR>
" Close buffer without closing the split window
nnoremap <leader>d :b#<bar>bd#<CR>
" Toggle invisible characters
nnoremap <leader>l :set list!<CR>
" Count highlighted matches
nnoremap <leader>mc :%s///gn<CR>
" }}}

" Shortcuts {{{
" Set system keyboard as default
set clipboard+=unnamedplus
" Copy and paste from system clipboard
map "*y :w !LANG=en_US.UTF-8 pbcopy<CR><CR>
map "*p :r !LANG=en_US.UTF-8 pbpaste<CR><CR>
" inoremap <C-v> <ESC>"+pa
vnoremap <C-c> "*y
vnoremap <C-x> "*d
" Shortcut to mute highlighting
nnoremap <silent> <C-l> :<C-u> nohlsearch <CR><C-l>
" Toggle netrw
nnoremap <C-e> :e.<CR>
" Toggle Undotree
nnoremap <F5> :UndotreeToggle<cr>
" Toggle Tagbar
nmap <F8> :TagbarToggle<CR>
" Prettify JSON file using Python
nmap =j :%!python -m json.tool<CR>
" Open current document in Typora
command! Typora :silent !open -a Typora.app '%:p'<cr>
" Open current document in Marked
command! Marked :silent !open -a Marked.app '%:p'<cr>
if has("gui_macvim")
    " Emulate the system clipboard(only in MacVim)
    inoremap <D-v> <ESC>"+pa
    vnoremap <D-c> "*y
    vnoremap <D-x> "*d
    " Use Ctrl-TAB to switch between buffers
    nnoremap <C-TAB> :bn<CR>
endif
" }}}

" Syntax {{{
syntax enable	    " enable syntax processing
" Omni Completion settings
"set omnifunc=syntaxcomplete#Complete
"set omnifunc=ale#completion#OmniFunc
"set completeopt=menu,preview,noselect,noinsert
autocmd BufNewFile,BufRead *.scss             set ft=scss.css
" Python
let g:python_host_prog = '/usr/local/bin/python3'
let g:python2_host_prog = '/usr/local/bin/python2.7'
let g:python3_host_prog = '/usr/local/bin/python3'
" Javascript
" Enables syntax highlighting for JSDocs.
let g:javascript_plugin_jsdoc = 1
" Enables some additional syntax highlighting for NGDocs.
let g:javascript_plugin_ngdoc = 1
let g:jsx_ext_required = 1 " Allow JSX in normal JS files
" }}}

" Auto Minification with yuicompressor
" http://vim.wikia.com/wiki/Auto_execute_yuicompressor {{{
function Js_css_compress ()
    let cwd = expand('<afile>:p:h')
    let nam = expand('<afile>:t:r')
    let ext = expand('<afile>:e')
    if -1 == match(nam, '[\._]src$')
        let minfname = nam.'.min.'.ext
    else
        let minfname = substitute(nam, '[\._]src$', '', 'g').'.'.ext
    endif
    if ext == 'less'
        if executable('lessc')
            cal system( 'lessc '.cwd.'/'.nam.'.'.ext.' &')
        endif
    else
        if filewritable(cwd.'/'.minfname)
            if ext == 'js' && executable('closure-compiler')
                cal system( 'closure-compiler --js '.cwd.'/'.nam.'.'.ext.' > '.cwd.'/'.minfname.' &')
            elseif executable('yuicompressor')
                cal system( 'yuicompressor '.cwd.'/'.nam.'.'.ext.' > '.cwd.'/'.minfname.' &')
            endif
        endif
    endif
endfunction
autocmd FileWritePost,BufWritePost *.js :call Js_css_compress()
autocmd FileWritePost,BufWritePost *.css :call Js_css_compress()
autocmd FileWritePost,BufWritePost *.less :call Js_css_compress()
" }}}
