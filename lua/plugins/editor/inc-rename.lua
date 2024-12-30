return {
  "smjonas/inc-rename.nvim",
  event = "BufRead",
  config = function()
    require("inc_rename").setup()
  end,
}
