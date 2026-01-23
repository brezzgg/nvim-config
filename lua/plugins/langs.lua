return {
	-- golang
	{
		"maxandron/goplements.nvim",
		ft = "go",
		opts = {},
	},

	{
		"crispgm/nvim-go",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		ft = { "go", "gomod" },
		build = { ":GoInstallBinaries" },
		config = function()
			require('go').setup({
				auto_format = false,
				auto_lint = false,
				formatter = 'goimports',
			})
		end,
	},
}
