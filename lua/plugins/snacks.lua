return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,

		keys = require("keymap").get_snacks(),

		opts = {
			explorer = { enabled = false },

			bigfile = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },

			dashboard = {
				enabled = true,
				preset = {
					keys = require("keymap").get_snacks_dashboard(),
				},
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
				win = {
					keys = {
						term_normal = {
							"<esc>",
							function ()
								vim.cmd("stopinsert")
							end,
							mode = "t",
						}
					}
				}
			},

			notifier = {
				enabled = true,
				timeout = 10000,
			},
		},
	}
}
