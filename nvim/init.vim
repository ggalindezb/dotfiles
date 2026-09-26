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
" Neovim already defaults to: encoding=utf-8, hidden, autoread, history=10000,
" undolevels=1000, filetype plugin/indent on, syntax on
set fileformats=unix,dos,mac                          " Windows sucks
set exrc                                              " Allow local exrc files
set secure                                            " Disable autocmd in local exrc
set mouse=                                            " Mouse is for cry babies

call mkdir(expand('~/.config/nvim/backups'), 'p')     " Remember file changes, even after closing
set undodir=~/.config/nvim/backups
set undofile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Packages [PKG]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install Plug if it's not available
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
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
Plug 'nvim-tree/nvim-web-devicons'                    " Icons and colors

" File/Buffer handling
Plug 'romgrk/barbar.nvim'
Plug 'MunifTanjim/nui.nvim'                           " UI components, needed by neo-tree
Plug 'nvim-neo-tree/neo-tree.nvim', {'branch': 'v3.x'} " File tree with git status

" Extended motions/operators
Plug 'andymass/vim-matchup'                           " Even better %
Plug 'tpope/vim-repeat'                               " Repeating supported plugin maps
Plug 'folke/flash.nvim'                               " Jump anywhere with labels
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
" Plug 'github/copilot.vim'

" External services
" Plug 'wakatime/vim-wakatime'                          " Wakatime tracking

" Filetypes
" Most syntax comes from treesitter parsers (see the Lua block at the bottom).
" Only filetypes without a parser or without native Neovim support stay here.
Plug 'ap/vim-css-color'

" -> Ruby/Rails
Plug 'vim-ruby/vim-ruby'                              " Ruby
Plug 'tpope/vim-rails'                                " Rails

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
set numberwidth=2        " 2 columns reserved for the line gutter
" set signcolumn="yes:1"   " Set signcolumn
set cursorline           " Show the line's ruler
set guicursor=

" Vim command line
" Neovim already defaults to: wildmenu, showcmd, cmdheight=1, laststatus=2
set wildignore=*~,*.swp  " Ignore temp files

" Search options
" Neovim already defaults to: hlsearch, incsearch, magic
set ignorecase
set smartcase            " Ignore casing unless search a cased word

" Interface improvements
" Neovim already defaults to: belloff=all (no bells, no flashes)
set lazyredraw           " Don't redraw while executing macros

set termguicolors        " True color

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> File handling [FIL]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't write anything but the file (nobackup is already the default)
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Keymaps [KEY]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: This needs a bit of cleaning up too

""""""""""""""
" Vim keymaps
""""""""""""""
let mapleader = " "

" Copy/Paste settings
" Copy to the clipboard
vnoremap <C-c> "+y

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

" Indent (autoindent is already the default)
set smartindent

" Break long lines, per word, 80 chars per line
set wrap
set linebreak

" Use clipboard provider
set clipboard+=unnamedplus

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-> Autocmds and lang specific [AUL]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treesitter folding is set per buffer in the Lua block below
set foldlevel=99

" 2-space indents
autocmd WinEnter,FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set sts=2 ts=2 sw=2

" Auto save, update only writes when the buffer actually changed
autocmd InsertLeave * silent! update
autocmd TextChanged * silent! update

" Text
autocmd FileType text setlocal textwidth=150

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
" Drop Neovim's built-in LSP maps (grr, gri, gra, grn, grt), they make gr wait
" for timeoutlen and only work with the native LSP client
for s:lhs in ['grr', 'gri', 'gra', 'grn', 'grt']
  silent! execute 'unmap ' . s:lhs
endfor
silent! xunmap gra

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
" -> Comments
" Built into Neovim: gcc toggles a line, gc{motion} / visual gc toggles a range,
" gcgc uncomments the adjacent commented block

" -> Neo-tree
" Find current file in the tree
nnoremap <Leader>hf :Neotree reveal<CR>
" Open the tree
nnoremap <Leader>N :Neotree toggle<CR>

" -> Flash
" <Leader>hw / <Leader>hc / <Leader>ha are defined in the Lua block below

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Plugin configuration [PCF]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"============================
" Shell extensions
"============================
" -> ALE
" ALE runs the plain linters (rubocop, eslint...), coc runs the language
" servers and shows its diagnostics through ALE, so each issue appears once
let g:ale_disable_lsp = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_sign_error = '!'
let g:ale_sign_warning = '●'

