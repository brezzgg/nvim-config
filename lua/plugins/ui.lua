return {
	-- colorschemes
	{
		'lmantw/themify.nvim',
		lazy = false,
		priority = 999,
		config = {
			"folke/tokyonight.nvim",
			"EdenEast/nightfox.nvim",
			"sho-87/kanagawa-paper.nvim",
			"comfysage/evergarden",
			"datsfilipe/min-theme.nvim",
			"datsfilipe/vesper.nvim",
			"everviolet/nvim",
			"ramojus/mellifluous.nvim"
		}
	},

	-- botline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {},
				lualine_x = { "filename" },
				lualine_y = { "lsp_status", "filetype" },
				lualine_z = { "location" }
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {}
			},
		},
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
