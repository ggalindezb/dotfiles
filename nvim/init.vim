" Neovim configuration file
" Maintainer:	Gerardo Galindez
" Original File:    2012/09/10
" Created:          2017/04/06
" Last Updated:     2021/02/21
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

" Shell extensions
Plug 'bling/vim-airline'                              " Lean and mean status/tabline
Plug 'dense-analysis/ale'                             " Asynchronous Lint Engine
Plug 'tpope/vim-fugitive'                             " Git wrapper so awesome, it should be illegal
Plug 'mhinz/vim-signify'                              " Inline git status

" Visual aid
Plug 'ntpeters/vim-better-whitespace'                 " Highlight trailing whitespace
Plug 'luochen1990/rainbow'                            " Rainbow Parentheses Improved
Plug 'Yggdroot/indentLine'                            " Indention levels with thin vertical lines

" File/Buffer searching
Plug 'cloudhead/neovim-fuzzy'                         " fzy fuzzy file finder integration
Plug 'preservim/nerdtree'                             " A tree explorer
Plug 'Xuyuanp/nerdtree-git-plugin'                    " NERDTree git status

" Extended motions/operators
Plug 'andymass/vim-matchup'                           " Even better %
" Plug 'easymotion/vim-easymotion'                    " Vim motions on speed!
" Plug 'justinmk/vim-sneak'                           " The missing motion for Vim
" Plug 'tpope/vim-repeat'                             " Repeating supported plugin maps
Plug 'tpope/vim-commentary'                           " Comment stuff out
" Plug 'preservim/nerdcommenter' " Intensely nerdy commenting powers
Plug 'godlygeek/tabular'                              " Text filtering and alignment
" Plug 'junegunn/vim-easy-align'                        " A Vim alignment plugin
Plug 'machakann/vim-sandwich'                         " Search/select/edit sandwiched textobjects
Plug 'arthurxavierx/vim-caser'                        " Easily change word casing

" Text objects
Plug 'kana/vim-textobj-user'                          " Text object lib
Plug 'nelstrom/vim-textobj-rubyblock'                 " Selecting Ruby blocks
" Plug 'wellle/targets.vim'                           " Additional text objects
" Plug 'kana/vim-textobj-fold'                        " Text objects for foldings

" Completion
Plug 'mattn/emmet-vim'                                " Emmet expanding abbreviations
Plug 'neoclide/coc.nvim', {'branch': 'release'}       " Language server protocol support
Plug 'honza/vim-snippets'                             " One bunch of snips

" External services
" Plug 'wakatime/vim-wakatime'                          " Wakatime tracking

" Filetypes
Plug 'othree/html5.vim', {'for': 'html'}              " HTML5
Plug 'hail2u/vim-css3-syntax'                         " CSS 3
Plug 'styled-components/vim-styled-components', {'branch': 'main'}

" -> Ruby/Rails
Plug 'vim-ruby/vim-ruby'                              " Ruby
Plug 'tpope/vim-rails'                                " Rails
Plug 'tpope/vim-haml', {'for': 'haml'}                " HAML/SASS
Plug 'slim-template/vim-slim', {'for': 'slim'}        " Slim
Plug 'kchmck/vim-coffee-script'                       " Coffeescript

" -> JS
Plug 'othree/yajs.vim', {'for': 'javascript'}         " Javascript
Plug 'isRuslan/vim-es6'                               " ES6
Plug 'othree/es.next.syntax.vim', {'for': 'javascript'}
Plug 'leafgarland/typescript-vim'                     " Typescript
Plug 'MaxMEllon/vim-jsx-pretty'                       " JSX
Plug 'peitalin/vim-jsx-typescript'                    " TSX
Plug 'leafOfTree/vim-vue-plugin', {'for': 'vue'}      " Vue

" -> Documents
Plug 'plasticboy/vim-markdown', {'for': 'mkd'}        " Markdown

" -> Shell
Plug 'dag/vim-fish', {'for': 'fish' }                 " Fish script

" -> Stuff
Plug 'chr4/nginx.vim'                                 " Improved nginx

" Colorschemes
" Plug 'ggalindezb/vim-megara'                        " Colorscheme focused on contrast
" Plug 'whatyouhide/vim-gotham'                       " Code never sleeps in Gotham City
" Plug 'tomasr/molokai'                               " Port of monokai
Plug 'joshdick/onedark.vim'                           " Port of onedark
Plug 'danilo-augusto/vim-afterglow'                   " Port of Afterglow
" Plug 'sjl/badwolf'                                  " Woof Woof
Plug 'morhetz/gruvbox'                                " Bright pastel 'retro groove'
Plug 'cocopon/iceberg.vim'                            " Well-designed, bluish color
Plug 'nanotech/jellybeans.vim'

