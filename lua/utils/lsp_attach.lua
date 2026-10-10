-- Applies the `attach_mode` field of each lsp/<name>.lua in this config:
--   "autoattach" (default) - start on matching buffers, like vim.lsp.enable()
--   "ondemand"             - start only via M.attach() (<leader>cA)
--   "disable"              - never start

---@class vim.lsp.Config
---@field attach_mode? "autoattach"|"ondemand"|"disable"

local M = {}

local MODES = { autoattach = true, ondemand = true, disable = true }

---@type table<string, true>
local _ondemand = {}

---@param config vim.lsp.Config
---@return boolean
local function _is_installed(config)
  return type(config.cmd) ~= "table" or vim.fn.executable(config.cmd[1]) == 1
end

---@param name string
---@return vim.lsp.Config?
local function _resolve(name)
  local config_ok, config = pcall(function()
    return vim.lsp.config[name]
  end)
  if not config_ok then
    vim.notify(("LSP config %s failed to load: %s"):format(name, config), vim.log.levels.ERROR)
    return nil
  end
  return config
end

function M.setup()
  for file, kind in vim.fs.dir(vim.fn.stdpath("config") .. "/lsp") do
    local name = kind == "file" and file:match("^(.+)%.lua$")
    local config = name and _resolve(name)
    if config then
      local mode = config.attach_mode or "autoattach"
      if not MODES[mode] then
        vim.notify(("LSP %s: unknown attach_mode %q"):format(name, mode), vim.log.levels.WARN)
      elseif mode == "autoattach" and _is_installed(config) then
        vim.lsp.enable(name)
      elseif mode == "ondemand" then
        _ondemand[name] = true
      end
    end
  end
end

--- Start the on-demand servers for the buffer's filetype. They stay enabled for the
--- rest of the session, so other buffers of that filetype attach as well.
---@param bufnr? integer
function M.attach(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  local started, enabled, missing = {}, {}, {}

  for name in vim.spairs(_ondemand) do
    local config = vim.lsp.config[name]
    if config and (not config.filetypes or vim.tbl_contains(config.filetypes, filetype)) then
      if vim.lsp.is_enabled(name) then
        table.insert(enabled, name)
      elseif _is_installed(config) then
        table.insert(started, name)
      else
        table.insert(missing, name)
      end
    end
  end

  if #started > 0 then
    vim.lsp.enable(started)
    vim.notify("Starting LSP: " .. table.concat(started, ", "))
  end
  if #missing > 0 then
    vim.notify("LSP not installed: " .. table.concat(missing, ", "), vim.log.levels.WARN)
  end
  if #started + #enabled + #missing == 0 then
    vim.notify(("No on-demand LSP for filetype %q"):format(filetype), vim.log.levels.INFO)
  elseif #started + #missing == 0 then
    vim.notify("LSP already enabled: " .. table.concat(enabled, ", "))
  end
end

return M
