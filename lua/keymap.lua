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


	map("n", "<F5>", "<cmd>Themify<CR>", { desc = "Select theme" })

	map("n", "<leader>no", "<cmd>NvimTreeOpen<CR>", { desc = "Open tree" })
	map("n", "<leader>nn", "<cmd>NvimTreeFocus<CR>", { desc = "Focus tree" })
	map("n", "<leader>nc", "<cmd>NvimTreeClose<CR>", { desc = "Close tree" })

	map("n", ";", function()
		vim.fn.feedkeys("q:", "n")
		vim.fn.feedkeys("i", "n")
	end, { desc = "Command history" })

	-- terminal mode
	map("n", "<leader>tt", function()
		vim.cmd("term")
	end, { desc = "Tab with terminal" })
	map("t", "<C-h>", "<left>")
	map("t", "<C-L>", "<right>")
	map("t", "<C-k>", "<up>")
	map("t", "<C-j>", "<down>")
	map("t", "<esc><esc>", "<C-\\><C-n>")
end

function Keymap.get_debug()
	return {
		{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
		{ "<leader>dc", function() require("dap").continue() end,          desc = "Continue" },
		{ "<F9>",       function() require("dap").continue() end,          desc = "Continue" },
		{ "<leader>do", function() require("dap").step_over() end,         desc = "Step over" },
		{ "<F7>",       function() require("dap").step_over() end,         desc = "Step over" },
		{ "<leader>di", function() require("dap").step_into() end,         desc = "Step into" },
		{ "<F8>",       function() require("dap").step_into() end,         desc = "Step into" },
		{ "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle debug ui" },
		{ "<leader>dC", function() require("dapui").terminate() end,       desc = "Terminate" },
		{ "<leader>dd", function() require("dapui").disconnect() end,      desc = "Disconnect" },
	}
end

function Keymap.get_bufferline()
	return {
		{ "gt",         "<Cmd>BufferLineCycleNext<CR>",  desc = "Next tab" },
		{ "gT",         "<Cmd>BufferLineCyclePrev<CR>",  desc = "Prev tab" },
		{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",  desc = "Toggle Pin" },
		{ "<leader>bb", "<Cmd>BufferLinePick<CR>",       desc = "Pick open" },
		{ "<leader>bc", "<Cmd>BufferLinePickClose<CR>",  desc = "Pick close" },
		{ "<leader>bC", "<Cmd>BufferLineCloseOther<CR>", desc = "Close other" },
		{ "<leader>bh", "<Cmd>BufferLineCloseLeft<CR>",  desc = "Close other" },
		{ "<leader>bl", "<Cmd>BufferLineCloseRight<CR>", desc = "Close other" },
	}
end

function Keymap.set_nvimtree(fn, api)
	fn("l", api.node.open.edit, "Open")
	fn("L", function()
		api.node.open.edit()
		vim.schedule(function()
			api.tree.focus()
		end)
	end, "Open: Without focus")
	fn("h", api.node.navigate.parent_close, "Close directory")
	fn("?", api.tree.toggle_help, "Toggle help")
	fn("'", api.node.open.preview, "Preview")
	fn("<tab>", api.marks.toggle, "Toggle bookmark")
end

function Keymap.get_snacks()
	return {
		{ "<leader><leader>", function() require("snacks").picker.smart() end,    desc = "Open picker" },
		{ "<leader>ts",       function() require("snacks").terminal.toggle() end, desc = "Split with terminal" },
		{ "<leader>fb",       function() require("snacks").picker.buffers() end,  desc = "Show buffers" },
		{ "<leader>fg",       function() require("snacks").picker.grep() end,     desc = "Grep in files" },
		{ "<leader>fd",       function() require("snacks").dashboard() end,       desc = "Open dashboard" },
		{
			"<leader>gi",
			function()
				require("snacks").lazygit(); vim.fn.feedkeys("i", "n")
			end,
			desc = "Open lazygit"
		},
		{ "<leader>gd", function() require("snacks").picker.git_diff() end,     desc = "Git diff" },
		{ "<leader>gs", function() require("snacks").picker.git_status() end,   desc = "Git status" },
		{ "<leader>gl", function() require("snacks").picker.git_log() end,      desc = "Git log" },
		{ "<leader>gf", function() require("snacks").picker.git_files() end,    desc = "Git files" },
		{ "<leader>gb", function() require("snacks").picker.git_branches() end, desc = "Git branches" },
	}
end

function Keymap.get_snacks_dashboard()
	return {
		{
			icon = "󰆧",
			key = "N",
			desc = "New File",
			action = function()
				vim.ui.input({
					prompt = "Enter file name: ",
					default = "new.txt",
					completion = ""
				}, function(input)
					if input and input ~= "" then
						vim.cmd("edit " .. input)
						vim.notify("Created file: " .. input, vim.log.levels.INFO)
					else
						vim.notify("Failed to create file: " .. input, vim.log.levels.ERROR)
					end
				end)
			end
		},
		{ icon = "󰂺", key = "O", desc = "Open file", action = "<cmd>lua Snacks.picker.files()<CR>" },
		{
			icon = "",
			key = "D",
			desc = "Open directory",
			action = function()
				vim.fn.feedkeys(":cd " .. vim.fn.getcwd(), "n")
			end

		},
		{ icon = " ", key = "E", desc = "Explorer", action = "<cmd>NvimTreeOpen<CR>" },
		{ icon = " ", key = "R", desc = "Recent Files", action = "<cmd>lua Snacks.picker.recent()<CR>" },
		{ icon = " ", key = "T", desc = "Select colorscheme", action = ":Themify" },
		{ icon = "󰒲", key = "L", desc = "Lazy", action = ":Lazy" },
		{ icon = "", key = "M", desc = "Mason", action = ":Mason" },
		{ icon = " ", key = "Q", desc = "Quit", action = ":qa" },
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

function Keymap.set_autosave(as)
	local timeout = { timeout = 2000 }
	vim.keymap.set("n", "<leader>es", function()
		as.on()
		vim.notify("Autosave: Enabled", vim.log.levels.INFO, timeout)
		vim.g.auto_save_enabled = true
	end, { desc = "Enable autosave" })
	vim.keymap.set("n", "<leader>eS", function()
		as.off()
		vim.notify("Autosave: Disabled", vim.log.levels.INFO, timeout)
		vim.g.auto_save_enabled = false
	end, { desc = "Disable autosave" })
	vim.keymap.set("n", "<leader>e<C-s>", function()
		if vim.g.auto_save_enabled then
			vim.notify("Autosave status: Enabled", vim.log.levels.INFO, timeout)
		else
			vim.notify("Autosave status: Disabled", vim.log.levels.INFO, timeout)
		end
	end, { desc = "Autosave status" })
end

return Keymap
