return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      preset = {
        header = [[
████████▄     ▄████████    ▄████████     ███     ███▄▄▄▄      ▄██████▄  ▀████    ▐████▀
███   ▀███   ███    ███   ███    ███ ▀█████████▄ ███▀▀▀██▄   ███    ███   ███▌   ████▀
███    ███   ███    █▀    ███    █▀     ▀███▀▀██ ███   ███   ███    █▀     ███  ▐███
███    ███  ▄███▄▄▄       ███            ███   ▀ ███   ███  ▄███           ▀███▄███▀
███    ███ ▀▀███▀▀▀     ▀███████████     ███     ███   ███ ▀▀███ ████▄     ████▀██▄
███    ███   ███    █▄           ███     ███     ███   ███   ███    ███   ▐███  ▀███
███   ▄███   ███    ███    ▄█    ███     ███     ███   ███   ███    ███  ▄███     ███▄
████████▀    ██████████  ▄████████▀     ▄████▀    ▀█   █▀    ████████▀  ████       ███▄
        ]]
      },
      sections = {
        { section = "header" },
        {
          section = "terminal",
          cmd = "pokemon-colorscripts -r --no-title; sleep .1",
          random = 10,
          pane = 2,
          indent = 4,
          height = 20,
        },
        { icon = DestNgxVim.icons.history,    title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = DestNgxVim.icons.folderOpen, title = "Projects",     section = "projects",     indent = 2, padding = 1 },
        {
          icon = DestNgxVim.icons.git,
          title = "Git Status",
          section = "terminal",
          enabled = function()
            local Snacks = require("snacks")
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
        { pane = 2,           section = "keys", gap = 1, padding = 1 },
      },
    },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { relative = "cursor", },
    image = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    lazygit = {},
    scope = { enabled = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    words = { enabled = false }, -- highlight words under cursor, already have a manual function
  },
}
