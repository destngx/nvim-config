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
        enabled = true,
        auto_trigger = true,
      },
      panel = { enabled = true },
      filetypes = {
        sql =true,
        markdown = true,
        typescript = true,
        yaml = true,
      },
    },
    dependencies = { 'AndreM222/copilot-lualine' }
  },
}
