return {
	-- mason
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	-- autoinstall
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = "mason-org/mason.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"golangci_lint_ls",
				},
				automatic_installation = true,
			})
		end,
	},

	-- setup
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
	},

	{
		event = "InsertEnter",
		},
}
