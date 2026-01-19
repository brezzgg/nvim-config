require("config").pre()
require("terminal").setup()

require("bootstrap_lazy")
require("lazy").setup("plugins")
require("plugins_post")

require("config").post()
require("keymap").default()

-- require("clipboard").osc52()
