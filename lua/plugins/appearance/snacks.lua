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
        { section = "keys",  gap = 1, padding = 1 },
        {
          pane = 2,
          section = "terminal",
          cmd = " date '+%A, %B %d, %Y'",
          height = 8,
          padding = 1,
        },
        { pane = 2, icon = DestNgxVim.icons.history,    title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = DestNgxVim.icons.folderOpen, title = "Projects",     section = "projects",     indent = 2, padding = 1 },
        {
          pane = 2,
          icon = DestNgxVim.icons.git,
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { relative = "cursor", },
    image = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    lazygit = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
}
