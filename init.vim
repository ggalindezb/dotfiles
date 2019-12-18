" Neovim configuration file
" Maintainer:	Gerardo Galindez
" Original File:    2012/09/10
" Created:          2017/04/06
" Last Updated:     2019/10/02
" File Location:    ~/.config/nvim/init.vim
" Sections:
"    -> General                    [GEN]
"    -> Package Manager            [PKG]
"    -> Vim UI                     [VUI]
"    -> Files                      [FIL]
"    -> Keymaps                    [KEY]
"    -> Editing                    [EDT]
"    -> Helpers                    [HLP]
"    -> Autocmds and lang specific [AUL]
"    -> Plugin Keymaps             [PKM]
"    -> Plugin configuration       [PCF]
"    -> References                 [REF]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> General [GEN]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set fileformats=unix,dos,mac                          " Windows sucks
set exrc                                              " Allow local exrc files
set secure                                            " Disable autocmd in local exrc
set hidden                                            " Allow switching buffers without saving
set mouse=                                            " Mouse is for cry babies
set autoread                                          " Set to auto read when a file is changed from the outside
set history=256                                       " Command line history

set undolevels=512                                    " Undo history
silent !mkdir ~/.config/nvim/backups > /dev/null 2>&1 " Remember file changes, even after closing
set undodir=~/.config/nvim/backups
set undofile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Packages [PKG]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install Plug if it's not available
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
  execute "curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
endif

call plug#begin('~/.vim/plugged')

" Still reluctant to remove
" Plug 'fholgado/minibufexpl.vim'                       " Elegant buffer explorer
" Plug 'zefei/vim-wintabs'                              " Modern buffer manager
" Plug 'zefei/vim-wintabs-powerline'                    " Powerline fonts renderers

" Shell extensions
Plug 'bling/vim-airline'                              " Lean and mean status/tabline
Plug 'w0rp/ale'                                       " Asynchronous Lint Engine
Plug 'tpope/vim-fugitive'                             " Git wrapper so awesome, it should be illegal
Plug 'mhinz/vim-signify'                              " Inline git status

" Visual aid
Plug 'ntpeters/vim-better-whitespace'                 " Highlight trailing whitespace
Plug 'kien/rainbow_parentheses.vim'                   " Better Rainbow Parentheses
Plug 'Yggdroot/indentLine'                            " Indention levels with thin vertical lines
"
" External integration
" Plug 'benmills/vimux'                               " Interact with tmux
" Plug 'christoomey/vim-tmux-navigator'               " Seamless navigation between tmux panes and vim splits
" Plug 'wellle/tmux-complete.vim'                     " Insert mode completion of words in adjacent tmux panes
" Plug 'mileszs/ack.vim'                              " Wrapper for ack/ag

" File/Buffer searching
Plug 'kien/ctrlp.vim'                                 " Fuzzy file/buffer finder
Plug 'scrooloose/nerdtree'                            " A tree explorer
"
" Extended motions/operators
Plug 'tmhedberg/matchit'                              " Extended % matching
" Plug 'easymotion/vim-easymotion'                    " Vim motions on speed!
" Plug 'justinmk/vim-sneak'                           " The missing motion for Vim
" Plug 'tpope/vim-repeat'                             " Repeating supported plugin maps
Plug 'tpope/vim-commentary'                           " Comment stuff out
Plug 'godlygeek/tabular'                              " Text filtering and alignment
" Plug 'tpope/vim-surround'                           " Quoting/parenthesizing made simple

" Text objects
Plug 'kana/vim-textobj-user'                          " Text object lib
Plug 'nelstrom/vim-textobj-rubyblock'                 " Selecting Ruby blocks
" Plug 'wellle/targets.vim'                           " Additional text objects
" Plug 'kana/vim-textobj-fold'                        " Text objects for foldings

" Completion
Plug 'mattn/emmet-vim'                                " Emmet expanding abbreviations
Plug 'neoclide/coc.nvim', {'branch': 'release'}       " Language server protocol support
" Plug 'Shougo/deoplete.nvim'                         " Dark powered asynchronous completion framework
" Plug 'SirVer/ultisnips'                             " Ultimate snippet solution for Vim
" Plug 'honza/vim-snippets'                           " Default snippets

