return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,

		keys = require("keymap").get_snacks(),

		opts = {
			explorer = { enabled = false },

			bigfile = { enabled = true },
			dashboard = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },

				enabled = true,
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

			terminal = {
				interactive = false,
				auto_close = true,
			},

			notifier = {
				enabled = true,
				timeout = 10000,
			},
		},
	}
}
