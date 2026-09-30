require("config")
require("plugins")
require("autoclose").setup()
require("pick").setup()

vim.opt.modeline = false

vim.opt.shadafile = "NONE"

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
  end,
})

vim.keymap.set("n", "<leader>w", function()
  vim.cmd.write()
  vim.cmd("echo ''")
end)

vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>',     { desc = 'Find files' })
vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<cr>',   { desc = 'Switch buffer' })
