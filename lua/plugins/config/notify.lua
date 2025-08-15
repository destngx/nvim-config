if DestNgxVim.plugins.notification.engine ~= 'fidget' then
  return
end
local fidget = require("fidget")

fidget.setup({
  notification = {
    window = { winblend = 0, relative = "editor", max_height = 55 },
  },
})

vim.notify = fidget.notify
return
