local M = {}

-- ============================================================================
-- Mode
-- ============================================================================

local mode_names = {
	n = "Normal",
	no = "Normal",

	i = "Insert",
	ic = "Insert",
	ix = "Insert",

	v = "Visual",
	V = "Visual",
	["\22"] = "Visual",

	c = "Command",

	R = "Replace",
	Rv = "Replace",

	t = "Terminal",
}

local function mode()
	local name = mode_names[vim.fn.mode()] or "Normal"

	return "%#StatusMode"
		.. name
		.. "# "
		.. name:upper()
		.. " %*"
end

-- ============================================================================
-- File
-- ============================================================================

local function file()
	local name = vim.fn.expand("%:t")

	if name == "" then
		name = "[No Name]"
	end

	local result = "%#StatusFile# " .. name .. "%*"

	if vim.bo.modified then
		result = result .. " %#StatusModified#●%*"
	end

	if vim.bo.readonly then
		result = result .. " %#StatusReadonly#[RO]%*"
	end

	return result
end

-- ============================================================================
-- Separator
-- ============================================================================

local function separator()
	return " %#StatusSeparator#│%* "
end

-- ============================================================================
-- Diagnostics
-- ============================================================================

local function diagnostics()
	local counts = vim.diagnostic.count(0)

	local errors = counts[vim.diagnostic.severity.ERROR] or 0
	local warnings = counts[vim.diagnostic.severity.WARN] or 0

	local result = {}

	if errors > 0 then
		result[#result + 1] =
			"%#StatusError#E " .. errors .. "%*"
	end

	if warnings > 0 then
		result[#result + 1] =
			"%#StatusWarn#W " .. warnings .. "%*"
	end

	return table.concat(result, " ")
end

-- ============================================================================
-- LSP
-- ============================================================================

local function lsp()
	local clients = vim.lsp.get_clients({
		bufnr = 0,
	})

	if #clients == 0 then
		return ""
	end

	local names = {}

	for _, client in ipairs(clients) do
		names[#names + 1] = client.name
	end

	table.sort(names)

	return "%#StatusLsp#"
		.. table.concat(names, ", ")
		.. "%*"
end

-- ============================================================================
-- Progress
-- ============================================================================

local function progress()
	local status = vim.ui.progress_status()

	if status == "" then
		return ""
	end

	return "%#StatusProgress#" .. status .. "%*"
end

-- ============================================================================
-- Statusline
-- ============================================================================

function M.build()
	local left = {
		mode(),
		" ",
		file(),
	}

	-- Diagnostics belong on the left because they are attention-oriented.
	local diagnostic_status = diagnostics()

	if diagnostic_status ~= "" then
		left[#left + 1] = separator()
		left[#left + 1] = diagnostic_status
	end

	local progress_status = progress()

	if progress_status ~= "" then
		left[#left + 1] = separator()
		left[#left + 1] = progress_status
	end

	-- Right side:
	--
	-- c │ clangd │ 42:17 │ 72%
	local right = {
		"%#StatusFiletype#"
			.. vim.bo.filetype
			.. "%*",
	}

	local lsp_status = lsp()

	if lsp_status ~= "" then
		right[#right + 1] = separator()
		right[#right + 1] = lsp_status
	end

	right[#right + 1] = separator()
	right[#right + 1] = "%#StatusLocation#%l:%c%*"

	right[#right + 1] = separator()
	right[#right + 1] = "%#StatusPercent#%p%%%* "

	return table.concat(left)
		.. "%="
		.. table.concat(right)
end

-- ============================================================================
-- Options
-- ============================================================================

vim.opt.laststatus = 3
vim.opt.showmode = false

vim.o.statusline =
	"%!v:lua.require('config.statusline').build()"

return M

