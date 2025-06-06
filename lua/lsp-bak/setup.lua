local mason_ok, mason = pcall(require, "mason")
local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
local ufo_config_handler = require("lsp.utils._ufo").handler

if not mason_ok or not mason_lsp_ok then
  return
end

mason.setup({
  ui = {
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = DestNgxVim.ui.float.border or "rounded",
  },
})


mason_lsp.setup({
  -- A list of servers to automatically install if they're not already installed
  ensure_installed = {
    "lua_ls",
    "vtsls",
    "dockerls",
    "docker_compose_language_service",
    "terraformls",
    "vale_ls",
    "helm_ls",
    -- "makrdownlint-cli2",
    -- "markdown-toc",
    -- "bashls",
    -- "cssls",
    -- "eslint",
    -- "html",
    -- "markdown",
    -- "markdown_inline",
    -- "markman",
    -- "jsonls",
    -- "tailwindcss",
    -- "pylsp",

  },
  automatic_installation = true,
})

local lspconfig = require("lspconfig")

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

local function on_attach(_, bufnr)
  vim.lsp.inlay_hint.enable(true, { bufnr })
  -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
  -- Be aware that you also will need to properly configure your LSP server to
  -- provide the inlay hints.
end

local capabilities = require("blink.cmp").get_lsp_capabilities()


capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

vim.lsp.config("*", {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = on_attach,
})


-- require("mason-lspconfig").setup_handlers {
--   function(server_name)
--     require("lspconfig")[server_name].setup {
--       on_attach = on_attach,
--       capabilities = capabilities,
--       handlers = handlers,
--     }
--   end,
--   ["vtsls"] = function()
--     require("lspconfig.configs").vtsls = require("vtsls").lspconfig
--
--     lspconfig.vtsls.setup({
--       capabilities = capabilities,
--       handlers = require("lsp.servers.vtsls").handlers,
--       on_attach = require("lsp.servers.vtsls").on_attach,
--       settings = require("lsp.servers.vtsls").settings,
--     })
--   end,
--   ["ts_ls"] = function()
--     -- skip to use vtsls
--     return true
--   end,
--   ["tailwindcss"] = function()
--     lspconfig.tailwindcss.setup({
--       capabilities = require("lsp.servers.tailwindcss").capabilities,
--       filetypes = require("lsp.servers.tailwindcss").filetypes,
--       handlers = handlers,
--       init_options = require("lsp.servers.tailwindcss").init_options,
--       on_attach = require("lsp.servers.tailwindcss").on_attach,
--       settings = require("lsp.servers.tailwindcss").settings,
--     })
--   end,
--   ["cssls"] = function()
--     lspconfig.cssls.setup({
--       capabilities = capabilities,
--       handlers = handlers,
--       on_attach = require("lsp.servers.cssls").on_attach,
--       settings = require("lsp.servers.cssls").settings,
--     })
--   end,
--   ["eslint"] = function()
--     lspconfig.eslint.setup({
--       capabilities = capabilities,
--       filetypes = require("lsp.servers.eslint").filetypes,
--       handlers = handlers,
--       on_attach = require("lsp.servers.eslint").on_attach,
--       settings = require("lsp.servers.eslint").settings,
--     })
--   end,
--   ["jsonls"] = function()
--     lspconfig.jsonls.setup({
--       capabilities = capabilities,
--       handlers = handlers,
--       on_attach = on_attach,
--       settings = require("lsp.servers.jsonls").settings,
--     })
--   end,
--   ["lua_ls"] = function()
--     lspconfig.lua_ls.setup({
--       capabilities = capabilities,
--       handlers = handlers,
--       on_attach = on_attach,
--       settings = require("lsp.servers.lua_ls").settings,
--     })
--   end,
--   ["vuels"] = function()
--     lspconfig.vuels.setup({
--       filetypes = require("lsp.servers.vuels").filetypes,
--       handlers = handlers,
--       init_options = require("lsp.servers.vuels").init_options,
--       on_attach = require("lsp.servers.vuels").on_attach,
--       settings = require("lsp.servers.vuels").settings,
--     })
--   end,
--   ["pylsp"] = function()
--     lspconfig.pylsp.setup({
--       on_attach = on_attach,
--       settings = require("lsp.servers.python").settings,
--       flags = {
--         debounce_text_changes = 200,
--       },
--       capabilities = capabilities,
--     })
--   end,
--   ["yamlls"] = function()
--     lspconfig.yamlls.setup({
--       handlers = handlers,
--       on_attach = on_attach,
--       capabilities = capabilities,
--       settings = require("lsp.servers.yamlls").settings
--     })
--   end,
-- }

require("ufo").setup({
  fold_virt_text_handler = ufo_config_handler,
  close_fold_kinds_for_ft = {
    default = { "imports", "comment" },
    markdown = { "marker" },
    json = { 'array' },
    c = { 'comment', 'region' }
  },
})
