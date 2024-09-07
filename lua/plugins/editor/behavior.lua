return {
  { "David-Kunz/markid",     event = "BufReadPre" },
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
    config = function()
      require("plugins.config.nvchad-colorizer")
    end,
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
  }
}
