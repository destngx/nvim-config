--- Set window-local options.
---@param win number
---@param wo vim.wo|{}|{winhighlight: string|table<string, string>}
local function set_window_local_options(win, wo)
  for k, v in pairs(wo or {}) do
    if k == "winhighlight" and type(v) == "table" then
      local parts = {} ---@type string[]
      for kk, vv in pairs(v) do
        if vv ~= "" then
          parts[#parts + 1] = ("%s:%s"):format(kk, vv)
        end
      end
      v = table.concat(parts, ",")
    end
    vim.api.nvim_set_option_value(k, v, { scope = "local", win = win })
  end
end
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = {
      notify = true,             -- show notification when big file detected
      size = 0.08 * 1024 * 1024, -- 0.05MB, at this point, most LSP server performance will be affected
      line_length = 8000,        -- average line length (useful for minified files)
      -- Enable or disable features when big file detected
      ---@param ctx {buf: number, ft:string}
      setup = function(ctx)
        -- Disable plugins that slow down big files
        vim.schedule(function()
          if vim.fn.exists(":NoMatchParen") ~= 0 then
            vim.cmd([[NoMatchParen]])
          end
          if vim.fn.exists(":SmearCursorToggle") ~= 0 then
            vim.cmd("SmearCursorToggle")
          end
          if vim.fn.exists(":ReactiveStop") ~= 0 then
            vim.cmd("ReactiveStop")
          end
        end)

        -- Disable scroll animations
        vim.g.snacks_scroll = false
        vim.b.snacks_scroll = false

        -- Set buffer-local options
        vim.bo[ctx.buf].syntax = ctx.ft
        vim.bo[ctx.buf].swapfile = false
        vim.bo[ctx.buf].undofile = false

        -- Set window-local options safely
        vim.schedule(function()
          local win = vim.fn.bufwinid(ctx.buf)
          if win ~= -1 then
            pcall(set_window_local_options, win, { 
              foldmethod = "manual", 
              statuscolumn = "", 
              conceallevel = 0 
            })
          end
        end)
      end,
    },
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
        (function()
          -- Check if pokemon-colorscripts is installed
          if vim.fn.executable("pokemon-colorscripts") == 1 then
            return {
              section = "terminal",
              cmd = "pokemon-colorscripts -r --no-title; sleep .1",
              random = 10,
              pane = 2,
              indent = 4,
              height = 20,
            }
          else
            -- Show notification about missing pokemon-colorscripts
            vim.schedule(function()
              vim.notify(
                "pokemon-colorscripts not installed\nInstall: brew install pokemon-colorscripts",
                vim.log.levels.WARN,
                { title = "Dashboard" }
              )
            end)
            -- Return placeholder section
            return {
              pane = 2,
              section = "terminal",
              cmd = [[echo "
   ╭─────────────────────────────────────╮
   │                                     │
   │   🎨 Pokemon ASCII Art Missing      │
   │                                     │
   │   Install pokemon-colorscripts:     │
   │   brew install pokemon-colorscripts │
   │                                     │
   ╰─────────────────────────────────────╯
"]],
              indent = 4,
              height = 10,
            }
          end
        end)(),
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
    image = {
      enabled = DestNgxVim.snacks.image,
      doc = {
        inline = false,
        float = false,
      },
    },
    picker = { enabled = true },
    notifier = { enabled = DestNgxVim.plugins.notification.engine == "snacks" },
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
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    words = { enabled = false }, -- highlight words under cursor, already have a manual function
  },
}
