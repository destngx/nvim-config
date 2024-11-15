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
  return tostring(vim.fn.wordcount().words)
end
local function get_location()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return string.format('%d:%d|%d:%d', line, vim.fn.line('$'), col, string.len(vim.fn.getline('.')))
end
local theme = require("kanagawa.colors").setup().theme

local kanagawa = {}

kanagawa.normal = {
  a = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },
  b = { bg = "none", fg = theme.syn.fun },
  c = { bg = "none", fg = theme.ui.fg },
  x = { bg = theme.ui.bg_visual, fg = theme.ui.fg },
  y = { bg = theme.ui.bg_search, fg = theme.ui.fg },
}

kanagawa.insert = {
  a = { bg = theme.diag.ok, fg = theme.ui.bg },
  b = { bg = theme.ui.bg, fg = theme.diag.ok },
  x = { bg = theme.ui.bg_visual, fg = theme.ui.fg },
  y = { bg = theme.ui.bg_search},
}

kanagawa.command = {
  a = { bg = theme.syn.operator, fg = theme.ui.bg },
  b = { bg = theme.ui.bg, fg = theme.syn.operator },
}

kanagawa.visual = {
  a = { bg = theme.syn.keyword, fg = theme.ui.bg },
  b = { bg = theme.ui.bg, fg = theme.syn.keyword },
}

kanagawa.replace = {
  a = { bg = theme.syn.constant, fg = theme.ui.bg },
  b = { bg = theme.ui.bg, fg = theme.syn.constant },
}

kanagawa.inactive = {
  a = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
  b = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim, gui = "bold" },
  c = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
}

if vim.g.kanagawa_lualine_bold then
  for _, mode in pairs(kanagawa) do
    mode.a.gui = "bold"
  end
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = kanagawa,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
      "NvimTree",
      "Trouble",
      "leetcode.nvim",
      "qf",
      "alpha",
      "dashboard",
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = { statusline = 100 }
  },
  sections = {
    lualine_a = {},
    lualine_b = { { 'filetype', padding = {}, icon_only = true }, { 'filename', padding = { left = 0, right = 1 } }, },
    lualine_c = {
      {
        symbols.get,
        cond = symbols.has,
        padding = 0,
      }
    },
    lualine_x = {
      -- {
      --   require("noice").api.status.command.get,
      --   cond = require("noice").api.status.command.has,
      --   color = { fg = "#ff9e64" },
      -- },
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
        show_loading = true,
      },
      {
        function()
          return require("dap.lua").status()
        end,
        icon = { DestNgxVim.icons.bug, color = { fg = "#e7c664" } }, -- nerd icon.
        cond = function()
          if not package.loaded.dap then
            return false
          end
          local session = require("dap.lua").session()
          return session ~= nil
        end,
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
          error = DestNgxVim.icons.errorOutline,
          warn = DestNgxVim.icons.warningTriangle,
          info = DestNgxVim.icons.infoOutline,
          hint = DestNgxVim.icons.lightbulbOutline
        }
        , padding = { left = 0, right = 1 }
      }
    },
    lualine_y = { { get_location }, { wordCount, padding = { left = 0, right = 1 } } },
    lualine_z = { 'mode' }
  },
}
