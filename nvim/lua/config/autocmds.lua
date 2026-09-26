local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup('config', { clear = true })

-- 2-space indents
autocmd('FileType', {
  group = group,
  pattern = { 'ruby', 'haml', 'eruby', 'yaml', 'html', 'javascript', 'sass', 'cucumber' },
  command = 'setlocal sts=2 ts=2 sw=2',
})

-- Auto save, update only writes when the buffer actually changed
autocmd({ 'InsertLeave', 'TextChanged' }, {
  group = group,
  command = 'silent! update',
})

-- Text
autocmd('FileType', {
  group = group,
  pattern = 'text',
  command = 'setlocal textwidth=150',
})

-- Makefile
-- Don't change tabs for spaces in Makefiles
autocmd('FileType', {
  group = group,
  pattern = 'make',
  command = 'setlocal noexpandtab',
})
