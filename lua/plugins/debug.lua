return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},

		keys = require("keymap").get_debug(),

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("dap-go").setup()

			table.insert(dap.configurations.go, {
				type = "go",
				name = "Attach remote",
				request = "attach",
				mode = "remote",
				port = 50000,
			})

			table.insert(dap.configurations.go, {
				type = "go",
				name = "Debug file",
				request = "launch",
				program = function()
					return vim.fn.input("Path to file: ", vim.fn.getcwd() .. "/", "file")
				end,
			})

			dapui.setup()
		end,
	},
}
