local capabilities = require("utils.lsp").get_default_capabilities()

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = DestNgxVim.ui.float.border,
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = DestNgxVim.ui.float.border }),
  ["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = DestNgxVim.lsp.virtual_text }
  ),
}
vim.lsp.config("*", {
  capabilities = capabilities,
  handlers = handlers,
  flags = {
    debounce_text_changes = 500,
  },
})

vim.lsp.enable("lua_ls")

