local M = {}

local present, _ = pcall(require, "which-key")
if not present then return end
local _, pwk = pcall(require, "which-key.setup")

local filter = require("lsp.utils.filter").filter
local filterReactDTS = require("lsp.utils.filterReactDTS").filterReactDTS

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = DestNgxVim.ui.float.border,
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = DestNgxVim.ui.float.border }
  ),
  ["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = true }
  ),
  ["textDocument/definition"] = function(err, result, method, ...)
    if vim.tbl_islist(result) and #result > 1 then
      local filtered_result = filter(result, filterReactDTS)
      return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method, ...)
    end

    vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
  end,
}

local settings = {
  typescript = {
    inlayHints = {
      parameterNames = { enabled = "literals" },
      parameterTypes = { enabled = false },
      variableTypes = { enabled = false },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = false },
      enumMemberValues = { enabled = true },
    },
    suggest = {
      includeCompletionsForModuleExports = false,
    },
  },
  javascript = {
    inlayHints = {
      parameterNames = { enabled = "literals" },
      parameterTypes = { enabled = false },
      variableTypes = { enabled = false },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = false },
      enumMemberValues = { enabled = true },
    },
    suggest = {
      includeCompletionsForModuleExports = false,
    },
  },
}

local on_attach = function(client, bufnr)
  vim.lsp.inlay_hint.enable(true, { bufnr })
  require("which-key").add({
    { buffer = bufnr },
    { "<leader>c",   group = "LSP", },
    { "<leader>ce",  "<cmd>TSC<CR>",                         desc = "workspace errors (TSC)" },
    { "<leader>cF",  "<cmd>VtsExec fix_all<CR>",             desc = "fix all" },
    { "<leader>ci",  "<cmd>VtsExec add_missing_imports<CR>", desc = "import all" },
    { "<leader>co",  "<cmd>VtsExec organize_imports<CR>",    desc = "organize imports" },
    { "<leader>cs",  "<cmd>VtsExec source_actions<CR>",      desc = "source actions" },
    { "<leader>cu",  "<cmd>VtsExec remove_unused<CR>",       desc = "remove unused" },
    { "<leader>cV",  "<cmd>VtsExec select_ts_version<CR>",   desc = "select TS version" },
    { "<leader>cF",  "<cmd>VtsExec file_references<CR>",     desc = "file references" },
  })
  require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end

M.handlers = handlers
M.settings = settings
M.on_attach = on_attach

return M
