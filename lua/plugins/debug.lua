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
				name = "Debug file",
				request = "launch",
				program = function()
					return vim.fn.input("Path to file: ", vim.fn.getcwd() .. "/", "file")
				end,
			})

			dapui.setup()
			dap.listeners.before.attach.dapui_config =
				function() dapui.open() end
			dap.listeners.before.launch.dapui_config =
				function() dapui.open() end
			dap.listeners.before.event_terminated.dapui_config =
				function() dapui.close() end
			dap.listeners.before.event_exited.dapui_config =
				function() dapui.close() end
		end,
	},
}