" Filetypes
" -> Ruby/Rails
Plug 'vim-ruby/vim-ruby'                              " Ruby
Plug 'tpope/vim-rails'                                " Rails
Plug 'tpope/vim-haml', {'for': 'haml'}                " HAML/SASS
Plug 'slim-template/vim-slim', {'for': 'slim'}        " Slim
Plug 'kchmck/vim-coffee-script'                       " Coffeescript

" -> JS/React
Plug 'pangloss/vim-javascript', {'for': 'javascript'} " Javascript
Plug 'isRuslan/vim-es6'                               " ES6
Plug 'mxw/vim-jsx'                                    " React
Plug 'othree/html5.vim', {'for': 'html'}              " HTML5

" -> Documents
Plug 'plasticboy/vim-markdown', {'for': 'mkd'}        " Markdown

" -> Shell
Plug 'dag/vim-fish', {'for': 'fish' }                 " Fish script

" Colorschemes
" Plug 'ggalindezb/vim-megara'                        " Colorscheme focused on contrast
" Plug 'whatyouhide/vim-gotham'                       " Code never sleeps in Gotham City
" Plug 'tomasr/molokai'                               " Port of monokai
" Plug 'joshdick/onedark.vim'                         " Port of onedark
Plug 'danilo-augusto/vim-afterglow'                   " Port of Afterglow
" Plug 'sjl/badwolf'                                  " Woof Woof

" To check out next:
" Plug 'terryma/vim-multiple-cursors'
" Plug 'tpope/vim-eunuch'
" Plug 'tpope/vim-surround'
" Plug 'thaerkh/vim-indentguides'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Vim UI [VUI]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing position aid
set relativenumber       " Show lines count relative to the current one
set number               " Show the line number for the current line
set numberwidth=3        " 3 columns reserved for the line gutter
set cursorline           " Show the line's ruler
set guicursor=

" Vim command line
set wildmenu             " Autocomplete in cmd
set wildignore=*~,*.swp  " Ignore temp files
set showcmd              " Show partial cmd
set cmdheight=1          " Short cmd line
set laststatus=2         " Always show the status line

" Search options
set smartcase            " Ignore casing unless search a cased word
set hlsearch             " Highlight matches
set incsearch            " Real time match
set magic                " Parse regex in search

" Interface improvements
set noerrorbells         " Fuck bells!
set novisualbell         " Disable flashes
set lazyredraw           " Don't redraw while executing macros

set termguicolors        " True color
syntax enable            " Syntax highlight
colorscheme afterglow    " Set colorscheme

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> File handling [FIL]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't write anything but the file
set nobackup
set nowb
set noswapfile

" Filetypes
" Load filetype rules, not sure if this is needed in Neovim
" filetype plugin on
" filetype indent on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Keymaps [KEY]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: This needs a bit of cleaning up too

""""""""""""""
" Vim keymaps
""""""""""""""
" Use spacebar to repeat last command
nore <Space> .
" Use . as :
nore . :
let mapleader = ","
imap § <Esc>

" Copy/Paste settings
" Disable autoindent to paste from outside
set pastetoggle=<Leader>p
" Copy to the clipboard
vnoremap <C-c> "+y

" Navigation keymaps
" Fast jump
nmap J 5j
nmap K 5k
xmap J 5j
xmap K 5k
" Jump through lines
nnoremap j gj
nnoremap k gk
" Center match when finding
nnoremap n nzz
nnoremap N Nzz

" Buffer keymaps
map <Leader>k :bnext<cr>
map <Leader>j :bprevious<cr>
map <Leader><BS> :bdelete<cr>
map <Leader>f :echo expand('%r')<cr>

" Window keymaps
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Tab keymaps
map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>

" Dismiss search highlight
nmap <Leader><Space> :nohl<cr>

" Giga save. Handle with care
nmap <leader>ww :wall!<cr>
nmap <leader>wq :wqall!<cr>
nmap <leader>qq :qall!<cr>

