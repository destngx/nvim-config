return {
  -- {
  --   "github/copilot.vim",
  --   cond = DestNgxVim.plugins.ai.copilot.enabled,
  --   event = "VeryLazy",
  -- },
  {
    "zbirenbaum/copilot.lua",
    cond = DestNgxVim.plugins.ai.copilot.enabled,
    event = "VeryLazy",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
      },
      panel = { enabled = false },
      filetypes = {
        sql =true,
        markdown = true,
        typescript = true,
        yaml = true,
        bigfile = false,
      },
    },
    dependencies = { 'AndreM222/copilot-lualine' }
  },
}
