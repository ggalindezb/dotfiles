-- Finding files, the file tree and jumping around
return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Telescope',
    keys = {
      -- Fuzzy file / grep
      { '<Leader>s', ':Telescope find_files<CR>' },
      { '<Leader>g', ':Telescope live_grep<CR>' },
    },
  },

  {
    'nvim-neo-tree/neo-tree.nvim',  -- File tree with git status
    branch = 'v3.x',
    lazy = false, -- neo-tree lazy-loads itself, and needs to be there for `nvim .`
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
    keys = {
      -- Find current file in the tree
      { '<Leader>hf', ':Neotree reveal<CR>' },
      -- Open the tree
      { '<Leader>N', ':Neotree toggle<CR>' },
    },
  },

  {
    'folke/flash.nvim',  -- Jump anywhere with labels, mapped to the old hop keys (s is taken by vim-sandwich)
    opts = {
      label = { rainbow = { enabled = true } },
      modes = { char = { highlight = { backdrop = false } } },
    },
    config = function(_, opts)
      local flash = require('flash')
      flash.setup(opts)

      vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>hc', function()
        flash.jump({ search = { max_length = 1 } })
      end, { desc = 'Flash: jump to char' })
      vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>ha', flash.jump, { desc = 'Flash: jump anywhere' })
    end,
  },
}
