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

	-- nvimtree
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			filters = {
				dotfiles = false,
				git_ignored = false,
			},
			git = {
				enable = true,
				ignore = false,
				show_on_dirs = true,
				timeout = 400,
			},
			renderer = {
				highlight_git = true,
				icons = {
					show = {
						git = true,
					},
				},
			},
			view = {
				width = 45,
			},
			on_attach = function(bufnr)
				require("nvim-tree.api").config.mappings.default_on_attach(bufnr)
				require("keymap").set_nvimtree(
					function(lhs, rhs, desc)
						vim.keymap.set(
							"n",
							lhs,
							rhs,
							{ desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
						)
					end,
					require("nvim-tree.api")
				)
			end
		},
		config = function(_, opts)
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			require("nvim-tree").setup(opts)
		end,
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
