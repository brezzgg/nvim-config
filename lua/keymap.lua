local Keymap = {}

function Keymap.default()
	local map = vim.keymap.set

	map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true, desc = "Go to definition" })
	map("n", "<leader>fo", "<cmd>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true, desc = "Format file" })

	map("n", "<C-w>q", "<cmd>q<CR>", { desc = "Quit" })

	map("n", "C-K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Object info" })
	map("n", "<leader>ee", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Error info" })
	map("n", "<leader>ed", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Show declaration" })
	map("n", "<leader>ei", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Show implementation" })
	map("n", "<leader>er", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Show references" })
	map("n", "<leader>en", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename" })
	map("n", "<leader>et", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "Type definition" })
	map("n", "<leader>ew", "<cmd>wa<CR>", { desc = "Save all" })
	map("n", "<leader>eW", "<cmd>wqa!<CR>", { desc = "Force save & quit" })
	map("n", "<leader>eq", "<cmd>qa<CR>", { desc = "Quit all" })
	map("n", "<leader>eQ", "<cmd>qa!<CR>", { desc = "Force quit all" })

	map("n", "<F1>", "<cmd>vertical resize -5<CR>", { desc = "Vertical resize -" })
	map("n", "<F2>", "<cmd>vertical resize +5<CR>", { desc = "Vertical resize +" })
	map("n", "<F3>", "<cmd>horizontal resize -5<CR>", { desc = "Horizontal resize -" })
	map("n", "<F4>", "<cmd>horizontal resize +5<CR>", { desc = "Horizontal resize +" })
end

function Keymap.get_debug()
	return {
		{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
		{ "<leader>dc", function() require("dap").continue() end,          desc = "Continue" },
		{ "<F9>",       function() require("dap").continue() end,          desc = "Continue" },
		{ "<F7>",       function() require("dap").step_over() end,         desc = "Step over" },
		{ "<F8>",       function() require("dap").step_into() end,         desc = "Step into" },
		{ "<leader>di", function() require("dapui").toggle() end,          desc = "Toggle debug ui" },
	}
end

function Keymap.get_snacks()
	return {
		{ "<leader><leader>", function() require("snacks").picker.smart() end,        desc = "Open picker" },
		{ "<leader>t",        function() require("snacks").terminal() end,            desc = "Open terminal" },
		{ "<leader>n",        function() require("snacks").explorer() end,            desc = "Open explorer" },
		{ "<leader>eb",       function() require("snacks").picker.buffers() end,      desc = "Show buffers" },
		{ "<leader>fg",       function() require("snacks").picker.grep() end,         desc = "Grep in files" },
		{ "<leader>gi",       function() require("snacks").lazygit() end,             desc = "Open lazygit" },
		{ "<leader>gd",       function() require("snacks").picker.git_diff() end,     desc = "Git diff" },
		{ "<leader>gs",       function() require("snacks").picker.git_status() end,   desc = "Git status" },
		{ "<leader>gl",       function() require("snacks").picker.git_log() end,      desc = "Git log" },
		{ "<leader>gf",       function() require("snacks").picker.git_files() end,    desc = "Git files" },
		{ "<leader>gb",       function() require("snacks").picker.git_branches() end, desc = "Git branches" },
	}
end

function Keymap.get_lsp()
	return {
		preset = "default",
		["<C-space>"] = {},
		["<C-p>"] = {},
		["<Tab>"] = {},
		["<S-Tab>"] = {},
		["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-n>"] = { "select_and_accept" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
	}
end

return Keymap
