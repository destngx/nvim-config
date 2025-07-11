local common_filetypes = {
  "markdown",
  "lua",
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
  "html",
  "css",
  "python",
}
return {
  { "David-Kunz/markid", ft = common_filetypes, },
  {
    "andymass/vim-matchup",
    event = "BufReadPre",
    setup = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = common_filetypes,
    event = "InsertEnter",
  },
  {
    "windwp/nvim-autopairs",
    ft = common_filetypes,
    config = function()
      require("plugins.config.autopairs")
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    ft = common_filetypes,
    opts = {
      user_default_options = {
        mode = "background",
        tailwind = true, -- Enable tailwind colors
      }
    }
  },
  {
    "numToStr/Comment.nvim",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("plugins.config.comment")
    end,
  },
  {
    "Wansmer/treesj",
    ft = common_filetypes,
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "gJ", "<cmd>TSJToggle<CR>", desc = "Toggle Split/Join" },
    },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
  },
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup(
        {
          default_keymappings_enabled = true,
          prefix = "gT",
          substitude_command_name = nil,
        }
      )
    end,
    keys = {
      { "gT" },
      {
        "gT.",
        function()
          require("plugins.config.text-case").select()
        end,
        { desc = "Modify Text Case" },
        mode = { "n", "x" }
      },
    }
  },
  {
    "echasnovski/mini.align",
    event = "BufEnter",
    version = "*",
    config = function()
      require("mini.align").setup()
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "BufEnter",
    version = "*",
    config = function()
      require("mini.ai").setup()
    end,
  },
  { 'taybart/b64.nvim' },
  {
    "rareitems/printer.nvim",
    ft = common_filetypes,
    opts = {
      keymap = "gp",             -- Plugin doesn't have any keymaps by default
      behavior = "insert_below", -- how operator should behave
      -- "insert_below" will insert the text below the cursor
      --  "yank" will not insert but instead put text into the default '"' register
      formatters = {
        lua = function(inside, variable)
          return string.format('print("%s: " .. %s)', inside, variable)
        end,
        typescriptreact = function(inside, variable)
          return string.format("console.log('%s: ', %s)", inside, variable)
        end,
      },
      -- function which modifies the text inside string in the print statement, by default it adds the path and line number
      add_to_inside = function(text)
        return string.format("[%s:%s] %s", vim.fn.expand("%"), vim.fn.line("."), text)
      end,
    }
  },
  {
    "shellRaining/hlchunk.nvim", -- indent-blankline.nvim alternative
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          chars = { right_arrow = "─" },
          style = "#75A1FF",
          duration = 50,
          delay = 10,
        },
        indent = { enable = true },
        line_num = { enable = true },
        exclude_filetypes = { "help", "git", "markdown", "snippets", "text", "gitconfig", "alpha", "dashboard" },
      })
    end
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
}
