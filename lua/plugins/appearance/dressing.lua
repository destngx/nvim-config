return {
  "stevearc/dressing.nvim",
  -- enabled = false,
  event = "VeryLazy",
  dependencies = "MunifTanjim/nui.nvim",
  opts = {
    select = {
      enabled = true,
      -- Priority list of preferred vim.select implementations
      backend = { "fzf_lua",  "builtin" },
    }
  }
}
