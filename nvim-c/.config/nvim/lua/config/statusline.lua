local M = {}

local mode_names = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	c = "COMMAND",
	R = "REPLACE",
	t = "TERMINAL",
}

local mode_colors = {
	NORMAL = "StatusModeNormal",
	INSERT = "StatusModeInsert",
	VISUAL = "StatusModeVisual",
	["V-LINE"] = "StatusModeVisual",
	["V-BLOCK"] = "StatusModeVisual",
	COMMAND = "StatusModeCommand",
	REPLACE = "StatusModeReplace",
	TERMINAL = "StatusModeTerminal",
}

local function setup_highlights()
	local function set(name, fg, bg)
		vim.api.nvim_set_hl(0, name, {
			fg = fg,
			bg = bg,
			bold = true,
		})
	end

	set("StatusModeNormal", "#1D2021", "#89B482")
	set("StatusModeInsert", "#1D2021", "#7DAEA3")
	set("StatusModeVisual", "#1D2021", "#D3869B")
	set("StatusModeCommand", "#1D2021", "#D8A657")
	set("StatusModeReplace", "#1D2021", "#EA6962")
	set("StatusModeTerminal", "#1D2021", "#A9B665")

	vim.api.nvim_set_hl(0, "StatusFile", {
		fg = "#D4BE98",
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StatusModified", {
		fg = "#D8A657",
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StatusLsp", {
		fg = "#7DAEA3",
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StatusType", {
		fg = "#7DAEA3",
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StatusLocation", {
		fg = "#D4BE98",
	})

	vim.api.nvim_set_hl(0, "StatusPercent", {
		fg = "#89B482",
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StatusDim", {
		fg = "#928374",
	})
end

setup_highlights()

local function mode()
	local name = mode_names[vim.fn.mode()] or vim.fn.mode()
	local hl = mode_colors[name] or "StatusModeNormal"

	return "%#" .. hl .. "# " .. name .. " %*"
end

local function file()
	local name = vim.fn.expand("%:t")

	if name == "" then
		name = "[No Name]"
	end

	local result = "%#StatusFile# " .. name

	if vim.bo.modified then
		result = result .. " %#StatusModified#●%*"
	end

	if vim.bo.readonly then
		result = result .. " %#StatusDim#[RO]%*"
	end

	return result .. " "
end

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

	return "%#StatusLsp#󰒋 " .. table.concat(names, ", ") .. "%* "
end

local function diagnostics()
	local status = vim.diagnostic.status()

	if status == "" then
		return ""
	end

	return status .. " "
end

local function filetype()
	if vim.bo.filetype == "" then
		return ""
	end

	return "%#StatusType#"
		.. vim.bo.filetype
		.. "%* "
end

local function encoding()
	local parts = {}

	local enc = vim.bo.fileencoding

	if enc ~= "" and enc ~= "utf-8" then
		parts[#parts + 1] = enc
	end

	if vim.bo.fileformat ~= "unix" then
		parts[#parts + 1] = vim.bo.fileformat
	end

	if #parts == 0 then
		return ""
	end

	return "%#StatusDim#"
		.. table.concat(parts, " ")
		.. "%* "
end

function M.build()
	return table.concat({
		mode(),
		file(),
		lsp(),
		diagnostics(),

		"%=",

		filetype(),
		encoding(),

		"%#StatusLocation#Ln %l, Col %c%* ",
		"%#StatusPercent#%p%%%* ",
	})
end

vim.opt.laststatus = 3
vim.opt.showmode = false

vim.o.statusline = "%!v:lua.require('config.statusline').build()"

return M
