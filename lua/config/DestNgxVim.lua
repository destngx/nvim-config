----------------------------------------------
--    This is a main configuration file for   --
--          EcoVim modified by DestNgx        --
--      Change variables which you need to    --
------------------------------------------------

local icons = require("utils.icons")

DestNgxVim = {
  colorscheme = "kanagawa",
  ui = {
    float = {
      border = "rounded",
    },
  },
  plugins = {
    completion = {
      select_first_on_enter = true,
      ghost_text = false,
    },
    rooter = {
      -- Removing package.json from list in Monorepo Frontend Project can be helpful
      -- By that your live_grep will work related to whole project, not specific package
      patterns = { ".git", "darcs", ".bzr", ".svn", "Makefile", ".eslintrc.js", "package.json" }, -- Default
    },
    -- <leader>z
    zen = {
      alacritty_enabled = false,
      kitty_enabled = true,
      wezterm_enabled = true,
      enabled = false, -- sync after change
    },
    ai = {
      codeium = { enabled = os.getenv "COPILOT" == nil },
      parrot = { enabled = false },
      copilot = { enabled = os.getenv "COPILOT" ~= nil and os.getenv('COPILOT') },
      chatgpt = { enabled = true }
    },
    experimental_noice = {
      enabled = true,
    },
    experimental_cursor = {
      enabled = false,
    },
    -- Enables moving by subwords and skips significant punctuation with w, e, b motions
    jump_by_subwords = {
      enabled = true,
    },
    notification = {
      engine = "fidget" -- fidget or snacks
    },
  },
  icons = icons,
  -- Status line configuration
  statusline = {
    path_enabled = true,
    path_type = "relative", -- absolute/relative
  },
  lsp = {
    virtual_text = false, -- show virtual text (errors, warnings, info) inline messages, set fallse to use tiny-inline-diagnostic
  },
  snacks = {
    image = true,
  }
}
