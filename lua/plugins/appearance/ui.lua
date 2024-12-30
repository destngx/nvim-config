local function no_nect_pain_calculate_with()
  local width = vim.api.nvim_win_get_width(0)
  local min_width = math.max(width * 0.50, 85)
  return math.min(width, min_width)
end
local oil_git_ignored = setmetatable({}, {
  __index = function(self, key)
    local proc = vim.system({ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" }, {
      cwd = key,
      text = true,
    })
    local result = proc:wait()
    local ret = {}
    if result.code == 0 then
      for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
        -- Remove trailing slash
        line = line:gsub("/$", "")
        table.insert(ret, line)
      end
    end

    rawset(self, key, ret)
    return ret
  end,
})
local function oil_max_height()
  local height = vim.fn.winheight(0)
  if height >= 40 then
    return 30
  elseif height >= 30 then
    return 20
  else
    return 10
  end
end

return {
  {
    "folke/noice.nvim",
    enabled = DestNgxVim.plugins.experimental_noice.enabled,
    event = "VeryLazy",
    opts = {
      messages = { enabled = true },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = {
          enabled = true,
        },
        hover = {
          enabled = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = false, -- long messages will be sent to a split
        inc_rename = true,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
      views = {
        cmdline_popup = {
          position = {
            row = 12,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
          border = {
            padding = { 1, 2 },
          },
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 16,
            col = "100%",
          },
          size = {
            width = 120,
            height = "auto",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { "Normal:Normal,FloatBorder:DiagnosticInfo" },
          },
        },
      },
    }
  },
  {
    "j-hui/fidget.nvim",
    lazy = false,
    config = function()
      require("plugins.config.notify")
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    config = function()
      require("plugins.config.lualine")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("plugins.config.tree")
    end,
  },
  {
    "refractalize/oil-git-status.nvim",
    event = "VimEnter",
    config = true,
    dependencies = {
      {
        'stevearc/oil.nvim',
        event = "VimEnter",
        opts = {
          experimental_watch_for_changes = false,

          view_options = {
            -- Show files and directories that start with "."
            show_hidden = false,
            -- This function defines what is considered a "hidden" file
            is_hidden_file = function(name, _)
              -- dotfiles are always considered hidden
              if vim.startswith(name, ".") then
                return true
              end
              local dir = require("oil").get_current_dir()
              -- if no local directory (e.g. for ssh connections), always show
              if not dir then
                return false
              end
              -- Check if file is gitignored
              return vim.list_contains(oil_git_ignored[dir], name)
            end,
            natural_order = false,
          },
          win_options = {
            signcolumn = "yes:2",
          },
          float = {
            max_width = 120,
            max_height = oil_max_height(),
          },
          keymaps = {
            ["<C-s>"] = {
              desc = "Save all changes",
              callback = function()
                require("oil").save({ confirm = false })
              end,
            },
            ["<leader>p"] = function()
              local oil = require("oil")
              local filename = oil.get_cursor_entry().name
              local dir = oil.get_current_dir()
              oil.close()

              local img_clip = require("img-clip")
              img_clip.paste_image({}, dir .. filename)
            end,
            ["A-h"] = { "actions.toggle_hidden", mode = "n" },
          },
        }
      },
    },
  },
  {
    "Mohammed-Taher/AdvancedNewFile.nvim",
    event = "BufReadPre",
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
      default_mapping = true,
    }
  },
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    config = function()
      require("plugins.config.zen")
    end,
    enabled = DestNgxVim.plugins.zen.enabled,
    keys = {
      {
        "<leader>z",
        "<cmd>ZenMode<cr>",
        desc = "Toggle Zen Mode",
      }
    }
  },
  {
    "folke/twilight.nvim",
    config = true,
    enabled = DestNgxVim.plugins.zen.enabled,
  },
  {
    "shortcuts/no-neck-pain.nvim",
    opts = {
      width = no_nect_pain_calculate_with(),
    },
    enabled = not DestNgxVim.plugins.zen.enabled,
    keys = {
      -- add <leader>cz to enter zen mode
      {
        "<leader>z",
        "<cmd>NoNeckPain<cr>",
        desc = "Distraction Free Mode",
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- labels = "abcdefghijklmnopqrstuvwxyz",
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = {
        -- search/jump in all windows
        multi_window = true,
        -- search direction
        forward = true,
        -- when `false`, find only matches in the given direction
        wrap = true,
        ----@type Flash.Pattern.Mode
        -- Each mode will take ignorecase and smartcase into account.
        -- * exact: exact match
        -- * search: regular search
        -- * fuzzy: fuzzy search
        -- * fun(str): custom function that returns a pattern
        --   For example, to only match at the beginning of a word:
        --   mode = function(str)
        --     return "\\<" .. str
        --   end,
        mode = "exact",
        -- behave like `incsearch`
        incremental = false,
        -- Excluded filetypes and custom window filters
        ----@type (string|fun(win:window))[]
        exclude = {
          "notify",
          "cmp_menu",
          "noice",
          "flash_prompt",
          function(win)
            -- exclude non-focusable windows
            return not vim.api.nvim_win_get_config(win).focusable
          end,
        },
        -- Optional trigger character that needs to be typed before
        -- a jump label can be used. It's NOT recommended to set this,
        -- unless you know what you're doing
        trigger = "",
        -- max pattern length. If the pattern length is equal to this
        -- labels will no longer be skipped. When it exceeds this length
        -- it will either end in a jump or terminate the search
        max_length = nil, ---@type number?
      },
      jump = {
        -- save location in the jumplist
        jumplist = true,
        -- jump position
        pos = "start", ---@type "start" | "end" | "range"
        -- add pattern to search history
        history = false,
        -- add pattern to search register
        register = false,
        -- clear highlight after jump
        nohlsearch = false,
        -- automatically jump when there is only one match
        autojump = false,
        -- You can force inclusive/exclusive jumps by setting the
        -- `inclusive` option. By default it will be automatically
        -- set based on the mode.
        inclusive = nil, ---@type boolean?
        -- jump position offset. Not used for range jumps.
        -- 0: default
        -- 1: when pos == "end" and pos < current position
        offset = nil, ---@type number
      },
      label = {
        -- allow uppercase labels
        uppercase = true,
        -- add any labels with the correct case here, that you want to exclude
        exclude = "",
        -- add a label for the first match in the current window.
        -- you can always jump to the first match with `<CR>`
        current = true,
        -- show the label after the match
        after = true, ---@type boolean|number[]
        -- show the label before the match
        before = false, ---@type boolean|number[]
        -- position of the label extmark
        style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
        -- flash tries to re-use labels that were already assigned to a position,
        -- when typing more characters. By default only lower-case labels are re-used.
        reuse = "lowercase", ---@type "lowercase" | "all"
        -- for the current window, label targets closer to the cursor first
        distance = true,
        -- minimum pattern length to show labels
        -- Ignored for custom labelers.
        min_pattern_length = 0,
        -- Enable this to use rainbow colors to highlight labels
        -- Can be useful for visualizing Treesitter ranges.
        rainbow = {
          enabled = false,
          -- number between 1 and 9
          shade = 5,
        },
        -- With `format`, you can change how the label is rendered.
        -- Should return a list of `[text, highlight]` tuples.
        ----@class Flash.Format
        ----@field state Flash.State
        ----@field match Flash.Match
        ----@field hl_group string
        ----@field after boolean
        ----@type fun(opts:Flash.Format): string[][]
        format = function(opts)
          return { { opts.match.label, opts.hl_group } }
        end,
      },
      highlight = {
        -- show a backdrop with hl FlashBackdrop
        backdrop = true,
        -- Highlight the search matches
        matches = true,
        -- extmark priority
        priority = 5000,
        groups = {
          match = "FlashMatch",
          current = "FlashCurrent",
          backdrop = "FlashBackdrop",
          label = "FlashLabel",
        },
      },
      -- action to perform when picking a label.
      -- defaults to the jumping logic depending on the mode.
      ----@type fun(match:Flash.Match, state:Flash.State)|nil
      action = nil,
      -- initial pattern to use when opening flash
      pattern = "",
      -- When `true`, flash will try to continue the last search
      continue = false,
      -- Set config to a function to dynamically change the config
      config = nil, ----@type fun(opts:Flash.Config)|nil
      -- You can override the default options for a specific mode.
      -- Use it with `require("flash").jump({mode = "forward"})`
      ----@type table<string, Flash.Config>
      modes = {
        -- options used when flash is activated through
        -- a regular search with `/` or `?`
        search = {
          -- when `true`, flash will be activated during regular search by default.
          -- You can always toggle when searching with `require("flash").toggle()`
          enabled = true,
          highlight = { backdrop = false },
          jump = { history = true, register = true, nohlsearch = true },
          search = {
            -- `forward` will be automatically set to the search direction
            -- `mode` is always set to `search`
            -- `incremental` is set to `true` when `incsearch` is enabled
          },
        },
        -- options used when flash is activated through
        -- `f`, `F`, `t`, `T`, `;` and `,` motions
        char = {
          enabled = true,
          -- dynamic configuration for ftFT motions
          config = function(opts)
            -- autohide flash when in operator-pending mode
            opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"

            -- disable jump labels when enabled and when using a count
            opts.jump_labels = opts.jump_labels and vim.v.count == 0

            -- Show jump labels only in operator-pending mode
            -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
          end,
          -- hide after jump when not using jump labels
          autohide = false,
          -- show jump labels
          jump_labels = false,
          -- set to `false` to use the current line only
          multi_line = true,
          -- When using jump labels, don't use these keys
          -- This allows using those keys directly after the motion
          label = { exclude = "hjkliardc" },
          -- by default all keymaps are enabled, but you can disable some of them,
          -- by removing them from the list.
          -- If you rather use another key, you can map them
          -- to something else, e.g., { [";"] = "L", [","] = H }
          keys = { "f", "F", "t", "T" },
          ---@alias Flash.CharActions table<string, "next" | "prev" | "right" | "left">
          -- The direction for `prev` and `next` is determined by the motion.
          -- `left` and `right` are always left and right.
          char_actions = function(motion)
            return {
              [";"] = "next", -- set to `right` to always go right
              [","] = "prev", -- set to `left` to always go left
              -- clever-f style
              [motion:lower()] = "next",
              [motion:upper()] = "prev",
              -- jump2d style: same case goes next, opposite case goes prev
              -- [motion] = "next",
              -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
            }
          end,
          search = { wrap = false },
          highlight = { backdrop = true },
          jump = { register = false },
        },
        -- options used for treesitter selections
        -- `require("flash").treesitter()`
        treesitter = {
          labels = "abcdefghijklmnopqrstuvwxyz",
          jump = { pos = "range" },
          search = { incremental = false },
          label = { before = true, after = true, style = "inline" },
          highlight = {
            backdrop = false,
            matches = false,
          },
        },
        treesitter_search = {
          jump = { pos = "range" },
          search = { multi_window = true, wrap = true, incremental = false },
          remote_op = { restore = true },
          label = { before = true, after = true, style = "inline" },
        },
        -- options used for remote flash
        remote = {
          remote_op = { restore = true, motion = true },
        },
      },
      -- options for the floating window that shows the prompt,
      -- for regular jumps
      prompt = {
        enabled = true,
        prefix = { { "⚡", "FlashPromptIcon" } },
        win_config = {
          relative = "editor",
          width = 1, -- when <=1 it's a percentage of the editor width
          height = 1,
          row = -1,  -- when negative it's an offset from the bottom
          col = 0,   -- when negative it's an offset from the right
          zindex = 1000,
        },
      },
      -- options for remote operator pending mode
      remote_op = {
        -- restore window views and cursor position
        -- after doing a remote operation
        restore = false,
        -- For `jump.pos = "range"`, this setting is ignored.
        -- `true`: always enter a new motion when doing a remote operation
        -- `false`: use the window's cursor position and jump target
        -- `nil`: act as `true` for remote windows, `false` for the current window
        motion = false,
      },
    },
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash jump", },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter jump", },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        marks = false,     -- shows a list of your marks on ' and `
        registers = false, -- shows your registers on " in normal or <C-r> in insert mode
      },
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>a", group = "AI" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>l", group = "list" },
          { "<leader>m", group = "markdown" },
          { "<leader>g", group = "git" },
          { "<leader>o", group = "obsidian" },
          { "<leader>s", group = "search" },
        },
      },
    }
  },
  {
    "folke/todo-comments.nvim",
    event = "BufEnter",
    opts = {
      signs = true,      -- show icons in the signs column
      sign_priority = 8, -- sign priority
      keywords = {
        FIX = {
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        },
        WARN = { alt = { "WARNING" } },
        PERF = { alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      },
      highlight = {
        before = "",                     -- "fg" or "bg" or empty
        keyword = "wide",                -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
        after = "fg",                    -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
        comments_only = true,            -- uses treesitter to match keywords in comments only
        max_line_len = 400,              -- ignore lines longer than this
        exclude = {},                    -- list of file types to exclude highlighting
      },
    },
    keys = {
      { "<leader>st", function() require("todo-comments.fzf").todo() end,                                          desc = "Todo" },
      { "<leader>sT", function() require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    }
  },
}
