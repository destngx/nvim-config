return {
  -- Add subdirectories here
  {
    { import = "plugins.ai" },
    { import = "plugins.appearance" },
    { import = "plugins.languages" },
    { import = "plugins.editor" },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │ General plugins                                         │
  -- ╰─────────────────────────────────────────────────────────╯
  { "AndrewRadev/switch.vim", lazy = false },
  { "tpope/vim-repeat",       lazy = false },
  { "tpope/vim-speeddating",  lazy = false },
  {
    "airblade/vim-rooter",
    event = "VeryLazy",
    config = function()
      vim.g.rooter_patterns = DestNgxVim.plugins.rooter.patterns
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_resolve_links = 1
    end,
  },
  { "nvim-lua/plenary.nvim", lazy = false },
  { "tpope/vim-sleuth",      event = "BufReadPre" },
  {
    "chrisgrieser/nvim-spider",
    enabled = DestNgxVim.plugins.jump_by_subwords.enabled,
    event = "BufEnter",
    keys = { "w", "e", "b", "ge" },
    config = function()
      vim.keymap.set({ "n", "o", "x" }, "W", "w", { desc = "Normal w" })
      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
      vim.keymap.set(
        { "n", "o", "x" },
        "ge",
        "<cmd>lua require('spider').motion('ge')<CR>",
        { desc = "Spider-ge" }
      )
    end,
  },
  {
    'mrjones2014/smart-splits.nvim',
    event = "VimEnter",
  },
  {
    "gbprod/stay-in-place.nvim",
    event = "BufEnter",
    config = true, -- run require("stay-in-place").setup()
  },
  {
    "AckslD/nvim-neoclip.lua",
    event = "BufReadPre",
    dependencies = {
      { 'kkharji/sqlite.lua', module = 'sqlite' },
      -- you'll need at least one of these
      { 'ibhagwan/fzf-lua' },
    },
    config = function()
      require('neoclip').setup({
        enable_persistent_history = true,
      })
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    event = "BufEnter",
    ft = "qf",
    init = function()
      require('plugins.config.bqf-init')
    end,
  },
}
