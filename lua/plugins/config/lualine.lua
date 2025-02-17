local icons = DestNgxVim.icons
-- Utility functions
-- Code companion util

-- diff conditions util
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
  is_not_code_companion_buffer = function()
    local ft = vim.bo.filetype
    return ft ~= 'codecompanion'
  end,
  is_code_companion_buffer = function()
    local ft = vim.bo.filetype
    return ft == 'codecompanion'
  end,
  is_markdown_file = function() return vim.bo.filetype == 'markdown' end,
  is_obsidian_vault = function()
    return string.find(vim.loop.cwd(), "obsidian%-vaults")
  end,
  is_dap_active = function()
    return package.loaded.dap and require("dap.lua").session() ~= nil
  end,
}

-- theme
local theme = require("kanagawa.colors").setup().theme
local kanagawa = {}
kanagawa.normal = {
  a = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },
  b = { bg = "none", fg = theme.syn.fun },
  c = { bg = "none", fg = theme.ui.fg },
  x = conditions.is_obsidian_vault() and { bg = "none" } or { bg = theme.ui.bg_visual, fg = theme.ui.fg },
  y = conditions.is_obsidian_vault() and { bg = "none", fg = theme.syn.keyword } or
      { bg = theme.ui.bg_search, fg = theme.syn.fg },
}
kanagawa.insert = {
  a = { bg = theme.diag.ok, fg = theme.ui.bg },
  b = { bg = theme.ui.bg, fg = theme.diag.ok },
  x = conditions.is_obsidian_vault() and { bg = "none" } or { bg = theme.ui.bg_visual, fg = theme.ui.fg },
  y = conditions.is_obsidian_vault() and { bg = "none", fg = theme.syn.keyword } or
      { bg = theme.ui.bg_search, fg = theme.syn.fg },
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

-- Custom components
-- trouble component
local trouble = require("trouble")
local symbols = trouble.statusline({
  mode = "lsp_document_symbols",
  groups = {},
  title = false,
  filter = { range = true },
  format = "{kind_icon}{symbol.name:NormalFloat}",
  hl_group = "lualine_c_normal"
})

-- wordcount component
local function word_count()
  if conditions.is_obsidian_vault() and conditions.is_makrdown_file() then
    return "and " .. tostring(vim.fn.wordcount().words) .. " words"
  end
  return tostring(vim.fn.wordcount().words)
end
local function get_location()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return conditions.is_obsidian_vault() and
      string.format('char %d of %d at line %d of %d total lines', col + 1, string.len(vim.fn.getline('.')), line,
        vim.fn.line('$'))
      or string.format('%d:%d|%d:%d', line, vim.fn.line('$'), col + 1, string.len(vim.fn.getline('.')))
end

-- ai components
local copilot_component = {
  'copilot',
  padding = 0,
  symbols = {
    status = {
      icons = {
        enabled = icons.copilotEnabled,
        sleep = icons.copilotSleep,
        disabled = icons.copilotDisabled,
        warning = icons.copilotWarning,
        unknown = icons.copilotUnknown
      },
    },
  },
  show_colors = true,
  show_loading = true,
  cond = conditions.is_not_code_companion_buffer
}
-- for chat panel
local lualine_codecompanion_component = require("plugins.config.lualine-codecompanion")

local ai_components = {
  { lualine_codecompanion_component, cond = conditions.is_code_companion_buffer(), show_colors = true },
  copilot_component,
}

-- dap component
local dap_status = function()
  if not package.loaded.dap then return false end
  return require("dap.lua").session() ~= nil
end

local dap_component = {
  function() return require("dap.lua").status() end,
  icon = { icons.bug, color = { fg = "#e7c664" } },
  cond = dap_status
}

-- diff component
local diff_component = {
  'diff',
  symbols = {
    added = icons.gitAdd,
    modified = icons.gitChange,
    removed = icons.gitRemove
  },
  cond = conditions.hide_in_width
}

-- diagnostics component
local diagnostic_component = {
  'diagnostics',
  sources = { "nvim_diagnostic" },
  symbols = {
    error = icons.errorOutline,
    warn = icons.warningTriangle,
    info = icons.infoOutline,
    hint = icons.lightbulbOutline
  },
  padding = { left = 0, right = 1 }
}
-- Config

local sections = {
  lualine_a = {},
  lualine_b = {
    { 'filetype', padding = {},                     icon_only = true },
    { 'filename', padding = { left = 0, right = 1 } },
  },
  lualine_c = {
    { symbols.get, cond = symbols.has, padding = 0 }
  },
  lualine_x = {
    { lualine_codecompanion_component, cond = conditions.is_code_companion_buffer, show_colors = true },
    copilot_component,
    unpack(conditions.is_obsidian_vault() and {} or {
      dap_component,
      { 'branch', icon = icons.git },
      diff_component,
      diagnostic_component,
    })
  },
  lualine_y = { { get_location }, { word_count, padding = { left = 0, right = 1 } } },
  lualine_z = conditions.is_obsidian_vault() and {} or { 'mode' }
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = kanagawa,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
      "neo-tree",
      "Trouble",
      "leetcode.nvim",
      "qf",
      "alpha",
      "dashboard",
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = { statusline = 200 }
  },
  sections = sections
}
