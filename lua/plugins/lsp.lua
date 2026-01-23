return {
	-- mason
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	-- autoinstall
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"golangci_lint_ls",
					"jsonls",
					"yamlls",
					"lua_ls",
					"gitlab_ci_ls",
					"gh_actions_ls",
				},
				automatic_installation = true,
			})
		end,
	},

	-- setup
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			servers = {
				gopls = {
					settings = {
						gopls = {
							codelenses = {
								generate = true,
								test = true,
								tidy = true,
								vendor = true,
								upgrade_dependency = true,
							},
							analyses = {
								packagepkg = false,
								ST1000 = false,
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
			if ok_cmp then
				capabilities = cmp.default_capabilities(capabilities)
			end

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(opts.servers),
				handlers = {
					function(server_name)
						local server_opts = opts.servers[server_name] or {}
						server_opts.capabilities = capabilities
						lspconfig[server_name].setup(server_opts)
					end,
				},
			})
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

	-- nvimcmp
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				enabled = function()
					return true
				end,
				mapping = cmp.mapping.preset.insert(require("keymap").set_cmp(cmp)),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	}
}
