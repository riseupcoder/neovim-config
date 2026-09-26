require("config")
require("plugins")
require("autoclose").setup()
require("pick").setup()

vim.o.updatetime = 250  -- Faster CursorHold event

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

vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#1e1e2e" })

vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>',     { desc = 'Find files' })
vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<cr>',   { desc = 'Switch buffer' })

vim.lsp.enable({ "goserver" })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end
})   
