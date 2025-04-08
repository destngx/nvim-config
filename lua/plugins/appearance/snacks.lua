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
    image = { enabled = DestNgxVim.snacks.image },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    lazygit = {},
    scope = { enabled = false },
    -- scroll = {
    --   filter = function(buf)
    --     local buftype_pattern = { "help", "lazy", "Oil", "neo-tree", "dashboard", "packer", "startify", "fzf", "fugitive",
    --       "spectre_panel", "CodeCompanion" }
    --     local filetype_pattern = { "nofile" }
    --     local buftype = vim.bo[buf].buftype
    --     local filetype = vim.bo[buf].filetype
    --
    --     -- Check if buftype or filetype is in the exclude pattern
    --     for _, p in ipairs(buftype_pattern) do
    --       if buftype == p then
    --         return false
    --       end
    --     end
    --     for _, p in ipairs(filetype_pattern) do
    --       if filetype == p then
    --         return false
    --       end
    --     end
    --     return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and buftype ~= "terminal"
    --   end,
    -- },
    scroll = {enabled = true},
    statuscolumn = { enabled = false },
    words = { enabled = false }, -- highlight words under cursor, already have a manual function
  },
}
