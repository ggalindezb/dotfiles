" vimrc custom configuration file
" Maintainer:	Gerardo Galindez 
" Created:	    28/Aug/2014
" Version:      0.3
" Sections:
"    -> General [GEN]
"    -> Vundle [VUN]
"    -> Keymaps [KEY]
"    -> Vim UI [VUI]
"    -> Files [FIL]
"    -> Editing [EDT]
"    -> Autocmds and lang specific [AUT]
"    -> Helpers [HLP]
"    -> Plugin configuration [PGC]
" References: 
"    -> Amix vimrc [http://amix.dk/vim/vimrc.html]
"    -> VimCasts [http://vimcasts.org]
"    -> Gary Berhardt [https://github.com/garybernhardt/dotfiles/blob/master/.vimrc]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> General [GEN]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set to auto read when a file is changed from the outside
set autoread

" Use Vim settings
set nocompatible
set laststatus=2
set encoding=utf-8
set hidden

" Remember stuff
set history=256
set undolevels=512

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Vundle [VUN]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
Plugin 'gmarik/vundle'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tmhedberg/matchit'
Plugin 'bling/vim-airline'
Bundle 'mattn/emmet-vim'

" Filetype
Plugin 'tpope/vim-rails'
Plugin 'kchmck/vim-coffee-script'
Plugin 'dagwieers/asciidoc-vim'

" Colorschemes
Plugin 'Heldraug/vim-megara'
call vundle#end()

" Unused plugins
" Plugin 'Lokaltog/vim-powerline'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Keymaps [KEY]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""
" Vim keymaps
""""""""""""""
" Use spacebar to repeat last command
nore <Space> .
" Use . as :
nore . :
let mapleader = ","

" Paste from the clipboard without indenting
set pastetoggle=<Leader>p

" Navigation keymaps
" Power navigation, by Andrew Radev
nmap J 5j
nmap K 5k
xmap J 5j
xmap K 5k

" Buffer keymaps
map <Leader>bn :bnext<cr>
map <Leader>bN :bprevious<cr>
map <Leader>bd :bdelete<cr>

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

"""""""""""""""""
" Plugin keymaps
"""""""""""""""""
""""""""""
" NERDTree
""""""""""
nmap <leader>nt :NERDTreeToggle<cr>

""""""""""""""""""""
" Commentary keymaps
""""""""""""""""""""
xmap <Leader>c  <Plug>Commentary
nmap <Leader>c  <Plug>Commentary
nmap <Leader>cc <Plug>CommentaryLine
nmap <Leader>cu <Plug>CommentaryUndo

"""""""""
" Switch
"""""""""
nnoremap - :Switch<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Vim UI [VUI]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing position aid
set number
set numberwidth=4
set ruler
set cul
set showmatch	
set backspace=indent,eol,start " Allow backspacing over everything

" Vim command line and Wildmenu
set wildmenu
set wildignore=*~,*.swp
set showcmd	
set cmdheight=1

" Search options
set ignorecase
set smartcase
set hlsearch
set incsearch		" Real time match
set magic           " Regex magic

" Don't redraw while executing macros
" Note: Dooesn't looks as cool
set lazyredraw

" Bells are ugly
set novisualbell
set noerrorbells
set t_vb=

syntax on
colorscheme megara
set t_Co=256        " 256 color term 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Files [FIL]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't write anything but the file
set nobackup
set nowb
set noswapfile

" Blowfish encryption
setlocal cryptmethod=blowfish

" Filetypes
filetype plugin on
filetype indent on
set omnifunc=syntaxcomplete#Complete
augroup vimrcEx
au!

" Return to last edit position
" autocmd BufReadPost *
     " \ if line("'\"") > 1 && line("'\"") <= line("$") |
     " \   exe "normal! g`\"" |
     " \ endif

" Remember info about open buffers on close
" set viminfo^=%

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Editing [EDT]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use 4-space tabs
set softtabstop=4
set tabstop=4
set shiftwidth=4

" Use spaces for tabs
set expandtab
set smarttab

" Indent
set autoindent
set smartindent
set wrap

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-> Autocmds and lang specific [AUT]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd!

" Set [...] to 2-space indent
autocmd WinEnter,FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set sts=2 ts=2 sw=2 

" Text -> Git, Asciidoc
autocmd FileType text setlocal textwidth=80

" Set SASS to SASS. Duh
autocmd! BufRead,BufNewFile *.sass setfiletype sass 

" Set F# lex to F#
autocmd! BufRead,BufNewFile *.fsl setfiletype fsharp 
autocmd! BufRead,BufNewFile *.fsy setfiletype fsharp 

" Don't change tabs for spaces in Makefiles
autocmd FileType make setlocal noexpandtab

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
    exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-> Helpers [HLP]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show syntax highlighting groups for word under cursor
" By VimCasts
nmap <leader>s :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Plugin configuration [PGC]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""
" CtrlP
""""""""""
" When opening multiple files, open them in the background
let g:ctrlp_open_multiple_files = 'i'

""""""""""""
" Airline
""""""""""""
let g:airline_powerline_fonts = 1
let g:airline_theme = 'powerlineish'
