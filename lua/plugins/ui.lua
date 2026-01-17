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

	-- lualine
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				globalstatus = 3,
				disabled_filetypes = {
					winbar = {
						"snacks_dashboard",
						"NvimTree",
					},
				},
			},
			winbar = {
				lualine_c = { "filename" },
			},
			inactive_winbar = {
				lualine_c = { "filename" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {},
				lualine_x = {},
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
	},

	-- icons
	{ 'nvim-mini/mini.nvim' },
	{ "nvim-tree/nvim-web-devicons", lazy = false },
}
