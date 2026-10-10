return {
  "0x00-ketsu/autosave.nvim",
  event = { "InsertLeave", "TextChanged" },
  config = function()
    require("autosave").setup {
      enabled = true,
      conditions = {
        filetype_is_not = { "gitcommit", "oil", "alpha", "bigfile" },
      },
    }
  end,
}
