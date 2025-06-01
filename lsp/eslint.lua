local M = {}

local on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end

M.on_attach = on_attach;

M.filetypes = { "html", "mdx", "javascriptreact", "typescriptreact", "vue", "svelte" }

M.settings = {
  codeAction = {
    disableRuleComment = {
      enable = true,
      location = "separateLine"
    },
    showDocumentation = {
      enable = true
    }
  },
  codeActionOnSave = {
    enable = true,
    mode = "all"
  },
  dynamicRegistration = true,
  format = true,
  nodePath = "",
  onIgnoredFiles = "off",
  packageManager = "bun",
  quiet = false,
  rulesCustomizations = {},
  run = "onType",
  useESLintClass = false,
  validate = "on",
  workingDirectory = {
    mode = "location"
  }
}

vim.lsp.config.eslint = {
  on_attach = M.on_attach,
  filetypes = M.filetypes,
  settings = M.settings,
}
vim.lsp.enable("eslint")
