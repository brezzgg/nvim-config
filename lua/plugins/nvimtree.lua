return {
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
				width = {
					min = 30,
					max = 50,
				},
				preserve_window_proportions = true,
				adaptive_size = true,
			},
			diagnostics = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = true,
				debounce_delay = 50,
				severity = {
					min = vim.diagnostic.severity.HINT,
					max = vim.diagnostic.severity.ERROR,
				},
			},

			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				api.config.mappings.default_on_attach(bufnr)

				require("keymap").set_nvimtree(
					function(lhs, rhs, desc)
						vim.keymap.set(
							"n",
							lhs,
							rhs,
							{ desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
						)
					end,
					function(lhs)
						vim.keymap.del(
							"n",
							lhs,
							{ buffer = bufnr }
						)
					end,
					api
				)
			end
		},

		config = function(_, opts)
			require("nvim-tree").setup(opts)
			local function auto_update_path()
				local buf = vim.api.nvim_get_current_buf()
				local bufname = vim.api.nvim_buf_get_name(buf)
				if bufname ~= "" and not bufname:match("NvimTree") then
					require("nvim-tree.api").tree.find_file(vim.fn.expand("%:p"))
				end
			end
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = auto_update_path
			})
		end,
	},
}
