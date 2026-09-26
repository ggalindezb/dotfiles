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
    opts = {},
    config = function(_, opts)
      local flash = require('flash')
      flash.setup(opts)

      -- Word jump like HopWord: two-char labels on every word start
      -- Recipe from the flash.nvim README
      local function flash_word()
        local function format(o)
          return {
            { o.match.label1, 'FlashMatch' },
            { o.match.label2, 'FlashLabel' },
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
    end,
  },
}
