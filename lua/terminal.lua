local Terminal = {}

function Terminal.setup()
	vim.api.nvim_create_user_command("TerminalFloat", function()
		Terminal.float_toggle()
	end, {})

	vim.api.nvim_create_user_command("TerminalBot", function()
		Terminal.bot_toggle()
	end, {})

	vim.api.nvim_create_user_command("TerminalSelect", function()
		Terminal.select()
	end, {})

	vim.api.nvim_create_user_command("TerminalClose", function()
		Terminal.close()
	end, {})

	local term_group = vim.api.nvim_create_augroup("TerminalFixPlugins", { clear = true })
	vim.api.nvim_create_autocmd("TermLeave", {
		group = term_group,
		callback = function()
			vim.schedule(function()
				local buftype = vim.bo.buftype
				if buftype ~= "terminal" then
					local mode = vim.fn.mode()
					if mode == "i" then
						vim.cmd("doautocmd InsertEnter")
					end
				end
			end)
		end,
	})
	vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
		group = term_group,
		pattern = "term://*",
		callback = function()
			vim.schedule(function()
				vim.cmd("startinsert")
			end)
		end,
	})
	vim.api.nvim_create_autocmd({ "BufWinLeave", "WinLeave" }, {
		group = term_group,
		pattern = "term://*",
		callback = function()
			if vim.fn.mode() == "t" then
				vim.cmd("stopinsert")
			end
		end,
	})
end

local _shell = vim.o.shell:gsub('^"', ''):gsub('"$', '')

local function float_process(name, opts)
	local o = opts or {}
	local autoclose = o.autoclose ~= true

	if not Terminal.container[name] then
		return
	end

	if Terminal.container[name].win and vim.api.nvim_win_is_valid(Terminal.container[name].win) then
		vim.api.nvim_win_close(Terminal.container[name].win, true)
		Terminal.container[name].win = nil
		return
	end

	if not Terminal.container[name].buf or not vim.api.nvim_buf_is_valid(Terminal.container[name].buf) then
		Terminal.container[name].buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_call(Terminal.container[name].buf, function()
			vim.fn.jobstart({ o.cmd }, {
				term = true,
				on_exit = function()
					vim.schedule(function()
						if Terminal.container[name] then
							if Terminal.container[name].win and vim.api.nvim_win_is_valid(Terminal.container[name].win) then
								vim.api.nvim_win_close(Terminal.container[name].win, true)
								Terminal.container[name].win = nil
							end
							if Terminal.container[name].buf and vim.api.nvim_buf_is_valid(Terminal.container[name].buf) then
								vim.api.nvim_buf_delete(Terminal.container[name].buf, { force = true })
								Terminal.container[name].buf = nil
							end
						end
					end)
					if not autoclose then
						float_process(name, opts)
					end
				end
			})
		end)

		vim.keymap.set("t", "<Esc>", function()
			if Terminal.container[name].win and vim.api.nvim_win_is_valid(Terminal.container[name].win) then
				vim.api.nvim_win_close(Terminal.container[name].win, true)
				Terminal.container[name].win = nil
			end
		end, { buffer = Terminal.container[name].buf, silent = true, noremap = true })

		vim.keymap.set("t", "<A-]>", function()
			vim.cmd("stopinsert")
		end, { buffer = Terminal.container[name].buf, silent = true, noremap = true })

		vim.keymap.set("t", "<A-[>", "<esc>", { buffer = Terminal.container[name].buf, silent = true, noremap = true })

		vim.keymap.set("n", "q", function()
			float_process(name, opts)
		end, { buffer = Terminal.container[name].buf, silent = true, noremap = true })
	end

	local width                  = math.floor(vim.o.columns * (o.width or 0.8))
	local height                 = math.floor(vim.o.lines * (o.height or 0.8))
	local row                    = math.floor((vim.o.lines - height) / 2)
	local col                    = math.floor((vim.o.columns - width) / 2)

	Terminal.container[name].win = vim.api.nvim_open_win(Terminal.container[name].buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
	})

	vim.schedule(function()
		if vim.api.nvim_get_current_buf() == Terminal.container[name].buf then
			vim.cmd("startinsert")
		end
	end)
end

