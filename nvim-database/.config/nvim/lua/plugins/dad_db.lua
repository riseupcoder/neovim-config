vim.pack.add {
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
  'https://github.com/kristijanhusak/vim-dadbod-ui'
}

-- Dadbod UI init settings
vim.g.db_ui_use_nerd_fonts = 1

-- Keymaps (optional)
vim.keymap.set('n', '<leader>du', '<cmd>DBUIToggle<cr>', { desc = 'Toggle DBUI' })
-- vim.keymap.set('n', '<leader>da', '<cmd>DBUIAddConnection<cr>', { desc = 'Add DB Connection' })

