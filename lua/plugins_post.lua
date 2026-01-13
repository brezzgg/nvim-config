-- treesitter
local sitter = require("nvim-treesitter")
sitter.install(
	"lua",
	"vim",
	"vimdoc",
	"markdown",
	"markdown_inline",
	"bash",
	"c",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"rust"
)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "<filetype>" },
	callback = function() vim.treesitter.start() end,
})