let g:ale_linters = {
\   'ruby': ['rubocop'],
\}

"============================
" Completion
"============================
" -> CoC
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

call coc#config('diagnostic', { 'displayByAle': v:true })

let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-fish',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-tsserver',
      \ 'coc-pyright',
      \ ]

" -> Emmet
" javascriptreact/typescriptreact are handled as jsx out of the box
let g:user_emmet_leader_key='<C-q>'

"============================
" Colorschemes
"============================
" Transparent background everywhere, the terminal shows the wallpaper
let g:moonflyTransparent = v:true
let g:neon_transparent = v:true
lua << END
require('material').setup { disable = { background = true } }
require('onedarkpro').setup { options = { transparency = true } }
END

" Catch-all for any colorscheme, also re-applied when switching themes
function! s:TransparentBackground() abort
  for group in ['Normal', 'NormalNC', 'EndOfBuffer', 'LineNr', 'CursorColumn', 'ColorColumn', 'SignColumn']
    execute 'hi ' . group . ' cterm=NONE ctermbg=NONE guibg=NONE'
  endfor
endfunction
autocmd ColorScheme * call s:TransparentBackground()

colorscheme moonfly

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
-- Flash, mapped to the old hop keys (s is taken by vim-sandwich)
local flash = require('flash')
flash.setup()

-- Word jump like HopWord: two-char labels on every word start
-- Recipe from the flash.nvim README
local function flash_word()
  local function format(opts)
    return {
      { opts.match.label1, 'FlashMatch' },
      { opts.match.label2, 'FlashLabel' },
    }
  end

  flash.jump({
    search = { mode = 'search' },
    label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
    pattern = [[\<]],
    action = function(match, state)
      state:hide()
      flash.jump({
        search = { max_length = 0 },
        highlight = { matches = false },
        label = { format = format },
        matcher = function(win)
          return vim.tbl_filter(function(m)
            return m.label == match.label and m.win == win
          end, state.results)
        end,
        labeler = function(matches)
          for _, m in ipairs(matches) do
            m.label = m.label2
          end
        end,
      })
    end,
    labeler = function(matches, state)
      local labels = state:labels()
      for m, match in ipairs(matches) do
        match.label1 = labels[math.floor((m - 1) / #labels) + 1]
        match.label2 = labels[(m - 1) % #labels + 1]
        match.label = match.label1
      end
    end,
  })
end

vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>hw', flash_word, { desc = 'Flash: jump to word' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>hc', function()
  flash.jump({ search = { max_length = 1 } })
end, { desc = 'Flash: jump to char' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>ha', flash.jump, { desc = 'Flash: jump anywhere' })

require('neo-tree').setup({})

require('gitsigns').setup()

-- nvim-treesitter (main branch) only installs parsers/queries; highlighting,
-- folding and indent have to be enabled per buffer.
-- Installing parsers needs tree-sitter-cli >= 0.26.1 (cargo install tree-sitter-cli)
require('nvim-treesitter').install {
  'bash', 'css', 'dockerfile', 'embedded_template', 'fish', 'html', 'javascript',
  'jinja', 'json', 'lua', 'markdown', 'markdown_inline', 'nginx', 'python',
  'ruby', 'rust', 'scss', 'slim', 'sql', 'styled', 'svelte', 'toml', 'tsx',
  'typescript', 'vim', 'vimdoc', 'yaml',
}

vim.filetype.add({ extension = { j2 = 'jinja' } })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
  desc = 'Enable treesitter highlight, folds and indent when a parser exists',
  callback = function(args)
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require('maximize').setup()

vim.g.barbar_auto_setup = false -- disable auto-setup

require'barbar'.setup {
  focus_on_close = 'right'
}

-- Rainbow delimiters and indent-blankline scope share the same colors
local rainbow_delimiters = require 'rainbow-delimiters'
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
    highlight = highlight,
}
require("ibl").setup { scope = { highlight = highlight } }

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and msg:match("Client .* quit with exit code") then
    return
  end
  orig_notify(msg, level, opts)
end
EOF
