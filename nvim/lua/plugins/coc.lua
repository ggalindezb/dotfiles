-- Language servers (coc) and linters (ALE)
-- ALE runs the plain linters (rubocop, eslint...), coc runs the language
-- servers and shows its diagnostics through ALE, so each issue appears once
return {
  {
    'dense-analysis/ale',  -- Asynchronous Lint Engine
    init = function()
      vim.g.ale_disable_lsp = 1
      vim.g.ale_lint_on_enter = 1
      vim.g.ale_lint_on_save = 1
      vim.g.ale_sign_error = '!'
      vim.g.ale_sign_warning = '●'
      vim.g.ale_linters = {
        ruby = { 'rubocop' },
      }
    end,
  },

  {
    'neoclide/coc.nvim',  -- Language server protocol support
    branch = 'release',
    dependencies = { 'honza/vim-snippets' },  -- One bunch of snips
    init = function()
      vim.g.coc_global_extensions = {
        'coc-css',
        'coc-fish',
        'coc-html',
        'coc-json',
        'coc-lists',
        'coc-tsserver',
        'coc-pyright',
      }
    end,
    config = function()
      vim.fn['coc#config']('diagnostic', { displayByAle = true })

      local map = vim.keymap.set

      -- Drop Neovim's built-in LSP maps (grr, gri, gra, grn, grt), they make gr wait
      -- for timeoutlen and only work with the native LSP client
      for _, lhs in ipairs({ 'grr', 'gri', 'gra', 'grn', 'grt' }) do
        pcall(vim.keymap.del, 'n', lhs)
      end
      pcall(vim.keymap.del, 'x', 'gra')

      map('n', 'gd', '<Plug>(coc-definition)', { silent = true })
      map('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
      map('n', 'gr', '<Plug>(coc-references)', { silent = true })

      map('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
      map('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })

      map('n', '<Leader>cls', ':<C-u>CocList -I symbols<CR>')
      map('n', '<Leader>cld', ':<C-u>CocList diagnostics<CR>')
      map('n', '<Leader>cdo', '<Plug>(coc-codeaction)')
      map('n', '<Leader>cr', '<Plug>(coc-rename)')

      -- Confirm completion with Enter
      map('i', '<CR>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
        { silent = true, expr = true, replace_keycodes = false })
    end,
  },
}
