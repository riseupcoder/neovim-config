local group = vim.api.nvim_create_augroup("user_lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		local buf = ev.buf

		-- Format on save
		if
			not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting")
		then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = group,
				buffer = buf,
				callback = function()
					vim.lsp.buf.format({
						bufnr = buf,
						id = client.id,
						timeout_ms = 1000,
					})
				end,
			})
		end

		-- Inlay hints
		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = buf })

			vim.api.nvim_create_autocmd("InsertEnter", {
				group = group,
				buffer = buf,
				callback = function()
					vim.lsp.inlay_hint.enable(false, { bufnr = buf })
				end,
			})

			vim.api.nvim_create_autocmd("InsertLeave", {
				group = group,
				buffer = buf,
				callback = function()
					vim.lsp.inlay_hint.enable(true, { bufnr = buf })
				end,
			})
		end

		-- Personal keymaps
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
			buffer = buf,
			desc = "LSP: Code Action",
		})

		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {
			buffer = buf,
			desc = "LSP: Rename",
		})
	end,
})

-- Native Neovim 0.12 LSP
vim.lsp.enable("clangd")

-- Highlight references to the symbol under the cursor
vim.api.nvim_set_hl(0, "LspReferenceText", {
	bg = "#1e1e2e",
})

vim.api.nvim_set_hl(0, "LspReferenceRead", {
	bg = "#1e1e2e",
})

vim.api.nvim_set_hl(0, "LspReferenceWrite", {
	bg = "#1e1e2e",
})

