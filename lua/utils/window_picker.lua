---@class WindowPicker
local M = {}

--- Filetypes that should not receive files
local EXCLUDED_FILETYPES = {
  "neo-tree",
  "neo-tree-popup",
  "oil",
  "notify",
  "snacks_notif",
  "snacks_picker",
  "terminal",
  "qf",
  "quickfix",
  "trouble",
  "fzf",
}

--- Pick a window using Snacks picker
--- Returns: window ID, false (no windows available), or nil (user cancelled)
---@return number|false|nil
function M.pick_window()
  local ok, snacks = pcall(require, "snacks")
  if not ok then
    vim.notify("Snacks.nvim not available", vim.log.levels.ERROR)
    return false
  end

  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  local current_ft = vim.bo[current_buf].filetype

  -- Count available windows first
  local available_wins = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    local config = vim.api.nvim_win_get_config(win)

    -- Check if window is suitable
    local is_normal = config.relative == ""
    local is_excluded = vim.tbl_contains(EXCLUDED_FILETYPES, ft)
    local is_current = win == current_win

    -- Include current window only if it's NOT an excluded filetype
    -- (for fzf-lua, neo-tree, oil - exclude current; for normal buffers - include current)
    local should_exclude_current = is_current and vim.tbl_contains(EXCLUDED_FILETYPES, current_ft)

    if is_normal and not is_excluded and not should_exclude_current then
      table.insert(available_wins, win)
    end
  end

  -- No suitable windows available
  if #available_wins == 0 then
    return false
  end

  -- Only one window, auto-select it
  if #available_wins == 1 then
    return available_wins[1]
  end

  -- Multiple windows, show picker
  local picked_win = snacks.picker.util.pick_win({
    filter = function(win, buf)
      local ft = vim.bo[buf].filetype

      -- Exclude special filetypes
      if vim.tbl_contains(EXCLUDED_FILETYPES, ft) then
        return false
      end

      -- Exclude current window only if it's an excluded filetype
      if win == current_win and vim.tbl_contains(EXCLUDED_FILETYPES, current_ft) then
        return false
      end

      return true
    end,
  })

  return picked_win -- Returns window ID or nil if cancelled
end

--- Open file with smart window selection and auto-split fallback
---@param filepath string Path to the file
---@param open_cmd? string Command to use (default: 'edit')
---@return boolean success
function M.open_file_smart(filepath, open_cmd)
  open_cmd = open_cmd or "edit"

  local win = M.pick_window()

  if win == nil then
    -- User cancelled, do nothing
    return false
  end

  if win == false then
    -- No suitable windows, create vsplit
    vim.cmd("vsplit")
    vim.cmd(open_cmd .. " " .. vim.fn.fnameescape(filepath))
    return true
  end

  -- Window selected, switch and open
  vim.api.nvim_set_current_win(win)
  vim.cmd(open_cmd .. " " .. vim.fn.fnameescape(filepath))
  return true
end

return M
