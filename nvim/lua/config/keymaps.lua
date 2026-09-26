-- Plugin keymaps live next to each plugin in lua/plugins/
local map = vim.keymap.set

-- Set before lazy.nvim so plugin specs pick it up
vim.g.mapleader = ' '

-- Copy/Paste settings
-- Copy to the clipboard
map('v', '<C-c>', '"+y')

-- Navigation keymaps
-- Fast jump
map({ 'n', 'x' }, '<M-j>', '5j')
map({ 'n', 'x' }, '<M-k>', '5k')
-- Jump through lines
map({ 'n', 'v', 'o' }, '<M-J>', 'gj')
map({ 'n', 'v', 'o' }, '<M-K>', 'gk')
-- Center match when finding
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')

-- Print buffer path
map({ 'n', 'v', 'o' }, '<Leader>f', ":echo expand('%r')<CR>")

-- Window keymaps
map({ 'n', 'v', 'o' }, '<C-j>', '<C-W>j')
map({ 'n', 'v', 'o' }, '<C-k>', '<C-W>k')
map({ 'n', 'v', 'o' }, '<C-h>', '<C-W>h')
map({ 'n', 'v', 'o' }, '<C-l>', '<C-W>l')

-- Tab keymaps
map({ 'n', 'v', 'o' }, '<Leader>tn', ':tabnew<CR>')
map({ 'n', 'v', 'o' }, '<Leader>tc', ':tabclose<CR>')

-- Dismiss search highlight
map('n', '<Leader><Space>', ':nohl<CR>')

-- Giga save. Handle with care
map('n', '<Leader>q', ':wqall!<CR>')

-- Syntax groups under the cursor (regex syntax only, :Inspect covers treesitter)
map({ 'n', 'v', 'o' }, '<F10>', function()
  local line, col = vim.fn.line('.'), vim.fn.col('.')
  print(('hi<%s> trans<%s> lo<%s>'):format(
    vim.fn.synIDattr(vim.fn.synID(line, col, 1), 'name'),
    vim.fn.synIDattr(vim.fn.synID(line, col, 0), 'name'),
    vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(line, col, 1)), 'name')
  ))
end)
