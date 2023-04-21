------------------------------------------------
--                                            --
--    This is a main configuration file for    --
--                    EcoVim                  --
--      Change variables which you need to    --
--                                            --
------------------------------------------------

local icons = require("utils.icons")

EcoVim = {
  colorscheme = "tokyonight",
  ui = {
    float = {
      border = "rounded",
    },
  },
  plugins = {
    completion = {
      select_first_on_enter = true,
    },
    rooter = {
      -- Removing package.json from list in Monorepo Frontend Project can be helpful
      -- By that your live_grep will work related to whole project, not specific package
      patterns = { ".git", "package.json", "_darcs", ".bzr", ".svn", "Makefile" }, -- Default
    },
    zen = {
      kitty_enabled = true,
      enabled = true, -- sync after change
    },
    ai = {
      codeium = { enable = true },
      tabnine = { enable = false },
    },
    experimental_noice = {
      enabled = true,
    },
  },
  icons = icons,
  statusline = {
    path_enabled = true,
    path = "relative", -- absolute/relative
  },
  lsp = {
    virtual_text = true, -- show virtual text (errors, warnings, info) inline messages
  },
}
