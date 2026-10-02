local group = vim.api.nvim_create_augroup("user_lsp", {
	clear = true,
})

-- ============================================================================
-- LSP attach
-- ============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,

	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		local buf = ev.buf

		-- ======================================================================
		-- Format on save
		-- ======================================================================

		if
			client:supports_method("textDocument/formatting")
			and not client:supports_method("textDocument/willSaveWaitUntil")
		then
			local format_group = vim.api.nvim_create_augroup(
				"user_lsp_format_" .. buf .. "_" .. client.id,
				{ clear = true }
			)

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = format_group,
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

		-- ======================================================================
		-- Inlay hints
		-- ======================================================================

		if client:supports_method("textDocument/inlayHint") then
			vim.keymap.set("n", "<leader>ci", function()
				local enabled = vim.lsp.inlay_hint.is_enabled({
					bufnr = buf,
				})

				vim.lsp.inlay_hint.enable(not enabled, {
					bufnr = buf,
				})
			end, {
				buffer = buf,
				desc = "LSP: Toggle Inlay Hints",
			})
		end

		-- ======================================================================
		-- Code actions
		-- ======================================================================

		if client:supports_method("textDocument/codeAction") then
			vim.keymap.set({ "n", "v" }, "<leader>ca", function()
				local row = vim.api.nvim_win_get_cursor(0)[1] - 1

				local line = vim.api.nvim_buf_get_lines(
					buf,
					row,
					row + 1,
					false
				)[1] or ""

				vim.lsp.buf.code_action({
					range = {
						start = { row, 0 },
						["end"] = { row, #line },
					},

					context = {
						triggerKind =
							vim.lsp.protocol.CodeActionTriggerKind.Invoked,
					},
				})
			end, {
				buffer = buf,
				desc = "LSP: Code Action",
			})
		end

		-- ======================================================================
		-- Rename
		-- ======================================================================

		if client:supports_method("textDocument/rename") then
			vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {
				buffer = buf,
				desc = "LSP: Rename",
			})
		end
	end,
})

-- Native Neovim LSP configuration.
vim.lsp.enable("clangd")


