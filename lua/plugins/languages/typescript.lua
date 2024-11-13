return {
  {
    "yioneko/nvim-vtsls",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "typescript", "typescriptreact" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
  },

  {
    "razak17/tailwind-fold.nvim",
    event = "BufRead",
    opts = {
      min_chars = 50,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
  },

  {
    "MaximilianLloyd/tw-values.nvim",
    event = "BufRead",
    keys = {
      { "<Leader>cv", "<CMD>TWValues<CR>", desc = "Tailwind CSS values" },
    },
    opts = {
      border = DestNgxVim.ui.float.border or "rounded", -- Valid window border style,
      show_unknown_classes = true                       -- Shows the unknown classes popup
    }
  },

  {
    "laytan/tailwind-sorter.nvim",
    event = "BufRead",
    cmd = {
      "TailwindSort",
      "TailwindSortOnSaveToggle"
    },
    keys = {
      { "<Leader>cS", "<CMD>TailwindSortOnSaveToggle<CR>", desc = "toggle Tailwind CSS classes sort on save" },

    },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    build = "cd formatter && bun i && bun run build",
    config = true,
  },

  {
    "axelvc/template-string.nvim",
    event = "InsertEnter",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = true, -- run require("template-string").setup()
  },

  {
    "dmmulroy/tsc.nvim",
    event = "BufRead",
    cmd = { "TSC" },
    config = true,
  },

  {
    "dmmulroy/ts-error-translator.nvim",
    event = "BufRead",
    config = true
  },

  {
    "artemave/workspace-diagnostics.nvim",
    event = "BufRead",
    lazy = false,
  },
  {
    "axelvc/template-string.nvim",
    event = "InsertEnter",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = true, -- run require("template-string").setup()
  },
  {
    "vuki656/package-info.nvim",
    event = "BufRead",
    ft = { "json", "typescript", "typescriptreact" },
    config = true,
  },
  -- {
  --   "OlegGulevskyy/better-ts-errors.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim" },
  --   event = "BufRead",
  --   ft = { "typescript", "typescriptreact" },
  --   config = {
  --     keymaps = {
  --       toggle = '<leader>cl',          -- default '<leader>dd'
  --       go_to_definition = '<CR>' -- default '<leader>dx'
  --     }
  --   }
  -- }
}
