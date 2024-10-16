return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("config.colorscheme")
    vim.cmd([[colorscheme kanagawa]])
  end,
}
