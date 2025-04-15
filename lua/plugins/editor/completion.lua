return {
  {
    'saghen/blink.compat',
    version = '*',
    opts = {},
  },
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      -- "giuxtaposition/blink-cmp-copilot",
      "fang2hou/blink-copilot",
      "hrsh7th/cmp-calc",
      "petertriho/cmp-git",
      "David-Kunz/cmp-npm",
      -- {
      --   "js-everts/cmp-tailwind-colors",
      --   config = true,
      -- },
    },
    version = "*",

    config = function()
      require("plugins.config.blink")
    end,
  },
}
