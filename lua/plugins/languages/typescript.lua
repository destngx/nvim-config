local ts_filetypes = {
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescriptreact",
  "typescript.tsx",
}
local react_filetypes = {
  "javascriptreact",
  "typescriptreact",
  "typescript.tsx",
  "javascript.jsx",
}

return {
  {
    "yioneko/nvim-vtsls",
    ft = ts_filetypes,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    event = "LspAttach",
    ft = ts_filetypes,
    config = true,
  },
  {
    "razak17/tailwind-fold.nvim",
    opts = {
      min_chars = 50,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = react_filetypes,
  },
  {
    "MaximilianLloyd/tw-values.nvim",
    ft = react_filetypes,
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
    ft = react_filetypes,
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
    ft = ts_filetypes,
    config = true, -- run require("template-string").setup()
  },
  {
    "dmmulroy/tsc.nvim",
    ft = ts_filetypes,
    cmd = { "TSC" },
    config = true,
  },
  {
    "artemave/workspace-diagnostics.nvim",
    ft = ts_filetypes,
  },
  {
    "vuki656/package-info.nvim",
    ft = ts_filetypes,
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