" Syntax groups
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Editing [EDT]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use 2-space tabs, standard
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Use spaces for tabs
set expandtab
set smarttab

" Indent
set autoindent
set smartindent

" Break long lines, per word, 80 chars per line
set wrap
set linebreak

" Allow backspacing over everything
set backspace=indent,eol,start

" Add an empty line at the end for UNIX compliance
set eol

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-> Helpers [HLP]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: Clean up?
" Currently empty
" Everything in this sections was moved to other places or plugins
" If this is left empty in a few months, I'll get rid of it

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-> Autocmds and lang specific [AUL]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: This needs a proper overhaul, haven't written some of those in years

" Set [...] to 2-space indent
autocmd WinEnter,FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set sts=2 ts=2 sw=2

" Text -> Git, Asciidoc
autocmd FileType text setlocal textwidth=150
autocmd FileType markdown :call MarkdownConfig()
autocmd FileType markdown set nofoldenable

func! MarkdownConfig()
  let g:vim_markdown_conceal = 0
  let g:vim_markdown_conceal_code_blocks = 0
endfunc

" Set SASS to SASS. Duh
autocmd! BufRead,BufNewFile *.sass setfiletype sass

" Set F# lex to F#
autocmd! BufRead,BufNewFile *.fsl setfiletype fsharp
autocmd! BufRead,BufNewFile *.fsy setfiletype fsharp

" Don't change tabs for spaces in Makefiles
autocmd FileType make setlocal noexpandtab

" Delete trailing white space on sav
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
    exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()
autocmd BufWrite *.txt :call DeleteTrailingWS()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Plugin keymaps [PKM]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""
" Commentary keymaps
""""""""""""""""""""
xmap <Leader>c  <Plug>Commentary
nmap <Leader>c  <Plug>Commentary
nmap <Leader>cc <Plug>CommentaryLine
nmap <Leader>cu <Plug>CommentaryUndo

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Plugin configuration [PCF]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: Sort this by function or at least alphabetically, preferably both

""""""
" ALE
""""""
let g:ale_sign_error = '!'
let g:ale_sign_warning = '●'
let g:airline#extensions#ale#enabled = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1

let g:ale_linters = {
\   'ruby': ['rubocop', 'solargraph'],
\}

""""""""""
" CtrlP
""""""""""
" When opening multiple files, open them in the background
let g:ctrlp_open_multiple_files = 'i'
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=40

" Ignore generated files
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = '\v[\/]node_modules$'

""""""""""""
" Airline
""""""""""""
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s:'

"""""""""
" Emmet
"""""""""
" Use Tab to expand, integrate with React
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
let g:user_emmet_leader_key='<C-A>'
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}

"""""""""""
"" NERDTree
"""""""""""
"" Find current file in NERDTree
nnoremap <Leader>hf :NERDTreeFind<CR>
"" Open NERDTree
nnoremap <Leader>n :NERDTreeToggle<CR>

"""""""""""""""""""""""
" Rainbow Parentheses
"""""""""""""""""""""""
" This can probably be configured in the colorscheme. Makes more sense
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3']]

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

""""""""""""
" Afterglow
""""""""""""
let g:afterglow_blackout=1
let g:airline_theme='afterglow'

" TODO: Fix this
" For some reason, not all the syntax rules are being applied up until this
" point. Something is probably triggering a reset. This will require a binary
" search on the whole source
syntax on
hi Normal guibg=NONE ctermbg=NONE

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> References [REF]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This are some of the places I've taken ideas from, to write my Vim config
" over the years. I'm probably missing a lot of sources, since I only seldom
" update properly my config.
"
" If you think I'm missing a source, please contact me.
"
" -> Amix vimrc    [http://amix.dk/vim/vimrc.html]
" -> VimCasts      [http://vimcasts.org]
" -> Gary Berhardt [https://github.com/garybernhardt/dotfiles/blob/master/.vimrc]
" -> Andrew Radev  [http://andrewradev.com]
" -> Rafael Bodill [https://github.com/arafi/vim-config/blob/master/config/general.vim]
" -> Kristijan Husak [https://github.com/kristijanhusak/neovim-config/blob/master/init.vim]
