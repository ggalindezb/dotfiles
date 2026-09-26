-- Transparent background everywhere, the terminal shows the wallpaper.
-- Only moonfly loads at startup, the rest load on :colorscheme
return {
  {
    'bluz71/vim-moonfly-colors',
    name = 'moonfly',
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.moonflyTransparent = true
    end,
    config = function()
      -- Catch-all for any colorscheme, also re-applied when switching themes
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('transparent_background', { clear = true }),
        callback = function()
          for _, group in ipairs({ 'Normal', 'NormalNC', 'EndOfBuffer', 'LineNr', 'CursorColumn', 'ColorColumn', 'SignColumn' }) do
            vim.cmd('hi ' .. group .. ' cterm=NONE ctermbg=NONE guibg=NONE')
          end
        end,
      })

      vim.cmd.colorscheme('moonfly')

      for _, group in ipairs({ 'BufferVisible', 'BufferVisibleIndex', 'BufferVisibleMod', 'BufferVisibleSign', 'BufferVisibleTarget' }) do
        vim.api.nvim_set_hl(0, group, { bg = '#2C2C2C' })
      end
      vim.cmd('hi BufferTabpageFill guifg=#FFFFFF cterm=NONE guibg=#2C2C2C')
    end,
  },
  {
    'olimorris/onedarkpro.nvim',
    lazy = true,
    opts = { options = { transparency = true } },
  },
  {
    'marko-cerovac/material.nvim',
    lazy = true,
    opts = { disable = { background = true } },
  },
  {
    'rafamadriz/neon',
    lazy = true,
    init = function()
      vim.g.neon_transparent = true
    end,
  },
}
