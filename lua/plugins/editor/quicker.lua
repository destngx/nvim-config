return {
  'stevearc/quicker.nvim',
  ft = "qf",
  event = "BufEnter",
  config = function()
    require("quicker").setup()
  end
}
