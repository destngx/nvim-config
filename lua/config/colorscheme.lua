local present, kanagawa = pcall(require, "kanagawa")
if not present then
  vim.cmd([[colorscheme slate]])
end

-- local default_colors = require("kanagawa.colors").palette
-- ╭──────────────────────────────────────────────────────────╮
-- │ Setup Colorscheme                                        │
-- ╰──────────────────────────────────────────────────────────╯

kanagawa.setup({
  commentStyle = { italic = true, bold = false },
  dimInactive = true,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none"
        }
      }
    }
  },
  overrides = function(colors)
    local theme = colors.theme
    return {
      Boolean = { bold = false },
      -- Completion Menu colors
      BlinkCmpMenuBorder = { link = "Pmenu" },
      BlinkCmpLabelMatch = { bold = true, fg = "NONE" },
      Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_dim, blend = vim.o.pumblend }, -- add `blend = vim.o.pumblend` to enable transparency
      PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.bg_p2 },
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      FloatTitle = { bg = "none" },
      LineNr = { link = "Comment" },
      VertSplit = { bg = theme.ui.bg_m1 },

      -- Save an hlgroup with dark background and dimmed foreground
      -- so that you can use it where your still want darker windows.
      -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
      Normal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
      NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
      WinSeparator = { fg = theme.ui.nontext }, -- brighter
      -- Popular plugins that open floats will link to NormalFloat by default;
      -- set their background accordingly if you wish to keep them dark and borderless
      LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
      StatusLine = { bg = "none" },
      StatusLineNC = { bg = "none" },
      lualine_c_normal = { bg = "none" },
      MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
      Visual = { bg = "#3a3a3a", fg = colors.palette.bg, }
    }
  end,
})
