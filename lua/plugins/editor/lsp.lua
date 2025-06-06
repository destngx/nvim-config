return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    lazy = false,
    opts = {
      ui = {
        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = DestNgxVim.ui.float.border or "rounded",
      },
    }
  },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = {
      ensure_installed = {

        "lua_ls",
        "vtsls",
        "dockerls",
        "docker_compose_language_service",
        "terraformls",
        "helm_ls",
        "bashls",
        "eslint",
        "jsonls",
        "shfmt",
        -- "vale_ls",
        -- "makrdownlint-cli2",
        -- "markdown-toc","yamlls",

      },
      automatic_installation = true,
    }
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
    enabled = false,
    event = "LspAttach", -- Or `VeryLazy`
    priority = 1000,     -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup({
        preset = 'simple',
        options = {
          multiple_diag_under_cursor = true,
          multilines = false,
          overflow = { mode = "wrap" },
          severity = {
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT
          },
          -- multilines = true,
          -- use_icons_from_diagnostic = true,
          -- show_all_diags_on_cursorline = true,
        },
        disabled_ft = { "markdown" } -- List of filetypes to disable the plugin
      })
    end
  }
}
