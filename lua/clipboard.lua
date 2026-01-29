local M = {}

--- @class HistoryElement
--- @field content string[]
--- @field type string
--- @field name string?
--- @field i integer?

--- @type HistoryElement[]
local history = {}
--- @type table<integer, HistoryElement>
local history_nammed = {}
--- @type integer
local last_push = 0
--- @type string
local last_push_str = ""

--- @type integer
M.history_length = 100
--- @type integer
M.polling_interval = 500
--- @type boolean
M.debug = false

--- @param text string
local function log_debug(text)
	if M.debug then
		vim.notify(text)
	end
end

--- @param content table
--- @param sub? integer
--- @return string
local function format_content(content, sub)
	if not content or type(content) ~= "table" then
		return ""
	end

	local formatted
	formatted = table.concat(content, "\n")
	formatted = formatted:gsub("\n", "^n")
	formatted = formatted:gsub("^%s+", "")
	formatted = formatted:gsub("%s+", " ")

	local sub_default = 100
	if #formatted > (sub or sub_default) then
		formatted = formatted:sub(1, sub or sub_default) .. "..."
	end

	return formatted
end

--- @param element HistoryElement?
--- @param nammed string?
local function history_push(element, nammed)
	if not element or not element.content or #element.content < 1 then
		return
	end
	local content_str = table.concat(element.content, "\n")
	if content_str == last_push_str or content_str:gsub("%s+", "") == "" then
		return
	end

	for i, v in ipairs(history) do
		local v_str = table.concat(v.content, "\n")
		if v_str == content_str then
			last_push = i
			log_debug("changed: " .. format_content(v.content))
			return
		end
	end

	if nammed then
		element.name = nammed
	end
	table.insert(history, element)

	log_debug("push:\n" .. format_content(element.content))
	last_push = #history
	last_push_str = content_str
	history[last_push].i = last_push

	if #history > M.history_length then
		table.remove(history, 1)
	end
end

--- @param alt boolean
--- @param feedkeys_mode string
--- @param register? string
local function emulate_p(alt, feedkeys_mode, register)
	local key = vim.api.nvim_replace_termcodes(
		(register and ('"' .. register) or "") .. (alt and "p" or "P"),
		true, false, true
	)
	vim.api.nvim_feedkeys(key, feedkeys_mode, false)
end

--- @param index integer?
--- @param alt boolean
--- @param nammed integer?
local function paste(index, alt, nammed)
	local item
	if not nammed then
		if index and index < 1 then
			index = last_push
		end
		if not index then
			index = last_push
		end

		item = history[index]
	else
		item = history_nammed[nammed]
	end

	if not item then
		print("bad item: " .. item)
		return
	end

	vim.fn.setreg('z', item.content, item.type)
	emulate_p(not alt, 'n', 'z')
end

--- @param name string
--- @return HistoryElement?
local function read_register(name)
	local info = vim.fn.getreginfo(name)
	if not info.regcontents or #info.regcontents < 1 then
		return nil
	end
	return {
		multiline = info.regtype == "V",
		type = info.regtype,
		content = info.regcontents,
	}
end

--- @return HistoryElement?
local function read_system()
	return read_register('+')
end

--- @param preload boolean?
--- @return HistoryElement[]?
local function read_registers(preload)
	local reg_names
	if preload then
		reg_names = { "-", "1", "0", '"', "+", "*", }
	else
		reg_names = { "-", "1", "+", "*", "0", '"' }
	end
	local regs = {}
	for _, name in ipairs(reg_names) do
		local reg = read_register(name)
		if reg and reg.content then
			table.insert(regs, reg)
		end
	end
	return regs
end

local function enable_osc52()
	vim.g.clipboard = {
		copy = {
			['+'] = require('vim.ui.clipboard.osc52').copy '+',
			['*'] = require('vim.ui.clipboard.osc52').paste '*',
		},
		paste = {
			['+'] = require('vim.ui.clipboard.osc52').paste '+',
			['*'] = require('vim.ui.clipboard.osc52').paste '*',
		},
	}
end

local group = vim.api.nvim_create_augroup("ClipboardGroup", { clear = true })

--- @class opts
--- @field remap boolean?
--- @field enable_osc52 boolean?
--- @field debug boolean?
--- @field disable_copy {x:boolean?, d:boolean?, s:boolean?, c:boolean?}?

--- @param opts opts?
function M.setup(opts)
	opts = opts or {}
	M.debug = opts.debug

	vim.api.nvim_create_autocmd("TextYankPost", {
		group = group,
		pattern = "*",
		callback = function()
			local ev = vim.v.event
			history_push({
				content = ev.regcontents,
				type = ev.regtype,
			})
		end
	})

	vim.api.nvim_create_autocmd("FocusGained", {
		group = group,
		pattern = "*",
		callback = function()
			history_push(read_system())
		end
	})

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP" }, {
		group = group,
		callback = function(_)
			vim.schedule(function()
				history_push(read_register('"'))
			end)
		end
	})

	vim.defer_fn(function()
		vim.cmd("rshada!")
		local regs = read_registers(true)
		if regs then
			for _, v in pairs(regs) do
				history_push(v)
			end
		end
	end, 100)
	if #history > 0 then
		history_push(history[1])
	end

	local remap = (opts.remap == true)
	if remap then
		vim.keymap.set({ "n", "x" }, "p", function()
			M.paste(false)
		end, { noremap = true, silent = true })
		vim.keymap.set({ "n", "x" }, "P", function()
			M.paste(true)
		end, { noremap = true, silent = true })
	end

	local osc = (opts.enable_osc52 == true)
	if osc then
		enable_osc52()
	end
end

--- @param alt boolean
function M.paste(alt)
	local count = vim.v.count
	local count_str = tostring(count)
	if count == 0 then
		paste(0, alt)
	elseif #count_str > 1 and count_str[0] == "1" then
		paste(0, alt, count)
	else
		paste(#history - count, alt)
	end
end

function M.print_history()
	local r = "# " .. format_content(history[last_push].content)
	for _, v in ipairs(history) do
		local preffix = v.type == "v" and "%" or "$"
		r = r .. string.format("\n%s ", preffix) .. format_content(v.content)
	end
	print(r:gsub("^%s", ""))
end

--- @param regs HistoryElement[]
--- @param fn function
--- @param prompt string?
local function select(regs, fn, prompt)
	vim.ui.select(regs, {
		prompt = (prompt or "Select"),
		format_item = function(item)
			return (item.type == "v" and "%" or "$") .. " " .. format_content(item.content)
		end,
	}, function(sel, _)
		if sel then
			fn(sel)
		end
	end)
end

function M.smart_paste()
	if #history == 0 then
		vim.notify("No registers", vim.log.levels.WARN)
		return
	end

	local mode = vim.fn.mode()
	local is_visual = mode:match("^[vV\22]") ~= nil

	select(vim.fn.reverse(vim.deepcopy(history)), function(sel)
		if not sel then
			return
		end

		vim.fn.setreg('z', sel.content, sel.type)

		vim.schedule(function()
			if is_visual then
				vim.cmd('normal! gv')
				paste(sel.i, false)
			else
				paste(sel.i, false)
				history_push(sel)
			end
		end)
	end, "Paste")
end

function M.smart_select()
	if #history == 0 then
		vim.notify("No registers", vim.log.levels.WARN)
		return
	end

	select(vim.fn.reverse(vim.deepcopy(history)), function(sel)
		history_push(sel)
	end, "Select")
end

function M.configure()
	vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true })
	vim.keymap.set("v", "x", '"_x', { noremap = true, silent = true })
end

return M
