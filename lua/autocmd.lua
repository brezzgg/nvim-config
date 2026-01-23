-- treesitter
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TreeSitterStart", { clear = true }),
	pattern = { "<filetype>" },
	callback = function() vim.treesitter.start() end,
})

-- codelens
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspCodeLense", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf

		if client and client.server_capabilities.codeLensProvider then
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				buffer = bufnr,
				callback = function()
					vim.lsp.codelens.refresh()
				end,
			})

			vim.lsp.codelens.refresh()
		end
	end,
})

-- yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
	pattern = '*',
	callback = function()
		vim.highlight.on_yank({ timeout = 170 })
	end,
	group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
})

-- go disable package comment check
local default_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
	if result and result.diagnostics then
		local filtered = {}
		for _, d in ipairs(result.diagnostics) do
			if not d.message:find("at least one file in a package should have a package comment") then
				table.insert(filtered, d)
			end
		end
		result.diagnostics = filtered
	end
	default_handler(err, result, ctx, config)
end
