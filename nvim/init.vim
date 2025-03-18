" Neovim configuration file
" Maintainer:	Gerardo Galindez
" Original File:    2012/09/10
" Created:          2017/04/06
" Last Updated:     2022/12/11
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
Plug 'nvim-lualine/lualine.nvim'                      " A blazing fast statusline
Plug 'dense-analysis/ale'                             " Asynchronous Lint Engine
Plug 'tpope/vim-fugitive'                             " Git wrapper so awesome, it should be illegal
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim'                          " Neovim Lua lib
Plug 'nvim-telescope/telescope.nvim'
Plug 'declancm/maximize.nvim'

" Visual aid
Plug 'ntpeters/vim-better-whitespace'                 " Highlight trailing whitespace
Plug 'HiPhish/rainbow-delimiters.nvim'                " Rainbow parentheses for neovim
Plug 'lukas-reineke/indent-blankline.nvim'            " Indentation guides to Neovim
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'kyazdani42/nvim-web-devicons'                   " Icons and colors

" File/Buffer handling
Plug 'romgrk/barbar.nvim'
Plug 'preservim/nerdtree'                             " A tree explorer
Plug 'Xuyuanp/nerdtree-git-plugin'                    " NERDTree git status

" Extended motions/operators
Plug 'andymass/vim-matchup'                           " Even better %
Plug 'tpope/vim-repeat'                               " Repeating supported plugin maps
Plug 'tpope/vim-commentary'                           " Comment stuff out
Plug 'phaazon/hop.nvim'                               "
Plug 'godlygeek/tabular'                              " Text filtering and alignment
Plug 'machakann/vim-sandwich'                         " Search/select/edit sandwiched textobjects
Plug 'arthurxavierx/vim-caser'                        " Easily change word casing
" Plug 'junegunn/vim-easy-align'                        " A Vim alignment plugin

" Text objects
Plug 'kana/vim-textobj-user'                          " Text object lib
Plug 'nelstrom/vim-textobj-rubyblock'                 " Selecting Ruby blocks
" Plug 'wellle/targets.vim'                           " Additional text objects
" Plug 'kana/vim-textobj-fold'                        " Text objects for foldings

" Completion
Plug 'mattn/emmet-vim'                                " Emmet expanding abbreviations
Plug 'neoclide/coc.nvim', {'branch': 'release'}       " Language server protocol support
Plug 'honza/vim-snippets'                             " One bunch of snips
Plug 'github/copilot.vim'

" External services
" Plug 'wakatime/vim-wakatime'                          " Wakatime tracking

" Filetypes
Plug 'othree/html5.vim'                               " HTML5
Plug 'hail2u/vim-css3-syntax'                         " CSS 3
Plug 'styled-components/vim-styled-components', {'branch': 'main'}
Plug 'ap/vim-css-color'
Plug 'evanleck/vim-svelte'
Plug 'lepture/vim-jinja'

" -> Ruby/Rails
Plug 'vim-ruby/vim-ruby'                              " Ruby
Plug 'tpope/vim-rails'                                " Rails
Plug 'tpope/vim-haml', {'for': 'haml'}                " HAML/SASS
Plug 'slim-template/vim-slim', {'for': 'slim'}        " Slim
Plug 'kchmck/vim-coffee-script'                       " Coffeescript

" -> JS
Plug 'othree/yajs.vim'                                " JS
Plug 'isRuslan/vim-es6'                               " ES6
Plug 'othree/es.next.syntax.vim'
Plug 'leafgarland/typescript-vim'                     " Typescript
Plug 'MaxMEllon/vim-jsx-pretty'                       " JSX
Plug 'peitalin/vim-jsx-typescript'                    " TSX

" -> Documents
Plug 'plasticboy/vim-markdown', {'for': 'mkd'}        " Markdown

" -> Shell
Plug 'dag/vim-fish', {'for': 'fish' }                 " Fish script

" -> Stuff
Plug 'chr4/nginx.vim'                                 " Improved nginx

" Colorschemes
" Unused colorschemes commented for historic reasons
" ... And fun
" Plug 'ggalindezb/vim-megara'                        " Colorscheme focused on contrast
" Plug 'whatyouhide/vim-gotham'                       " Code never sleeps in Gotham City
" Plug 'tomasr/molokai'                               " Port of monokai
" Plug 'danilo-augusto/vim-afterglow'                 " Port of Afterglow
Plug 'olimorris/onedarkpro.nvim'
Plug 'marko-cerovac/material.nvim'
Plug 'bluz71/vim-moonfly-colors'
Plug 'rafamadriz/neon'

