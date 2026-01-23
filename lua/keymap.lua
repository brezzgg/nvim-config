local Keymap = {}

function Keymap.default()
	local map = vim.keymap.set

	map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true, desc = "Go to definition" })
	map("n", "<leader>fo", function()
		local ft = vim.bo.filetype
		if ft == "go" then
			vim.cmd("GoFormat"); return
		end
		vim.cmd("lua vim.lsp.buf.format()")
	end, { noremap = true, silent = true, desc = "Format file" })

	map("n", "<C-w>q", "<cmd>q<CR>", { desc = "Quit" })

	-- lsp
	map("n", "C-K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Object info" })
	map("n", "gre", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Error info" })
	map("n", "grd", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Show declaration" })
	map("n", "<leader>re", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename" })
	map("n", "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<CR>", { desc = "Codelens run" })

	-- save actions
	map("n", "<leader>ew", "<cmd>wa<CR>", { desc = "Save all" })
	map("n", "<leader>eW", "<cmd>wqa!<CR>", { desc = "Force save & quit" })
	map("n", "<leader>eq", "<cmd>qa<CR>", { desc = "Quit all" })
	map("n", "<leader>eQ", "<cmd>qa!<CR>", { desc = "Force quit all" })

	-- resize
	map("n", "<F1>", "<cmd>vertical resize -5<CR>", { desc = "Vertical resize -" })
	map("n", "<F2>", "<cmd>vertical resize +5<CR>", { desc = "Vertical resize +" })
	map("n", "<F3>", "<cmd>horizontal resize -5<CR>", { desc = "Horizontal resize -" })
	map("n", "<F4>", "<cmd>horizontal resize +5<CR>", { desc = "Horizontal resize +" })

	-- tabs
	map("n", "gt", "<cmd>bnext<cr>", { noremap = true, silent = true, desc = "Next buffer" })
	map("n", "gT", "<cmd>bprev<cr>", { noremap = true, silent = true, desc = "Prev buffer" })

	-- whichkey
	map("n", "<leader>?", "<cmd>WhichKey<cr>", { desc = "Show which key" })

	-- command line
	map("c", "<C-l>", "<CR>")
	map("c", "<C-j>", "<down>")
	map("c", "<C-k>", "<up>")

	-- autoindent a
	map("n", "a", function()
		local line = vim.api.nvim_get_current_line()
		if line:match("^%s*$") then
			return '"_cc'
		end
		return "a"
	end, { expr = true, noremap = true })

	-- smart nvimtree focus
	map("n", "<leader>n", function()
		if vim.fn.bufname():match("NvimTree_") then
			vim.cmd.wincmd("p")
		else
			vim.cmd("NvimTreeFocus")
		end
	end, { desc = "Focus tree" })
	map("n", "<leader>No", "<cmd>NvimTreeOpen<CR>", { desc = "Open tree" })
	map("n", "<leader>Nc", "<cmd>NvimTreeClose<CR>", { desc = "Close tree" })

	map("n", "<C-;>", function()
		vim.fn.feedkeys("q:", "n")
		vim.fn.feedkeys("i", "n")
	end, { desc = "Command history" })

	-- terminal mod
	map("n", "<leader>t", "<cmd>TerminalFloat<CR>", { desc = "Float terminal toggle" })
	map("n", "<leader>T", "<cmd>TerminalBot<CR>", { desc = "Bot terminal toggle" })

	-- git
	map("n", "<leader>ghh", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Git hunk" })
	map("n", "<leader>ghl", "<cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Git hunk inline" })
	map("n", "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Git stage/unstage hunk" })
	map("n", "<leader>gi", "<cmd>Gitsigns blame_line<CR>", { desc = "Git blame line" })
end

function Keymap.set_cmp(cmp)
	return {
		["<C-n>"] = cmp.mapping.complete(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-l>"] = cmp.mapping.confirm({ select = true }),
		["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
	}
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

function Keymap.set_nvimtree(map, unmap, api)
	unmap("o")

	map("L", function()
		api.node.open.edit()
		vim.schedule(function()
			api.tree.focus()
		end)
	end, "Open: Without focus")

	map("l", api.node.open.edit, "Open")
	map("h", api.node.navigate.parent_close, "Close directory")
	map("'", api.node.open.preview, "Preview")

	map("?", api.tree.toggle_help, "Toggle help")
	map("<tab>", api.marks.toggle, "Toggle bookmark")

	map("o", api.node.run.system, "Open with system")
end

function Keymap.get_snacks()
	return {
		{ "<leader><leader>", function() require("snacks").picker.smart() end,   desc = "Open picker" },
		{ "<leader>b",        function() require("snacks").picker.buffers() end, desc = "Show buffers" },
		{ "<leader>fg",       function() require("snacks").picker.grep() end,    desc = "Grep in files" },
		{ "<leader>fd",       function() require("snacks").dashboard() end,      desc = "Open dashboard" },
		{ "<F5>",             function() require("snacks").dashboard() end,      desc = "Open dashboard" },
		{
			"<leader>G",
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

function Keymap.get_snacks_picker()
	return {
		["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
		["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
		["<C-l>"] = { "confirm", mode = { "i" } },
		["l"] = { "confirm", mode = { "n" } },
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
