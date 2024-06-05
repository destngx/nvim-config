local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}
local trouble = require("trouble")
local symbols = trouble.statusline({
  mode = "lsp_document_symbols",
  groups = {},
  title = false,
  filter = { range = true },
  format = "{kind_icon}{symbol.name:NormalFloat}",
  hl_group = "lualine_c_normal"
})

local function wordCount()
  return tostring(vim.fn.wordcount().words) .. DestNgxVim.icons.text
end
local function get_location()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return string.format('%d:%d|%d:%d', line, vim.fn.line('$'), col, string.len(vim.fn.getline('.')))
end
require('lualine').setup {
  options = {
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
      "NvimTree",
      "Trouble",
      "leetcode.nvim",
      "qf",
      "alpha"
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = { statusline = 100 }
  },
  sections = {
    lualine_a = {},
    lualine_b = { { 'filetype', padding = {}, icon_only = true }, { 'filename', padding = 0 },},
    lualine_c = {
      {
        symbols.get,
        cond = symbols.has,
        padding = 0,
      }
    },
    lualine_x = {
      {
        require("noice").api.status.command.get,
        cond = require("noice").api.status.command.has,
        color = { fg = "#ff9e64" },
      },
      {
        'copilot',
        padding = 0,
        symbols = {
          status = {
            icons = {
              enabled = DestNgxVim.icons.copilotEnabled,
              sleep = DestNgxVim.icons.copilotSleep,
              disabled = DestNgxVim.icons.copilotDisabled,
              warning = DestNgxVim.icons.copilotWarning,
              unknown = DestNgxVim.icons.copilotUnknown
            },
          },
        },
        show_colors = true,
      },
      { 'branch', icon = DestNgxVim.icons.git },
      {
        'diff',
        symbols = {
          added = DestNgxVim.icons.gitAdd,
          modified = DestNgxVim.icons.gitChange,
          removed = DestNgxVim.icons.gitRemove
        },
        cond = conditions.hide_in_width,
      },
      {
        'diagnostics',
        sources = { "nvim_diagnostic" },
        symbols = {
          error = DestNgxVim.icons.bug,
          warn = DestNgxVim.icons.warningTriangle,
          info = DestNgxVim.icons.infoOutline,
          hint = DestNgxVim.icons.lightbulbOutline
        }
      }
    },
    lualine_y = { { get_location }, { wordCount, padding = 0 } },
    lualine_z = { 'mode' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
