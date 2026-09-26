-- Neovim configuration file
-- Maintainer:       Gerardo Galindez
-- Original File:    2012/09/10
-- Created:          2017/04/06
-- Ported to Lua:    2026/09/26
-- File Location:    ~/.config/nvim/init.lua
-- Layout:
--    -> lua/config/options.lua   General, Vim UI, Files, Editing
--    -> lua/config/keymaps.lua   Keymaps (leader is set here, before plugins)
--    -> lua/config/autocmds.lua  Autocmds and lang specific
--    -> lua/config/lazy.lua      Package manager (lazy.nvim)
--    -> lua/plugins/*.lua        One file per plugin group, config and keymaps together

require('config.options')
require('config.keymaps')
require('config.lazy')
require('config.autocmds')

-- Hide noisy "Client ... quit with exit code" notifications
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == 'string' and msg:match('Client .* quit with exit code') then
    return
  end
  orig_notify(msg, level, opts)
end
