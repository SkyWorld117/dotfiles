vim.cmd("set number")

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

require("config.lazy")

-- vim.cmd.colorscheme("catppuccin-mocha")
-- vim.cmd.colorscheme "github_dark_default"
vim.cmd.colorscheme("github_dark_high_contrast")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })

vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>")

local function SuggestOneCharacter()
	local suggestion = vim.fn["copilot#Accept"]("")
	local bar = vim.fn["copilot#TextQueuedForInsertion"]()
	return bar:sub(1, 1)
end
local function SuggestOneWord()
	local suggestion = vim.fn["copilot#Accept"]("")
	local bar = vim.fn["copilot#TextQueuedForInsertion"]()

	-- Check what type the first character is
	local first_char = bar:sub(1, 1)

	if first_char == "\t" then
		return "\t"
	elseif first_char == "\n" then
		return "\n"
	elseif first_char == "\r" then
		return "\r"
	elseif first_char == " " then
		-- For spaces, you might want just one space or match consecutive spaces
		return " "
	else
		-- For regular text, get the first word
		local first_word = string.match(bar, "^(%S+)")
		return first_word or ""
	end
end

vim.keymap.set("i", "<C-l>", SuggestOneCharacter, { expr = true, remap = false })
vim.keymap.set("i", "<C-right>", SuggestOneWord, { expr = true, remap = false })

vim.keymap.set("n", "<leader>e", ":Neotree<CR>")

vim.keymap.set("n", "<leader>fn", ":Telescope notify<CR>")

vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
