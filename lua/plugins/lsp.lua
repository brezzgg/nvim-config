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

	-- nvimcmp
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				mapping = cmp.mapping.preset.insert(require("keymap").set_cmp(cmp)),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	}
}
