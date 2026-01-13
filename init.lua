require("config").pre()

require("bootstrap_lazy")
require("lazy").setup("plugins")

require("config").post()
require("keymap").default()
