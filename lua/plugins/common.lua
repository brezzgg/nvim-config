return {
	-- autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
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

}
