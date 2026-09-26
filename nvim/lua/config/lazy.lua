-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' }, { out } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- init.lua is symlinked from the dotfiles repo, keep the lockfile next to it
-- so it's versioned
local config_dir = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.stdpath('config') .. '/init.lua'), ':h')

require('lazy').setup({
  spec = { { import = 'plugins' } },
  lockfile = config_dir .. '/lazy-lock.json',
  install = { colorscheme = { 'moonfly' } },
  change_detection = { notify = false },
})
