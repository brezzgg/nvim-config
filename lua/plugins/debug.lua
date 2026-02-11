return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- "leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},

		keys = require("keymap").get_debug(),

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dap.adapters.go = function(callback, _)
				callback({
					type = "server",
					host = "127.0.0.1",
					port = 38697,
				})
			end

			dap.configurations.go = {
				{
					name = "Attach (headless dlv)",
					type = "go",
					request = "attach",
					mode = "remote",
				},
			}
			dapui.setup()
		end,
	},
}
