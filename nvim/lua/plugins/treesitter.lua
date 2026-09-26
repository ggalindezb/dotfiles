-- nvim-treesitter (main branch) only installs parsers/queries; highlighting,
-- folding and indent have to be enabled per buffer.
-- Installing parsers needs tree-sitter-cli >= 0.26.1:
--   cargo install --root ~/.cargo tree-sitter-cli --locked
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- doesn't support lazy-loading
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install {
      'bash', 'css', 'dockerfile', 'embedded_template', 'fish', 'html', 'javascript',
      'jinja', 'json', 'lua', 'markdown', 'markdown_inline', 'nginx', 'python',
      'ruby', 'rust', 'scss', 'slim', 'sql', 'styled', 'svelte', 'toml', 'tsx',
      'typescript', 'vim', 'vimdoc', 'yaml',
    }

    vim.filetype.add({ extension = { j2 = 'jinja' } })

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
      desc = 'Enable treesitter highlight, folds and indent when a parser exists',
      callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end
        vim.wo[0][0].foldmethod = 'expr'
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
