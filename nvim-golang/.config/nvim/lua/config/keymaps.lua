local map = vim.keymap.set

map("n", "<leader>", "<nop>")

map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
map("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

-- Next/previous diagnostic
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- Save and quit current file quicker
map("n", "<leader>w", "<cmd>w<cr>", { silent = false })
map("n", "<leader>q", "<cmd>q<cr>", { silent = false })

-- Paste without replacing paste with what you are highlighted over
map("n", "<leader>p", '"_dP')
map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Yank to system clipboard
map("n", "<leader>y", '"+y')
map("v", "<leader>y", '"+y')
map("n", "<leader>Y", '"+Y')

-- Visual Mode

-- Disable Space bar since it'll be used as the leader key
map("v", "<leader>", "<nop>")
