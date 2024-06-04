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
  format = "{kind_icon}{symbol.name:Normal}",
  -- The following line is needed to fix the background color
  -- Set it to the lualine section you want to use
  hl_group = "lualine_c_normal",
})
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
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
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filetype', padding = 0, icon_only = true }, { 'filename', padding = 0 }, { symbols.get, cond = symbols.has } },
    lualine_x = {
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
    lualine_y = { 'progress', 'location' },
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
