local M = require("lualine.component"):extend()

M.processing = false
M.spinner_index = 1

local spinner_symbols = {
  "(" .. DestNgxVim.icons.copilotSleep .. "    )",
  "( " .. DestNgxVim.icons.copilotEnabled .. "   )",
  "(  " .. DestNgxVim.icons.copilotUnknown .. "  )",
  "(   " .. DestNgxVim.icons.copilotWarning .. " )",
  "(    " .. DestNgxVim.icons.copilotSleep .. ")",
  "(    " .. DestNgxVim.icons.copilotSleep .. ")",
  "(   " .. DestNgxVim.icons.copilotWarning .. " )",
  "(  " .. DestNgxVim.icons.copilotUnknown .. "  )",
  "( " .. DestNgxVim.icons.copilotEnabled .. "   )",
  "( " .. DestNgxVim.icons.copilotSleep .. "   )",
}
local spinner_symbols_len = 10

-- Initializer
function M:init(options)
  M.super.init(self, options)

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      if request.match == "CodeCompanionRequestStarted" then
        self.processing = true
      elseif request.match == "CodeCompanionRequestFinished" then
        self.processing = false
      end
    end,
  })
end

-- Function that runs every time statusline is updated
function M:update_status()
  if self.processing then
    self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
    return spinner_symbols[self.spinner_index]
  else
    return "(" .. DestNgxVim.icons.copilotSleep .. "     )"
  end
end

return M