" To check out next:
" Plug 'terryma/vim-multiple-cursors'
" Plug 'tpope/vim-eunuch'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Vim UI [VUI]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing position aid
set relativenumber       " Show lines count relative to the current one
set number               " Show the line number for the current line
set numberwidth=2        " 3 columns reserved for the line gutter
set signcolumn="yes:1"   " Set signcolumn
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
colorscheme afterglow      " Set colorscheme

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
" Use . as :
nore . :
nore , .
nore \ ,
let mapleader = " "

" Copy/Paste settings
" Disable autoindent to paste from outside
set pastetoggle=<Leader>p
" Copy to the clipboard
vnoremap <C-c> "+y
set clipboard+=unnamedplus

" Navigation keymaps
" Fast jump
nmap <M-j> 5j
nmap <M-k> 5k
xmap <M-j> 5j
xmap <M-k> 5k
" Jump through lines
map <M-J> gj
map <M-K> gk
" Center match when finding
nnoremap n nzz
nnoremap N Nzz

" Buffer keymaps
map <Leader>n :bnext<cr>
map <Leader>p :bprevious<cr>
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
nmap <leader>q :wqall!<cr>

" I'll probably get rid of this soon
" Autosaving after leaving insert covers both cases with 0 keys
" nmap <leader>ww :wall!<cr>
" nmap <leader>qq :qall!<cr>

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

" Use clipboard provider
set clipboard+=unnamedplus

" Add an empty line at the end for UNIX compliance
set eol

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-> Autocmds and lang specific [AUL]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 2-space indents
autocmd WinEnter,FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set sts=2 ts=2 sw=2

" Auto save
autocmd InsertLeave * silent! write
autocmd TextChanged * silent! write

" Text
autocmd FileType text setlocal textwidth=150

" JS
" Full scan sync highlight
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" Markdown
autocmd FileType markdown :call MarkdownConfig()
autocmd FileType markdown set nofoldenable
autocmd FileType markdown set conceallevel=0

func! MarkdownConfig()
  let g:vim_markdown_conceal = 0
  let g:vim_markdown_conceal_code_blocks = 0
endfunc

" Makefile
" Don't change tabs for spaces in Makefiles
autocmd FileType make setlocal noexpandtab

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Plugin keymaps [PKM]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"============================
" Completion
"============================
" -> CoC
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <Leader>cls :<C-u>CocList -I symbols<cr>
nnoremap <Leader>cld :<C-u>CocList diagnostics<cr>
nmap <Leader>cdo <Plug>(coc-codeaction)
nmap <Leader>cr <Plug>(coc-rename)

"============================
" File/Buffer searching
"============================
" -> fzy
nnoremap <Leader>s :FuzzyOpen<CR>
nnoremap <Leader>g :FuzzyGrep<CR>

"============================
" Extended motions/operators
"============================
" -> Commentary keymaps
vmap <Leader>c  <Plug>Commentary
nmap <Leader>cc <Plug>CommentaryLine
nmap <Leader>cu <Plug>CommentaryUndo

" -> NERDTree
" Find current file in NERDTree
nnoremap <Leader>hf :NERDTreeFind<CR>
" Open NERDTree
nnoremap <Leader>N :NERDTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Plugin configuration [PCF]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"============================
" Shell extensions
"============================
" -> Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s:'

" -> ALE
let g:airline#extensions#ale#enabled = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_sign_error = '!'
let g:ale_sign_warning = '●'

let g:ale_linters = {
\   'ruby': ['rubocop', 'solargraph'],
\}

"============================
" Visual aid
"============================
" -> Rainbow Parentheses
let g:rainbow_active = 1

"============================
" Completion
"============================
" -> CoC
inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ?
  \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

let g:coc_global_extensions = [
      \ 'coc-solargraph',
      \ 'coc-tsserver',
      \ 'coc-vetur',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-json',
      \ 'coc-fish',
      \ 'coc-lists',
      \ ]

" -> Emmet
let g:user_emmet_leader_key='<C-z>'
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}

"============================
" Colorschemes
"============================
" -> Afterglow
let g:afterglow_blackout=-1
let g:airline_theme='afterglow'

" Slight tweaks
hi LineNr guibg=NONE
hi Normal guibg=NONE
hi MatchParen guibg=#3a3a3a
hi SignColumn guibg=NONE
hi SignifySignAdd guifg=#b4c973 cterm=NONE gui=NONE
hi SignifySignDelete guifg=#ac4142 cterm=NONE gui=NONE
hi SignifySignChange guifg=#e5b567 cterm=NONE gui=NONE

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> References [REF]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This are some of the places I've taken ideas from, to write my Vim config
" over the years. I'm probably missing a lot of sources because I'm lazy and
" stupid.
"
" -> Amix vimrc      [http://amix.dk/vim/vimrc.html]
" -> VimCasts        [http://vimcasts.org]
" -> Gary Berhardt   [https://github.com/garybernhardt/dotfiles/blob/master/.vimrc]
" -> Andrew Radev    [http://andrewradev.com]
" -> Rafael Bodill   [https://github.com/arafi/vim-config/blob/master/config/general.vim]
" -> Kristijan Husak [https://github.com/kristijanhusak/neovim-config/blob/master/init.vim]
