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
			dapui.setup()
		end,
	},
}
