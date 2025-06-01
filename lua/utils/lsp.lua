local M = {}

local blinkCapabilities = require("blink.cmp").get_lsp_capabilities()

M.get_default_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- required by nvim-ufo
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  capabilities = vim.tbl_deep_extend("force", capabilities, blinkCapabilities)
  return capabilities
end

return M

