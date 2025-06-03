-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/jsonls.lua

local M = {
	cmd = { "vscode-json-language-server", "--stdio", },
  filetypes = {
    "json",
    "jsonc",
  },
  root_markers = {
    ".git",
  },
  init_options = { provideFormatter = true },
  single_file_support = true,
  -- lazy-load schemastore when needed
  on_new_config = function(new_config)
    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
  end,
  settings = {
    json = {
      format = {
        enable = true,
      },

      validate = { enable = true },
      schemas = {
        {
          fileMatch = { ".releaserc.json" },
          url = "https://json.schemastore.org/semantic-release.json"
        },
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json"
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json"
        },
        {
          fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
          url = "https://json.schemastore.org/prettierrc.json"
        },
        {
          fileMatch = { ".eslintrc", ".eslintrc.json" },
          url = "https://json.schemastore.org/eslintrc.json"
        },
        {
          fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
          url = "https://json.schemastore.org/babelrc.json"
        },
        {
          fileMatch = { "lerna.json" },
          url = "https://json.schemastore.org/lerna.json"
        },
        {
          fileMatch = { "now.json", "vercel.json" },
          url = "https://json.schemastore.org/now.json"
        },
        {
          fileMatch = { "ecosystem.json" },
          url = "https://json.schemastore.org/pm2-ecosystem.json"
        },
      }
    },
  },
}




return M
