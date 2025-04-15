return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.config.git.signs")
    end,
    keys = {
      { "<Leader>ghd", desc = "diff hunk" },
      { "<Leader>ghp", desc = "preview" },
      { "<Leader>ghR", desc = "reset buffer" },
      { "<Leader>ghr", desc = "reset hunk" },
      { "<Leader>ghs", desc = "stage hunk" },
      { "<Leader>ghS", desc = "stage buffer" },
      { "<Leader>ght", desc = "toggle deleted" },
      { "<Leader>ghu", desc = "undo stage" }
    }
  },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("plugins.config.git.diffview")
    end,
    keys = {
      { "<Leader>gd", "<cmd>lua require('plugins.config.git.diffview').toggle_file_history()<CR>", desc = "diff file" },
      { "<Leader>gS", "<cmd>lua require('plugins.config.git.diffview').toggle_status()<CR>",       desc = "Project Diff" }
    },
  },
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("plugins.config.git.conflict")
    end,
    keys = {
      { "<Leader>gcb", '<cmd>GitConflictChooseBoth<CR>',   desc = 'choose both' },
      { "<Leader>gcn", '<cmd>GitConflictNextConflict<CR>', desc = 'move to next conflict' },
      { "<Leader>gcc", '<cmd>GitConflictChooseOurs<CR>',   desc = 'choose current' },
      { "<Leader>gcp", '<cmd>GitConflictPrevConflict<CR>', desc = 'move to prev conflict' },
      { "<Leader>gci", '<cmd>GitConflictChooseTheirs<CR>', desc = 'choose incoming' },
    }
  },
  {
    'polarmutex/git-worktree.nvim',
    version = '^2',
    config = function()
      require("plugins.config.git.worktree")
    end,
  },
  {
    "FabijanZulj/blame.nvim",
    config = function()
      require("blame").setup()
    end
  },
  -- {
  --   "pwntester/octo.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   cmd = {
  --     "Octo",
  --   },
  --   config = function()
  --     require('plugins.config.git.octo')
  --   end
  -- },
}
