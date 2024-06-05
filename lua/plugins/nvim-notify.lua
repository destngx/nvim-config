local nvim_notify = require("notify")

nvim_notify.setup({
  background_colour = "#000000",
  render = "wrapped-compact",
})

vim.notify = nvim_notify
