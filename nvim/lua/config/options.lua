local opt = vim.opt

-------------------------------------------------------------------------------
-- General
-------------------------------------------------------------------------------
-- Neovim already defaults to: encoding=utf-8, hidden, autoread, history=10000,
-- undolevels=1000, filetype plugin/indent on, syntax on
opt.fileformats = { 'unix', 'dos', 'mac' }            -- Windows sucks
opt.exrc = true                                       -- Allow local exrc files
opt.secure = true                                     -- Disable autocmd in local exrc
opt.mouse = ''                                        -- Mouse is for cry babies

-- Remember file changes, even after closing
local undodir = vim.fn.expand('~/.config/nvim/backups')
vim.fn.mkdir(undodir, 'p')
opt.undodir = undodir
opt.undofile = true

-------------------------------------------------------------------------------
-- Vim UI
-------------------------------------------------------------------------------
-- Editing position aid
opt.relativenumber = true  -- Show lines count relative to the current one
opt.number = true          -- Show the line number for the current line
opt.numberwidth = 2        -- 2 columns reserved for the line gutter
opt.cursorline = true      -- Show the line's ruler
opt.guicursor = ''

-- Vim command line
-- Neovim already defaults to: wildmenu, showcmd, cmdheight=1, laststatus=2
opt.wildignore = { '*~', '*.swp' }  -- Ignore temp files

-- Search options
-- Neovim already defaults to: hlsearch, incsearch, magic
opt.ignorecase = true
opt.smartcase = true       -- Ignore casing unless search a cased word

-- Interface improvements
-- Neovim already defaults to: belloff=all (no bells, no flashes)
opt.lazyredraw = true      -- Don't redraw while executing macros

opt.termguicolors = true   -- True color

-------------------------------------------------------------------------------
-- File handling
-------------------------------------------------------------------------------
-- Don't write anything but the file (nobackup is already the default)
opt.writebackup = false
opt.swapfile = false

-------------------------------------------------------------------------------
-- Editing
-------------------------------------------------------------------------------
-- Use 2-space tabs, standard
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- Use spaces for tabs
opt.expandtab = true

-- Indent (autoindent is already the default)
opt.smartindent = true

-- Break long lines, per word, 80 chars per line
opt.wrap = true
opt.linebreak = true

-- Use clipboard provider
opt.clipboard:append('unnamedplus')

-- Treesitter folding is set per buffer, see lua/plugins/treesitter.lua
opt.foldlevel = 99
