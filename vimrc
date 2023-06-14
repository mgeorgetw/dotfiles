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
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

" highlightedyank - make it work with older Vim
if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
endif

" Enables persistent undo (except for temporary files)
set undofile
if !has('nvim')
  set undodir=~/.vim/undo
endif

augroup vimrc
  autocmd!
  autocmd BufWritePre /tmp/* setlocal noundofile
augroup END

" Spaces and Tabs
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" Set listmode character (:h listchas) colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

set tabstop=2       " number of visual spaces per TAB
set shiftwidth=2
set softtabstop=2   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set backspace=indent,eol,start " make backspace work again

" Only do this part when compiled with support for autocommands
if has("autocmd")
  autocmd BufNewFile,BufRead *.rss setfiletype xml
  autocmd BufNewFile,BufRead *.txt setfiletype markdown
  autocmd BufNewFile,BufRead *.scss setfiletype scss.css
  " autocmd BufNewFile,BufRead *.ejs setfiletype html

  " Turn on spell checking
  autocmd FileType markdown,md setlocal spell spelllang=en_us
  autocmd FileType text,textile setlocal spell spelllang=en_us
endif

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
endif

set t_Co=256
set number              " show line numbers
set relativenumber      " turn on relative line number
set showcmd             " show command in bottom bar
set nocursorline        " do not highlight current line, drastically improves speed
set wildmenu            " visual autocomplete for command menu
set wildmode=full
set showmatch           " highlight matching [{()}]
set splitbelow          " More natural split opening
set splitright

" Set a colorscheme
set background=dark
let g:gruvbox_material_foreground = 'original'
silent! colorscheme catppuccin  " Default theme

" Choose theme according to Mac's dark mode
" if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
"     set background=dark
"     silent! colorscheme catppuccin-mocha
" else
"     set background=light
"     silent! colorscheme catppuccin-latte
" endif

" Show relative number only in normal mode
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufEnter,FocusLost,InsertEnter * set norelativenumber
augroup END

" Make cursor change between modes.
let &t_SI.="\e[6 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[2 q" "EI = NORMAL mode (ELSE)
" }}}

" Navigation {{{
command CWD cd %:p:h    " CWD = Change to Currently working directory
" set autochdir           " Make working directory always the same as current file

" Configuring Netrw
" Open netrw
nnoremap <C-e> :e.<CR>
let g:netrw_liststyle=3   " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()

" Stop netrw from creating unnecessary buffers
let g:netrw_fastbrowse = 0

" Opening files located in the same directory as current file
cnoremap <expr> %%  getcmdtype() == ':' ? fnameescape(expand('%:h')).'/' : '%%'

" Mappings to Quickly Traverse Vim's Buffer Lists
nnoremap <silent> [b :bprevious <CR>
nnoremap <silent> ]b :bnext <CR>
nnoremap <silent> [B :bfirst <CR>
nnoremap <silent> ]B :blast <CR>

if has('nvim')
  " To get out of Terminal mode easily
  tnoremap <ESC> <C-\><C-n>
  tnoremap <A-[> <ESC>

  " Use the same commands to switch between windows
  " In terminal mode:
  tnoremap <M-h> <c-\><c-n><c-w>h
  tnoremap <M-j> <c-\><c-n><c-w>j
  tnoremap <M-k> <c-\><c-n><c-w>k
  tnoremap <M-l> <c-\><c-n><c-w>l
  " In insert mode:
  inoremap <M-h> <Esc><c-w>h
  inoremap <M-j> <Esc><c-w>j
  inoremap <M-k> <Esc><c-w>k
  inoremap <M-l> <Esc><c-w>l
  " In visual mode:
  vnoremap <M-h> <Esc><c-w>h
  vnoremap <M-j> <Esc><c-w>j
  vnoremap <M-k> <Esc><c-w>k
  vnoremap <M-l> <Esc><c-w>l
  " In normal mode:
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
set path+=**            " Search down in subfolders
set wildignore+=**/node_modules/** " Ignores node_modules while searching with :find
set history=200         " Saves command history up to 200 records

" Use Ripgrep with Ack.vim
let g:ackprg = 'rg --vimgrep --no-heading'

" Enables history filtering with <C-p> <C-n>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Search for currently selected text
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
" Set leader key
let mapleader=" "
nnoremap <SPACE> <Nop>

" Edit vimrc/fish and load vimrc bindings
nnoremap <leader>vc :vsp ~/.vim/vimrc<CR>
nnoremap <leader>fc :vsp ~/.config/fish/config.fish<CR>

" Reload vim
nnoremap <leader>rl :so $MYVIMRC<CR>

" Go to the previous/next buffer
nnoremap <leader>p :bp<CR>
nnoremap <leader>n :bn<CR>

" Close buffer without closing the split window
nnoremap <leader>d :b#<bar>bd#<CR>

" Toggle listmode characters
nnoremap <leader>l :set list!<CR>

" Count highlighted matches
nnoremap <leader>mc :%s///gn<CR>
" }}}

" Shortcuts {{{
" Set system clipboard as default
set clipboard+=unnamedplus

" Copy and paste from system clipboard
map "*y :w !LANG=en_US.UTF-8 pbcopy<CR><CR>
map "*p :r !LANG=en_US.UTF-8 pbpaste<CR><CR>

" inoremap <C-v> <ESC>"+pa
vnoremap <C-c> "*y
vnoremap <C-x> "*d

" Emulate the system clipboard(only in MacVim)
if has("gui_macvim")
  inoremap <D-v> <ESC>"+pa
  vnoremap <D-c> "*y
  vnoremap <D-x> "*d
  " Use Ctrl-TAB to switch between buffers
  nnoremap <C-TAB> :bn<CR>
endif

" Mute highlighting
nnoremap <silent> <C-l> :<C-u> nohlsearch <CR><C-l>

" Prettify JSON file using Python
nmap =j :%!python -m json.tool<CR>

" Open current document in Marked
command! Marked :silent !open -a Marked.app '%:p'<cr>
" }}}

" Syntax {{{
if !has('nvim')
  syntax enable	    " enable syntax processing
endif

" Javascript
let g:jsx_ext_required = 1 " Allow JSX in normal JS files
" }}}

" Integrations {{{
" Python
let g:python_host_prog = '/usr/local/bin/python3'
let g:python2_host_prog = '/usr/local/bin/python2.7'
let g:python3_host_prog = '/usr/local/bin/python3'

let g:ruby_host_prog = '/usr/local/lib/ruby/gems/3.1.0/bin/neovim-ruby-host'
" }}}
