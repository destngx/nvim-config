-- local nvim_notify = require("notify")
--
-- nvim_notify.setup({
--   background_colour = "#000000",
--   render = "wrapped-compact",
-- })
--
-- vim.notify = nvim_notify

local fidget = require("fidget")

fidget.setup({
  notification = {
    window = { winblend = 0, relative = "editor", max_height = 5 },
  },
})

vim.notify = fidget.notify
return
