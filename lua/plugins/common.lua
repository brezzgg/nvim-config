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
	},


	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "VeryLazy",
		lazy = false,
		priority = 100,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	},
}
