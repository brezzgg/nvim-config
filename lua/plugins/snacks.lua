return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,

		keys = require("keymap").get_snacks(),

		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },

			explorer = {
				enabled = true,
				replace_netrw = true,
				auto_close = false,
				jump = { close = false }
			},

			picker = {
				enabled = true,
				hidden = true,
				ignored = true,
				sources = {
					explorer = {
						hidden = true,
						ignored = true,
					},
				}
			},

			notifier = {
				enabled = true,
				timeout = 10000,
			},
		},
	}
}
