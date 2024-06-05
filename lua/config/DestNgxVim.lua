----------------------------------------------
--    This is a main configuration file for   --
--          EcoVim modified by DestNgx        --
--      Change variables which you need to    --
------------------------------------------------

local icons = require("utils.icons")

DestNgxVim = {
  colorscheme = "kanagawa-wave",
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
      patterns = { ".git", "darcs", ".bzr", ".svn", "Makefile", ".eslintrc.js" }, -- Default
    },
    -- <leader>z
    zen = {
      alacritty_enabled = false,
      kitty_enabled = true,
      wezterm_enabled = true,
      enabled = true, -- sync after change
    },
    ai = {
      codeium = { enable = true },
      parrot = { enable = false },
      copilot = { enable = os.getenv "COPILOT" ~= nil and os.getenv('COPILOT') },
      chatgpt = { enable = true }
    },
    experimental_noice = {
      enabled = true,
    },
    -- Enables moving by subwords and skips significant punctuation with w, e, b motions
    jump_by_subwords = {
      enabled = true,
    },
  },
  -- Please keep it
  icons = icons,
  -- Status line configuration
  statusline = {
    path_enabled = true,
    path_type = "relative", -- absolute/relative
  },
  lsp = {
    virtual_text = true, -- show virtual text (errors, warnings, info) inline messages
  },
}
