local Config = {}

function Config.pre()
	-- default
	vim.opt.nu = true
	vim.opt.relativenumber = true
	vim.opt.tabstop = 4
	vim.opt.softtabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.winborder = "rounded"
	vim.opt.clipboard = "unnamedplus"

	vim.g.mapleader = " "

	-- yank highlight
	local ag = vim.api.nvim_create_augroup

	local highlight_group = ag('YankHighlight', { clear = true })

	vim.api.nvim_create_autocmd('TextYankPost', {
		pattern = '*',
		callback = function()
			vim.highlight.on_yank({ timeout = 170 })
		end,
		group = highlight_group,
	})

	-- lsp
	vim.diagnostic.config({ virtual_text = true })
end

function Config.post()
	-- disable snacks animations
	vim.g.snacks_animate = false
end

return Config
