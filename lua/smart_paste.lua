vim.api.nvim_create_user_command("SmartPaste", function(_)
	require("smart_paste").paste()
end, {})

vim.api.nvim_create_user_command("SmartSelect", function(_)
	require("smart_paste").select()
end, {})

local function parse()
	local reg_names = {
		"+", "*", ":", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "-", '"',
	}

	local regs = {}
	local seen = {}
	for _, name in ipairs(reg_names) do
		local content = vim.fn.getreg(name)

		if type(content) == "string" and #string.gsub(content, "%s+", "") > 0 then
			if not seen[content] then
				seen[content] = true

				local short = string.gsub(content, "\n", "^n")
				short = string.gsub(short, "%s+", " ")
				short = string.gsub(short, "^%s+", "")

				local short_len = 100
				if #short > short_len then
					short = string.sub(short, 1, short_len) .. "..."
				end

				regs[#regs + 1] = {
					name = name,
					real = content,
					short = short,
				}
			end
		end
	end

	return regs
end

local function select(regs, fn)
	vim.ui.select(regs, {
		prompt = "Select regiser:",
		format_item = function(item)
			return string.format("%s", item.short)
		end,
	}, function(sel, _)
		if sel then
			fn(sel)
		end
	end)
end

local SmartPaste = {}

function SmartPaste.paste()
	local regs = parse()

	if #regs == 0 then
		vim.notify("No registers", vim.log.levels.WARN)
		return
	end

	local mode = vim.fn.mode()
	local is_visual = mode:match("^[vV\22]") ~= nil

	select(regs, function(sel)
		if not sel then
			return
		end

		vim.fn.setreg('"', sel.real)
		vim.fn.setreg('*', sel.real)
		vim.fn.setreg('+', sel.real)

		vim.schedule(function()
			if is_visual then
				vim.cmd('normal! gv"_dP')
			else
				vim.api.nvim_put(vim.split(sel.real, "\n", { plain = true }), "", true, true)
			end
		end)
	end)
end

function SmartPaste.select()
	local regs = parse()

	if #regs == 0 then
		vim.notify("No registers", vim.log.levels.WARN)
		return
	end

	select(regs, function(sel)
		vim.fn.setreg('"', sel.real)
		vim.fn.setreg('*', sel.real)
		vim.fn.setreg('+', sel.real)
	end)
end

function SmartPaste.configure()
	vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true })
	vim.keymap.set("v", "x", '"_x', { noremap = true, silent = true })
end

return SmartPaste
