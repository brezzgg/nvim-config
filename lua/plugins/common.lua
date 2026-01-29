return {
	-- autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end
	},

	-- autosave
	{
		"pocco81/auto-save.nvim",
		opts = { enabled = true },
		config = function(_, opts)
			local as = require("auto-save")
			as.setup(opts)
			vim.g.auto_save_enabled = true
			require("keymap").set_autosave(as)
		end
	},

	-- session
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			branch = true,
		},
	}
}
