return {
  { "David-Kunz/markid", event = "BufReadPre" },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("plugins.config.autopairs")
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = {
        'html',
        'css',
        'javascript',
        'typescript',
        'typescriptreact',
        'javascriptreact',
        'lua',
        'python',
      },
      user_default_options = {
        mode = "background",
        tailwind = true, -- Enable tailwind colors
      }
    }
  },
  {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("plugins.config.comment")
    end,
  },
  {
    "Wansmer/treesj",
    lazy = true,
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
    event = "BufEnter",
    --   dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup(
        {
          default_keymappings_enabled = true,
          prefix = "gu",
          substitude_command_name = nil,
        }
      )
    end,
    keys = { "gu" }
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
    event = "BufEnter",
    ft = {
      "lua",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    opts = {
      keymap = "gp",             -- Plugin doesn't have any keymaps by default
      behavior = "insert_below", -- how operator should behave
      -- "insert_below" will insert the text below the cursor
      --  "yank" will not insert but instead put text into the default '"' register
      formatters = {
        -- you can define your formatters for specific filetypes
        -- by assigning function that takes two strings
        -- one text modified by 'add_to_inside' function
        -- second the variable (thing) you want to print out
        -- see examples in lua/formatters.lua
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
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    config = function()
      require("plugins.config.indent")
    end,
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
  }
}
