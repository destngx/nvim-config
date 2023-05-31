local nonicons_extention = require("nvim-nonicons.extentions.nvim-notify")
require("notify").setup({
  icons = nonicons_extention.icons,
  background_colour = "#000000",
})
