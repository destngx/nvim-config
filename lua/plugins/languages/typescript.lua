return {
  {
    "yioneko/nvim-vtsls",
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = "javascript,typescript,typescriptreact,svelte",
    config = true,
  },
  {
    "razak17/tailwind-fold.nvim",
    opts = {
      min_chars = 50,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
  },
  {
    "MaximilianLloyd/tw-values.nvim",
    ft = { "typescriptreact" },
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
    ft = { "typescriptreact" },
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
    ft = { "typescript", "typescriptreact" },
    cmd = { "TSC" },
    config = true,
  },
  {
    "artemave/workspace-diagnostics.nvim",
    ft = { "typescript", "typescriptreact" },
  },
  {
    "vuki656/package-info.nvim",
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