local function bot_process(name, opts)
	local o = opts or {}

	if Terminal.container[name].win and vim.api.nvim_win_is_valid(Terminal.container[name].win) then
		vim.api.nvim_set_current_win(Terminal.container[name].win)
		vim.schedule(function()
			vim.cmd("startinsert")
		end)
		return
	end
	if not Terminal.container[name].buf or not vim.api.nvim_buf_is_valid(Terminal.container[name].buf) then
		Terminal.container[name].buf = vim.api.nvim_create_buf(false, true)

		vim.api.nvim_buf_call(Terminal.container[name].buf, function()
			vim.fn.jobstart({ o.cmd }, {
				term = true,
				on_exit = function()
					if close_action then
						return
					end
					vim.schedule(function()
						if Terminal.container[name].win and vim.api.nvim_win_is_valid(Terminal.container[name].win) then
							vim.api.nvim_win_close(Terminal.container[name].win, true)
							Terminal.container[name].win = nil
						end
						if Terminal.container[name].buf and vim.api.nvim_buf_is_valid(Terminal.container[name].buf) then
							vim.api.nvim_buf_delete(Terminal.container[name].buf, { force = true })
							Terminal.container[name].buf = nil
						end
					end)
				end,
			})
		end)

		vim.keymap.set("t", "<Esc>", function()
			vim.cmd("stopinsert")
			vim.cmd("wincmd p")
		end, { buffer = Terminal.container[name].buf, silent = true, noremap = true })

		vim.keymap.set("n", "<Esc>", function()
			vim.cmd("wincmd p")
		end, { buffer = Terminal.container[name].buf, silent = true, noremap = true })

		vim.keymap.set("t", "<A-]>", function()
			vim.cmd("stopinsert")
		end, { buffer = Terminal.container[name].buf, silent = true, noremap = true })

		vim.keymap.set("t", "<A-[>", "<esc>", {
			buffer = Terminal.container[name].buf, silent = true, noremap = true
		})

		vim.keymap.set("n", "q", function()
			if Terminal.container[name].win and vim.api.nvim_win_is_valid(Terminal.container[name].win) then
				vim.api.nvim_win_close(Terminal.container[name].win, true)
				Terminal.container[name].win = nil
			end
		end, { buffer = Terminal.container[name].buf, silent = true, noremap = true })
	end

	vim.cmd(string.format("botright %dsplit", o.height or 14))
	Terminal.container[name].win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(Terminal.container[name].win, Terminal.container[name].buf)

	vim.schedule(function()
		vim.cmd("startinsert")
	end)
end

local function close(name)
	if Terminal.container[name].buf then
		vim.api.nvim_buf_delete(Terminal.container[name].buf, { force = true })
		Terminal.container[name].buf = nil
	end
	if Terminal.container[name].win then
		vim.api.nvim_win_close(Terminal.container[name].win, true)
		Terminal.container[name].win = nil
	end
	Terminal.container[name] = nil
end

local function format_cmd(cmd)
	cmd = string.gsub(cmd, "\\", "/")
	cmd = vim.fn.fnamemodify(cmd, ":t")
	return cmd
end

local function format_name(name)
	return string.format("[%d] %s", vim.v.count1, name)
end

Terminal.container = {}
Terminal.type_float = "float"
Terminal.type_bot = "bot"
Terminal.name_float = "float"
Terminal.name_bot = "bot"

function Terminal.float_toggle(opts)
	Terminal.custom_toggle(
		Terminal.name_float,
		Terminal.type_float,
		opts,
		true
	)
end

function Terminal.bot_toggle(opts)
	Terminal.custom_toggle(
		Terminal.name_bot,
		Terminal.type_bot,
		opts,
		true
	)
end

function Terminal.select()
	if not next(Terminal.container) then
		print("No active terminals"); return
	end

	local items = {}
	for _, v in pairs(Terminal.container) do
		if v then
			table.insert(items, v)
		end
	end

	if #items == 0 then
		print("No active terminals"); return
	end

	vim.ui.select(items,
		{
			prompt = "Select terminal",
			format_item = function(item)
				return string.format("%s(%s)", item.last_name, format_cmd(item.last_opts.cmd) or "<unknown>")
			end
		},
		function(sel, _)
			if sel then
				Terminal.custom_toggle(sel.last_name, sel.last_type, sel.last_opts, false)
			end
		end
	)
end

function Terminal.custom_toggle(name, type, opts, checkcount)
	if checkcount ~= false then
		name = format_name(name)
	end
	local toggle = Terminal.container[name]
	if not toggle then
		Terminal.container[name] = { buf = nil, win = nil }
		toggle = Terminal.container[name]
	end

	if not opts then
		opts = {}
	end
	if not opts.cmd then
		opts.cmd = _shell
	end

	Terminal.container[name].last_opts = opts
	Terminal.container[name].last_name = name
	Terminal.container[name].last_type = type

	if type == Terminal.type_float then
		float_process(name, opts); return
	end
	if type == Terminal.type_bot then
		bot_process(name, opts); return
	end
	print(string.format("Unknown terminal type: %s", type))
end

function Terminal.close(val)
	if val and type(val) == "string" then
		if val == Terminal.type_float then
			close(format_name(Terminal.name_float))
			return
		end
		if val == Terminal.type_bot then
			close(format_name(Terminal.name_bot))
			return
		end

		if Terminal.container[val] then
			close(val)
			return
		end
	end

	if not next(Terminal.container) then
		print("No active terminals"); return
	end

	local items = {}
	for _, v in pairs(Terminal.container) do
		if v then
			table.insert(items, v)
		end
	end

	if #items == 0 then
		print("No active terminals"); return
	end

	vim.ui.select(items,
		{
			prompt = "Close terminal",
			format_item = function(item)
				return string.format("%s(%s)", item.last_name, format_cmd(item.last_opts.cmd) or "<unknown>")
			end
		},
		function(sel, _)
			if sel then
				close(sel.last_name)
			end
		end
	)
end

return Terminal
