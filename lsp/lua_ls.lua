-- local M = {}
-- M.settings = {
--   Lua = {
--     diagnostics = {
--       globals = { 'vim', 'packer_plugins' }
--     },
--     hint = {
--       enable = true,
--     }
--   }
-- }
--
-- vim.lsp.enable('lua_ls')
-- return M
local library = vim.api.nvim_get_runtime_file("lua", true)
table.insert(library, '${3rd}/luv/library')

--- @type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  settings = {
    Lua = {
      runtime = {
        path = { "?.lua", "?/init.lua" },
        pathStrict = true,
        version = "LuaJIT"
      },
      workspace = {
        library = library,
      },
      diagnostics = {
        disable = { "missing-fields" },
        globals = { 'vim' }
      },
      telemetry = { enable = false },
      hint = {
        enable = true,
      }

    }
  }
}
