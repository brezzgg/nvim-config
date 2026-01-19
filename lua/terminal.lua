local Terminal = {}

function Terminal.setup()
	vim.api.nvim_create_user_command("TerminalFloat", function()
		Terminal.float_toggle()
	end, {})

	vim.api.nvim_create_user_command("TerminalBot", function()
		Terminal.bot_toggle()
	end, {})
end

local shell = vim.o.shell:gsub('^"', ''):gsub('"$', '')

Terminal.float_buf = nil
Terminal.float_win = nil

function Terminal.float_toggle()
	if Terminal.float_win and vim.api.nvim_win_is_valid(Terminal.float_win) then
		vim.api.nvim_win_close(Terminal.float_win, true)
		Terminal.float_win = nil
		return
	end

	if not Terminal.float_buf or not vim.api.nvim_buf_is_valid(Terminal.float_buf) then
		Terminal.float_buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_call(Terminal.float_buf, function()
			vim.fn.jobstart({ shell }, {
				term = true,
				on_exit = function()
					vim.schedule(function()
						if Terminal.float_win and vim.api.nvim_win_is_valid(Terminal.float_win) then
							vim.api.nvim_win_close(Terminal.float_win, true)
							Terminal.float_win = nil
						end
						if Terminal.float_buf and vim.api.nvim_buf_is_valid(Terminal.float_buf) then
							vim.api.nvim_buf_delete(Terminal.float_buf, { force = true })
							Terminal.float_buf = nil
						end
						Terminal.float_toggle()
					end)
				end
			})
		end)

		vim.keymap.set("t", "<Esc>", function()
			if Terminal.float_win and vim.api.nvim_win_is_valid(Terminal.float_win) then
				vim.api.nvim_win_close(Terminal.float_win, true)
				Terminal.float_win = nil
			end
		end, { buffer = Terminal.float_buf, silent = true, noremap = true })

		vim.keymap.set("t", "<A-]>", function()
			vim.cmd("stopinsert")
		end, { buffer = Terminal.float_buf, silent = true, noremap = true })

		vim.keymap.set("t", "<A-[>", "<esc>", { buffer = Terminal.float_buf, silent = true, noremap = true })

		vim.keymap.set("n", "q", function()
			Terminal.float_toggle()
		end, { buffer = Terminal.float_buf, silent = true, noremap = true })
	end

	local width        = math.floor(vim.o.columns * 0.8)
	local height       = math.floor(vim.o.lines * 0.8)
	local row          = math.floor((vim.o.lines - height) / 2)
	local col          = math.floor((vim.o.columns - width) / 2)

	Terminal.float_win = vim.api.nvim_open_win(Terminal.float_buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
	})

	vim.cmd("startinsert")
end

Terminal.bot_buf = nil
Terminal.bot_win = nil

function Terminal.bot_toggle()
	if Terminal.bot_win and vim.api.nvim_win_is_valid(Terminal.bot_win) then
		vim.api.nvim_set_current_win(Terminal.bot_win)
		vim.cmd("startinsert")
		return
	end
	if not Terminal.bot_buf or not vim.api.nvim_buf_is_valid(Terminal.bot_buf) then
		Terminal.bot_buf = vim.api.nvim_create_buf(false, true)

		vim.api.nvim_buf_call(Terminal.bot_buf, function()
			vim.fn.jobstart({ shell }, {
				term = true,
				on_exit = function()
					vim.schedule(function()
						if Terminal.bot_win and vim.api.nvim_win_is_valid(Terminal.bot_win) then
							vim.api.nvim_win_close(Terminal.bot_win, true)
							Terminal.bot_win = nil
						end
						if Terminal.bot_buf and vim.api.nvim_buf_is_valid(Terminal.bot_buf) then
							vim.api.nvim_buf_delete(Terminal.bot_buf, { force = true })
							Terminal.bot_buf = nil
						end
					end)
				end,
			})
		end)

		vim.keymap.set("t", "<Esc>", function()
			vim.cmd("stopinsert")
			vim.cmd("wincmd p")
		end, { buffer = Terminal.bot_buf, silent = true, noremap = true })

		vim.keymap.set("n", "<Esc>", function()
			vim.cmd("wincmd p")
		end, { buffer = Terminal.bot_buf, silent = true, noremap = true })

		vim.keymap.set("t", "<A-]>", function()
			vim.cmd("stopinsert")
		end, { buffer = Terminal.bot_buf, silent = true, noremap = true })

		vim.keymap.set("t", "<A-[>", "<esc>", {
			buffer = Terminal.bot_buf, silent = true, noremap = true
		})

		vim.keymap.set("n", "q", function()
			if Terminal.bot_win and vim.api.nvim_win_is_valid(Terminal.bot_win) then
				vim.api.nvim_win_close(Terminal.bot_win, true)
				Terminal.bot_win = nil
			end
		end, { buffer = Terminal.bot_buf, silent = true, noremap = true })
	end

	vim.cmd("botright 14split")
	Terminal.bot_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(Terminal.bot_win, Terminal.bot_buf)

	vim.cmd("startinsert")
end

return Terminal
