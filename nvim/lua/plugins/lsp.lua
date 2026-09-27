-- Language servers (built-in LSP client) and completion
--
-- Keymaps are Neovim's defaults (:h lsp-defaults), plus gd:
--   gd  definition           grr references        gri implementation
--   grt type definition      grn rename            gra code action
--   gO  document symbols     K   hover             <C-s> signature help (insert)
--   [d / ]d previous / next diagnostic             <C-w>d diagnostic float
return {
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },  -- Installs the servers
      'neovim/nvim-lspconfig',                -- Default config per server
    },
    opts = {
      -- Installed servers are enabled automatically
      ensure_installed = {
        'vtsls',                  -- TypeScript/JavaScript, React, Next.js
        'eslint',
        'html',
        'cssls',
        'jsonls',
        'emmet_language_server',  -- Emmet abbreviations show up in completion
        'pyright',
        'fish_lsp',
      },
    },
    config = function(_, opts)
      vim.diagnostic.config({
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '!',
            [vim.diagnostic.severity.WARN] = '●',
          },
        },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
        callback = function(args)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = 'LSP: definition' })
          -- nvim-highlight-colors already shows colors, avoid painting them twice
          vim.lsp.document_color.enable(false, args.buf)
        end,
      })

      require('mason-lspconfig').setup(opts)
    end,
  },

  {
    'saghen/blink.cmp',  -- Completion
    version = '1.*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      -- Enter confirms, like coc
      keymap = { preset = 'enter' },
      completion = { documentation = { auto_show = true } },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    },
  },
}
