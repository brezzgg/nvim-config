local Clipboard = {}

function Clipboard.osc52()
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

return Clipboard
