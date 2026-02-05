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
	vim.opt.fillchars = { eob = " " }

	vim.opt.undofile = true
	vim.opt.undolevels = 1000
	vim.opt.undoreload = 10000

	vim.g.mapleader = " "

	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	-- lsp
	vim.diagnostic.config({ virtual_text = true })
end

function Config.post()
	-- disable vim status bar
	vim.opt.laststatus = 0
	vim.opt.cmdheight = 0
	vim.opt.showmode = false
end

return Config
