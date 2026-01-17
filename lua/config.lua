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
	vim.opt.cursorline = true
	vim.opt.equalalways = false
	vim.opt.guicursor = "a:block"

	vim.g.mapleader = " "

	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	-- yank highlight
	vim.api.nvim_create_autocmd('TextYankPost', {
		pattern = '*',
		callback = function()
			vim.highlight.on_yank({ timeout = 170 })
		end,
		group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
	})

	-- lsp
	vim.diagnostic.config({ virtual_text = true })
end

function Config.post()
	-- disable snacks animations
	vim.g.snacks_animate = false

	-- disable vim status bar
	vim.opt.laststatus = 0
	vim.opt.cmdheight = 0
	vim.opt.showmode = false
end

return Config
