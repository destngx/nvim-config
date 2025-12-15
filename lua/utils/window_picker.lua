---@class WindowPicker
local M = {}

---@param buf number
---@return boolean
local function is_empty_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return true
  end

  if vim.bo[buf].buftype ~= "" then
    return false
  end

  if not vim.bo[buf].buflisted then
    return false
  end

  if vim.api.nvim_buf_get_name(buf) ~= "" then
    return false
  end

  if vim.bo[buf].modified then
    return false
  end

  local line_count = vim.api.nvim_buf_line_count(buf)
  if line_count ~= 1 then
    return false
  end

  local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
  return first_line == ""
end

--- Filetypes that should not receive files
local EXCLUDED_FILETYPES = {
  "neo-tree",
  "neo-tree-popup",
  "no-neck-pain",
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
  local current_is_empty = is_empty_buffer(current_buf)

  -- Count available windows first
  local available_wins = {}
  local available_non_empty_wins = {}

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    local bt = vim.bo[buf].buftype
    local bl = vim.bo[buf].buflisted
    local config = vim.api.nvim_win_get_config(win)

    -- Check if window is suitable
    local is_normal = config.relative == ""
    local is_excluded = vim.tbl_contains(EXCLUDED_FILETYPES, ft)
    local is_special = bt ~= ""
    local is_unlisted = not bl
    local is_current = win == current_win

    -- Include current window only if it's NOT an excluded filetype
    -- (for fzf-lua, neo-tree, oil - exclude current; for normal buffers - include current)
    local should_exclude_current = is_current and vim.tbl_contains(EXCLUDED_FILETYPES, current_ft)

    if is_normal and not is_excluded and not is_special and not is_unlisted and not should_exclude_current then
      table.insert(available_wins, win)

      if not is_empty_buffer(buf) then
        table.insert(available_non_empty_wins, win)
      end
    end
  end

  -- Prefer non-empty panes when available
  local prefer_non_empty = #available_non_empty_wins > 0
  if prefer_non_empty then
    available_wins = available_non_empty_wins
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
      local bt = vim.bo[buf].buftype
      local bl = vim.bo[buf].buflisted

      -- Exclude special/unlisted buffers
      if bt ~= "" then
        return false
      end

      if not bl then
        return false
      end

      if vim.tbl_contains(EXCLUDED_FILETYPES, ft) then
        return false
      end

      -- Exclude current window only if it's an excluded filetype
      if win == current_win and vim.tbl_contains(EXCLUDED_FILETYPES, current_ft) then
        return false
      end

      -- Prefer non-empty panes when any exist. Still allow the current
      -- window if it is empty and it's the only available place.
      if #available_non_empty_wins > 0 then
        local is_empty = is_empty_buffer(buf)
        if is_empty and not (win == current_win and current_is_empty) then
          return false
        end
      end

      return vim.tbl_contains(available_wins, win)
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
