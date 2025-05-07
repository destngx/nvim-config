local M = {}

M.settings = {
  Lua = {
    diagnostics = {
      globals = { 'vim', 'bit', 'packer_plugins' }
    }
  }
}
vim.lsp.config.lua = {
  settings = M.settings,
}

vim.lsp.enable("lua")
