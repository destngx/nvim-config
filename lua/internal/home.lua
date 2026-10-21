-- ╭──────────────────────────────────────────────────────────╮
-- │ Home view: Snacks dashboard with neo-tree on the left.   │
-- │ Shown at startup, by <leader>//, and in place of a       │
-- │ buffer whose file was deleted or moved outside Nvim.     │
-- ╰──────────────────────────────────────────────────────────╯
local M = {}

local api = vim.api
local uv = vim.uv

local function is_float(win)
  return api.nvim_win_get_config(win).relative ~= ""
end

local function has_tree_sidebar()
  for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
    if not is_float(win) and vim.bo[api.nvim_win_get_buf(win)].filetype == "neo-tree" then
      return true
    end
  end
  return false
end

--- Show the neo-tree filesystem sidebar without moving focus.
function M.show_tree()
  if has_tree_sidebar() then
    return
  end
  local ok, command = pcall(require, "neo-tree.command")
  if ok then
    command.execute({ action = "show", source = "filesystem", position = "left" })
  end
end

--- Open the dashboard in `win` (default: current window). The
--- `SnacksDashboardOpened` handler in `setup` then shows the tree.
---@param win? integer
function M.open(win)
  win = win or api.nvim_get_current_win()
  if is_float(win) or vim.bo[api.nvim_win_get_buf(win)].filetype == "neo-tree" then
    win = nil
    for _, candidate in ipairs(api.nvim_tabpage_list_wins(0)) do
      if not is_float(candidate) and vim.bo[api.nvim_win_get_buf(candidate)].filetype ~= "neo-tree" then
        win = candidate
        break
      end
    end
  end
  if not win then
    vim.cmd("vertical rightbelow new")
    win = api.nvim_get_current_win()
  end
  Snacks.dashboard.open({ win = win })
end

--- Replace a buffer whose file no longer exists. Windows in the current tab
--- that show it get the home view (the first one) or close (the rest).
--- Windows in other tabs fall back to an empty buffer.
---@param buf integer
local function handle_deleted(buf)
  if not api.nvim_buf_is_valid(buf) then
    return
  end
  local path = api.nvim_buf_get_name(buf)
  -- Atomic saves and branch switches can bring the file back before we run.
  if uv.fs_stat(path) then
    return
  end
  if vim.bo[buf].modified then
    -- Nvim re-checks a missing file on every :checktime, so warn once.
    if vim.b[buf].home_removed_warned then
      return
    end
    vim.b[buf].home_removed_warned = true
    vim.notify(
      ("%s was removed on disk. Unsaved changes are kept, :w writes it back."):format(vim.fn.fnamemodify(path, ":~:.")),
      vim.log.levels.WARN,
      { title = "File removed" }
    )
    return
  end

  local tab = api.nvim_get_current_tabpage()
  local home_win
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    if not home_win and api.nvim_win_get_tabpage(win) == tab and not is_float(win) then
      home_win = win
    elseif not pcall(api.nvim_win_close, win, false) then
      api.nvim_win_set_buf(win, api.nvim_create_buf(true, false))
    end
  end
  if home_win then
    M.open(home_win)
  end
  pcall(api.nvim_buf_delete, buf, {})
end

function M.setup()
  local group = api.nvim_create_augroup("internal_home", { clear = true })

  api.nvim_create_autocmd("User", {
    group = group,
    pattern = "SnacksDashboardOpened",
    desc = "Show neo-tree beside the dashboard",
    callback = function()
      vim.schedule(M.show_tree)
    end,
  })

  -- Defining any FileChangedShell autocmd turns off Nvim's built-in prompts, so
  -- reasons other than "deleted" answer "ask" to keep them. 'autoread' reloads
  -- of unmodified buffers never reach this event.
  api.nvim_create_autocmd("FileChangedShell", {
    group = group,
    desc = "Replace buffers of removed files with the home view",
    callback = function(ev)
      if vim.v.fcs_reason ~= "deleted" or vim.bo[ev.buf].buftype ~= "" then
        vim.v.fcs_choice = "ask"
        return
      end
      vim.v.fcs_choice = ""
      -- Buffers are locked while this event runs.
      vim.schedule(function()
        handle_deleted(ev.buf)
      end)
    end,
  })

  api.nvim_create_autocmd("BufWritePost", {
    group = group,
    desc = "Re-arm the removed-file warning once the file exists again",
    callback = function(ev)
      vim.b[ev.buf].home_removed_warned = nil
    end,
  })

  -- Files deleted or moved from lazygit only get noticed on FocusGained otherwise.
  api.nvim_create_autocmd("TermClose", {
    group = group,
    pattern = "*lazygit*",
    desc = "Check for removed files after lazygit",
    callback = function()
      vim.schedule(function()
        pcall(vim.cmd, "checktime")
      end)
    end,
  })

  vim.keymap.set("n", "<leader>//", M.open, { silent = true, desc = "Dashboard" })
end

return M
