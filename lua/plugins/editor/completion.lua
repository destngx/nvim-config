return {
  {
    "onsails/lspkind-nvim",
    event = "VeryLazy",
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
    event = "VeryLazy",
    build = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load { paths = { vim.fn.stdpath("config") .. "/snippets" } }
    end
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require("plugins.config.cmp")
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "https://codeberg.org/FelipeLema/cmp-async-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "saadparwaiz1/cmp_luasnip",
      {
        "David-Kunz/cmp-npm",
        opts = {
          ignore = {},
          only_semantic_versions = true,
        }
      },
      {
        "zbirenbaum/copilot-cmp",
        enabled = DestNgxVim.plugins.ai.copilot.enabled,
        config = function()
          require("copilot_cmp").setup()
        end,
      },
      "petertriho/cmp-git"
    },
  },
  {
    "js-everts/cmp-tailwind-colors",
    event = "VeryLazy",
    config = true,
  },
}
