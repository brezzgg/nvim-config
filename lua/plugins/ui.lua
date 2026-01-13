return {
	-- colorscheme
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},

	-- botline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- whichkey
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
			},
		},
	},

	-- icons
	{ 'nvim-mini/mini.nvim' },
	{ "nvim-tree/nvim-web-devicons", lazy = false },
}
