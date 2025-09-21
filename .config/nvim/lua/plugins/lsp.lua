return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"ast_grep",
					"fortls",
					"pylsp",
					"lua_ls",
					"yamlls",
					-- "julials",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.lsp.config("bashls", {})
			vim.lsp.config("ast_grep", {})
			vim.lsp.config("fortls", {})
			vim.lsp.config("pylsp", {})
			vim.lsp.config("lua_ls", {})
			vim.lsp.config("yamlls", {})
			vim.lsp.config("julials", {})
		end,
	},
}
