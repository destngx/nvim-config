-- Detects nvim-treesitter parsers that are out of sync with their bundled queries.
-- A stale parser makes query compilation fail ("Invalid node type ...") whenever the
-- language is used, including via injections (e.g. `$math$` in markdown -> latex).
local M = {}

local QUERY_NAMES = { "highlights", "injections", "folds", "indents", "locals" }

---@return table<string, { revision: string }>
local function _load_lockfile()
  local utils = require("nvim-treesitter.utils")
  local path = utils.join_path(utils.get_package_path(), "lockfile.json")
  local ok, lockfile = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  return ok and lockfile or {}
end

---@return table<string, string> installed revision by lang
local function _installed_revisions()
  local info_dir = require("nvim-treesitter.configs").get_parser_info_dir()
  local revisions = {}
  if not info_dir then
    return revisions
  end
  for name, kind in vim.fs.dir(info_dir) do
    local lang = name:match("^(.+)%.revision$")
    if lang and kind == "file" then
      local file = io.open(info_dir .. "/" .. name, "r")
      if file then
        revisions[lang] = vim.trim(file:read("*a") or "")
        file:close()
      end
    end
  end
  return revisions
end

--- Compares installed parser revisions with the revisions the queries expect.
---@return { outdated: string[], needs_cli: string[] }
function M.find_outdated()
  local configs = require("nvim-treesitter.parsers").get_parser_configs()
  local ignored = require("nvim-treesitter.configs").get_ignored_parser_installs()
  local lockfile = _load_lockfile()
  local has_cli = vim.fn.executable("tree-sitter") == 1
  local result = { outdated = {}, needs_cli = {} }

  for lang, installed in pairs(_installed_revisions()) do
    local install_info = configs[lang] and configs[lang].install_info or {}
    local expected = install_info.revision or (lockfile[lang] and lockfile[lang].revision)
    if expected and expected ~= installed and not vim.tbl_contains(ignored, lang) then
      if install_info.requires_generate_from_grammar and not has_cli then
        table.insert(result.needs_cli, lang)
      else
        table.insert(result.outdated, lang)
      end
    end
  end

  table.sort(result.outdated)
  table.sort(result.needs_cli)
  return result
end

--- Compiles every query of each installed parser; slow, so only run on demand.
---@return string[] errors
function M.find_broken_queries()
  local errors = {}
  for lang in pairs(_installed_revisions()) do
    for _, query_name in ipairs(QUERY_NAMES) do
      local ok, err = pcall(vim.treesitter.query.get, lang, query_name)
      if not ok then
        table.insert(errors, string.format("%s/%s: %s", lang, query_name, tostring(err):match("[^\n]*")))
      end
    end
  end
  table.sort(errors)
  return errors
end

---@param result { outdated: string[], needs_cli: string[] }
---@return string[] lines
local function _format_outdated(result)
  local lines = {}
  if #result.outdated > 0 then
    table.insert(lines, "Outdated parsers (run :TSUpdate): " .. table.concat(result.outdated, ", "))
  end
  if #result.needs_cli > 0 then
    table.insert(lines, "Outdated parsers that need the `tree-sitter` CLI to rebuild: "
      .. table.concat(result.needs_cli, ", "))
    table.insert(lines, "Install the CLI and run :TSUpdate, or remove them with :TSUninstall "
      .. table.concat(result.needs_cli, " ") .. " (injections are then skipped instead of erroring)")
  end
  return lines
end

--- Warns once if parsers are out of sync with their queries; cheap enough for startup.
function M.warn_if_outdated()
  local ok, result = pcall(M.find_outdated)
  if not ok then
    return
  end
  local lines = _format_outdated(result)
  if #lines > 0 then
    vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN, { title = "nvim-treesitter" })
  end
end

--- Full report: revision drift plus actual query compilation errors.
function M.report()
  vim.api.nvim_echo({ { "Checking treesitter parsers and queries..." } }, false, {})
  vim.cmd.redraw()
  local lines = _format_outdated(M.find_outdated())
  local errors = M.find_broken_queries()
  if #errors > 0 then
    table.insert(lines, "Queries failing to compile:")
    vim.list_extend(lines, errors)
  end
  if #lines == 0 then
    vim.notify("All treesitter parsers match their queries", vim.log.levels.INFO, { title = "nvim-treesitter" })
  else
    vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN, { title = "nvim-treesitter" })
  end
end

return M
