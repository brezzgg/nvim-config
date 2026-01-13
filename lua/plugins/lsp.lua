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
		dependencies = "mason-org/mason.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"golangci_lint_ls",
				},
				automatic_installation = true,
			})
		end,
	},

	-- setup
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		-- config = function()
		-- 	local lspconfig = require("lspconfig")
		--
		-- 	require("mason-lspconfig").setup_handlers({
		-- 		function(server_name)
		-- 			lspconfig[server_name].setup({})
		-- 		end,
		--
		-- 		["lua_ls"] = function()
		-- 			lspconfig.lua_ls.setup({
		-- 				settings = {
		-- 					Lua = {
		-- 						diagnostics = {
		-- 							globals = { "vim" },
		-- 						},
		-- 					},
		-- 				},
		-- 			})
		-- 		end,
		-- 	})
		-- end,
	},

	-- blink
	{
		"saghen/blink.cmp",
		version = "^1",
		event = "InsertEnter",
		opts = {
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true },
			keymap = require("keymap").get_lsp(),
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "normal",
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
			},
			cmdline = {
				keymap = {
					preset = "inherit",
					["<CR>"] = { "accept_and_enter", "fallback" },
				},
			},
			sources = { default = { "lsp" } },
		},
	},
}
