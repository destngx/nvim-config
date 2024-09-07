return {
  {
    "zbirenbaum/copilot.lua",
    cond = DestNgxVim.plugins.ai.copilot.enabled,
    event = "VeryLazy",
    opts = {
      suggestion = { enabled = true },
       panel = { enabled = true },
       filetypes = {
         markdown = true,
       },
    },
    dependencies = { 'AndreM222/copilot-lualine' }
  },
}
