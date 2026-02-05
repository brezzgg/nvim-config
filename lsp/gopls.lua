return {
	cmd = { "gopls" },
	filetypes = { "go" },
	root_markers = {
		"go.work",
		"go.mod",
		".git",
	},
	settings = {
		gopls = {
			gofumpt = true,
			completeUnimported = true,
			usePlaceholders = false,
			staticcheck = true,
			semanticTokens = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			analyses = {
				unusedparams = true,
				shadow = true,
			},
		},
	},
}
