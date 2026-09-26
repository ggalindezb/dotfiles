-- Statusline, buffer tabs, guides and other visual aid
return {
  { 'nvim-tree/nvim-web-devicons', lazy = true },  -- Icons and colors

  {
    'nvim-lualine/lualine.nvim',  -- A blazing fast statusline
    opts = {
      options = {
        icons_enabled = true,
        theme = 'ayu_mirage',
      },
    },
  },

  { 'folke/which-key.nvim', opts = {} },

  { 'declancm/maximize.nvim', opts = {} },

  {
    'romgrk/barbar.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'lewis6991/gitsigns.nvim' },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      focus_on_close = 'right',
    },
    config = function(_, opts)
      require('barbar').setup(opts)

      local map = vim.keymap.set
      -- Navigate buffers
      map('n', '<Leader>n', ':BufferNext<CR>')
      map('n', '<Leader>p', ':BufferPrevious<CR>')
      map('n', '<Leader>bp', ':BufferPick<CR>')

      -- Close buffers
      map('n', '<Leader><BS>', ':BufferClose<CR>')
      map('n', '<Leader>b<BS>', ':BufferWipeout<CR>')

      -- Jump to buffer by index
      for i = 1, 9 do
        map('n', '<Leader>b' .. i, ':BufferGoto ' .. i .. '<CR>')
      end
    end,
  },

  { 'ntpeters/vim-better-whitespace' },  -- Highlight trailing whitespace

  { 'ap/vim-css-color' },

  -- Rainbow delimiters and indent-blankline scope share the same colors
  {
    'lukas-reineke/indent-blankline.nvim',  -- Indentation guides
    main = 'ibl',
    dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
    config = function()
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }

      local hooks = require('ibl.hooks')
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
      end)

      local rainbow_delimiters = require('rainbow-delimiters')
      require('rainbow-delimiters.setup').setup {
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

      require('ibl').setup { scope = { highlight = highlight } }
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
}
