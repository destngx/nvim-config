return {
  "ibhagwan/fzf-lua",
  event = "VimEnter",
  branch = "main",
  config = function()
    require("plugins.config.fzf")
  end,
}
