vim.lsp.enable("python")
local M = {}
local settings = {
  pylsp = {
    plugins = {
      pylint = { enabled = true, executable = "pylint" },
      pyflakes = { enabled = false },
      pycodestyle = { enabled = false },
      jedi_completion = { fuzzy = true },
      pyls_isort = { enabled = true },
      pylsp_mypy = { enabled = true },
    },
  },
}

M.settings = settings

return M
