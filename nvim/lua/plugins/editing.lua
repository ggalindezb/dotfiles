-- Extended motions/operators and text objects
-- Comments are built into Neovim: gcc toggles a line, gc{motion} / visual gc
-- toggles a range, gcgc uncomments the adjacent commented block
return {
  { 'andymass/vim-matchup' },     -- Even better %
  { 'tpope/vim-repeat' },         -- Repeating supported plugin maps
  { 'godlygeek/tabular' },        -- Text filtering and alignment
  { 'machakann/vim-sandwich' },   -- Search/select/edit sandwiched textobjects
  { 'arthurxavierx/vim-caser' },  -- Easily change word casing

  -- Text objects
  { 'nelstrom/vim-textobj-rubyblock', dependencies = { 'kana/vim-textobj-user' } },  -- Selecting Ruby blocks

  {
    'mattn/emmet-vim',  -- Emmet expanding abbreviations
    init = function()
      -- javascriptreact/typescriptreact are handled as jsx out of the box
      vim.g.user_emmet_leader_key = '<C-q>'
    end,
  },
}
