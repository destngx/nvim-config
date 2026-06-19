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
return
{
  "folke/snacks.nvim",
  priority = 1000,
  dependencies = { "amansingh-afk/milli.nvim" },
  lazy = false,
  opts = function()
    local splash = require("milli").load({ splash = DestNgxVim.snacks.header })
    return {
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
          header = table.concat(splash.frames[1], "\n")
  --         header = [[
  -- ████████▄     ▄████████    ▄████████     ███     ███▄▄▄▄      ▄██████▄  ▀████    ▐████▀
  -- ███   ▀███   ███    ███   ███    ███ ▀█████████▄ ███▀▀▀██▄   ███    ███   ███▌   ████▀
  -- ███    ███   ███    █▀    ███    █▀     ▀███▀▀██ ███   ███   ███    █▀     ███  ▐███
  -- ███    ███  ▄███▄▄▄       ███            ███   ▀ ███   ███  ▄███           ▀███▄███▀
  -- ███    ███ ▀▀███▀▀▀     ▀███████████     ███     ███   ███ ▀▀███ ████▄     ████▀██▄
  -- ███    ███   ███    █▄           ███     ███     ███   ███   ███    ███   ▐███  ▀███
  -- ███   ▄███   ███    ███    ▄█    ███     ███     ███   ███   ███    ███  ▄███     ███▄
  -- ████████▀    ██████████  ▄████████▀     ▄████▀    ▀█   █▀    ████████▀  ████       ███▄
  --         ]]
        },
        sections = {
          { section = "header" },
          -- { section = "footer" },
          { icon = DestNgxVim.icons.history, title = "Recent Files", section = "recent_files", limit = 2, indent = 2, padding = 1 },
          -- { section = "startup" },
          -- { pane = 1,                        section = "keys",       gap = 1,                  padding = 1 },
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

      scroll = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = false }, -- highlight words under cursor, already have a manual function
    }
  end,
  config = function(_, opts)
    require("snacks").setup(opts)
    require("milli").snacks({ splash = DestNgxVim.snacks.header, loop = true })
  end,
}
