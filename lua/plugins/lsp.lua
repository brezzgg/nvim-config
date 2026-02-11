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
					"jsonls",
					"yamlls",
					"lua_ls",
					"gitlab_ci_ls",
					"gh_actions_ls",
					"protols",
				},
				automatic_installation = true,
			})
		end,
	},

	-- setup
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
		config = function(_, opts)
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
			if ok_cmp then
				capabilities = cmp.default_capabilities(capabilities)
			end
		end,
	},

	-- none ls
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local null_ls = require("null-ls")

			local formatting = null_ls.builtins.formatting
			local code_actions = null_ls.builtins.code_actions

			null_ls.setup({
				sources = {
					formatting.gofumpt.with({
						extra_args = { "-extra" },
					}),

					formatting.goimports_reviser.with({
						extra_args = {
							"-project-name", "github.com/yourorg",
							"-rm-unused",
						},
					}),

					code_actions.gomodifytags,
					code_actions.impl,
				},

				debug = false,
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

	-- signature
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,

			handler_opts = {
				border = "rounded"
			},

			floating_window = true,
			floating_window_above_cur_line = true,

			hi_parameter = "LspSignatureActiveParameter",

			hint_enable = false,
			max_height = 12,
			max_width = 80,

			toggle_key = nil,
			select_signature_key = nil,
		},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},

	-- nvimcmp
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				enabled = function()
					return true
				end,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert(require("keymap").set_cmp(cmp)),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' }
				}, {
					{
						name = 'cmdline',
						option = {
							ignore_cmds = { 'Man', '!' }
						}
					}
				}),
				matching = { disallow_symbol_nonprefix_matching = false }
			})
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})
		end,
	},
}
