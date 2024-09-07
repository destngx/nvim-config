return {
  "nacro90/numb.nvim",
  event = "BufEnter",
  config = function()
    require('numb').setup()
  end,
}
