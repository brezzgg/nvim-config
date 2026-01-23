require("config").pre()
require("terminal").setup()

require("bootstrap_lazy")
require("lazy").setup("plugins")

require("autocmd")

require("config").post()
require("keymap").default()

-- require("clipboard").osc52()
