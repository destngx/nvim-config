return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    lazy = false,
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    version = "*",
    lazy = false,
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    servers = nil,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- { "nvim-tree/nvim-tree.lua" },
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach", -- Or `VeryLazy`
    priority = 1000,     -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup({
        preset = 'simple',
        options = {
          multilines = true,
          use_icons_from_diagnostic = true,
          multiple_diag_under_cursor = true,
          show_all_diags_on_cursorline = true,
        },
      })
    end
  }
}
