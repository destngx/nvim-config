local utils = require('utils')

local async_present, async = pcall(require, "plenary.async")
if not async_present then
  return
end

-- Exported functions
local M = {}

M.first_DestNgxVim_run = function()
  local is_first_run = utils.file_exists('/tmp/first-DestNgxVim-run')

  if is_first_run then
    async.run(function()
      require('notify')("Welcome to DestNgxVim! Hope you'll have a nice experience!", "info",
        { title = "DestNgxVim", timeout = 5000 })
      require('notify')("Please install treesitter servers manually by :TSInstall command.", "info",
        { title = "Installation", timeout = 10000 })
    end)
    local suc = os.remove('/tmp/first-DestNgxVim-run')
    if (not suc) then print("Error: Couldn't remove /tmp/first-DestNgxVim-run!") end
  end
end

M.first_DestNgxVim_run()

local present, win = pcall(require, "lspconfig.ui.windows")
if not present then
  return
end

local _default_opts = win.default_opts
win.default_opts = function(options)
  local opts = _default_opts(options)
  opts.border = DestNgxVim.ui.float.border
  return opts
end

M.git_root = function()
  local git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(git_path, ":h")
end

return M