" To check out next:
" Plug 'terryma/vim-multiple-cursors'
" Plug 'tpope/vim-eunuch'

Plug 'folke/which-key.nvim'

call plug#end()

" Explicitly enable plugins
" Redo this section when porting to Lua
lua << END
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'ayu_mirage',
  }
}

require("which-key").setup()
END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Vim UI [VUI]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing position aid
set relativenumber       " Show lines count relative to the current one
set number               " Show the line number for the current line
set numberwidth=2        " 3 columns reserved for the line gutter
" set signcolumn="yes:1"   " Set signcolumn
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

" ---------------------------
" Buffer keymaps / Bar Bar
" ---------------------------
" Navigate buffers
nnoremap <Leader>n :BufferNext<CR>
nnoremap <Leader>p :BufferPrevious<CR>
nnoremap <Leader>bp :BufferPick<CR>

" Close buffers
nnoremap <Leader><BS> :BufferClose<CR>
nnoremap <Leader>b<BS> :BufferWipeout<CR>

" Print buffer path
map <Leader>f :echo expand('%r')<cr>

" Jump to buffer by index
nnoremap <Leader>b1 :BufferGoto 1<CR>
nnoremap <Leader>b2 :BufferGoto 2<CR>
nnoremap <Leader>b3 :BufferGoto 3<CR>
nnoremap <Leader>b4 :BufferGoto 4<CR>
nnoremap <Leader>b5 :BufferGoto 5<CR>
nnoremap <Leader>b6 :BufferGoto 6<CR>
nnoremap <Leader>b7 :BufferGoto 7<CR>
nnoremap <Leader>b8 :BufferGoto 8<CR>
nnoremap <Leader>b9 :BufferGoto 9<CR>

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
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99

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
" -> Fuzzy file / grep
nnoremap <Leader>s :Telescope find_files<CR>
nnoremap <Leader>g :Telescope live_grep<CR>

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

" -> Hop
nnoremap <Leader>hw :HopWordMW<CR>
nnoremap <Leader>hc :HopChar1MW<CR>
nnoremap <Leader>ha :HopAnywhereMW<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Plugin configuration [PCF]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:svelte_preprocessor_tags = [
  \ { 'name': 'postcss', 'tag': 'style', 'as': 'scss' }
  \ ]
let g:svelte_preprocessors = ['postcss']
let g:vim_svelte_plugin_load_full_syntax = 1

"============================
" Shell extensions
"============================
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
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

let g:coc_global_extensions = [
      \ 'coc-angular',
      \ 'coc-css',
      \ 'coc-fish',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-pyright',
      \ 'coc-solargraph',
      \ 'coc-tsserver',
      \ 'coc-vetur',
      \ 'coc-svelte',
      \ ]

" -> Emmet
let g:user_emmet_leader_key='<C-q>'
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}

"============================
" Colorschemes
"============================
let g:material_disable_background = 1
let g:moonflyTransparent = v:true
colorscheme moonfly

" Slight tweaks
hi LineNr cterm=NONE guibg=NONE
hi CursorColumn cterm=NONE guibg=NONE
hi ColorColumn cterm=NONE guibg=NONE
hi SignColumn cterm=NONE guibg=NONE

hi BufferVisible guibg=#2C2C2C
hi BufferVisibleIndex guibg=#2C2C2C
hi BufferVisibleMod guibg=#2C2C2C
hi BufferVisibleSign guibg=#2C2C2C
hi BufferVisibleTarget guibg=#2C2C2C

hi BufferTabpageFill guifg=#FFFFFF cterm=NONE guibg=#2C2C2C

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

lua <<EOF
require'hop'.setup()

require('gitsigns').setup()

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  },
  rainbow = {
    enable = true
  }
}

require('maximize').setup()

vim.g.barbar_auto_setup = false -- disable auto-setup

require'barbar'.setup {
  focus_on_close = 'right'
}

vim.api.nvim_create_augroup("cmdwin_treesitter", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = "*",
  command = "TSBufDisable incremental_selection",
  group = "cmdwin_treesitter",
  desc = "Disable treesitter's incremental selection in Command-line window",
})

-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

---@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    priority = {
        [''] = 110,
        lua = 210,
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
}

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup { scope = { highlight = highlight } }

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
EOF
