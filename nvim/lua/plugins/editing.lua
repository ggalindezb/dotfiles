-- Extended motions/operators
-- Comments are built into Neovim: gcc toggles a line, gc{motion} / visual gc
-- toggles a range, gcgc uncomments the adjacent commented block
return {
  { 'andymass/vim-matchup' },     -- Even better %
  { 'tpope/vim-repeat' },         -- Repeating supported plugin maps
  { 'godlygeek/tabular' },        -- Text filtering and alignment
  { 'machakann/vim-sandwich' },   -- Search/select/edit sandwiched textobjects
  { 'arthurxavierx/vim-caser' },  -- Easily change word casing

  -- Treesitter-aware commentstring for gc, e.g. {/* */} for JSX
  { 'folke/ts-comments.nvim', event = 'VeryLazy', opts = {} },
}
