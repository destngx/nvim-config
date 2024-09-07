return {
  'declancm/cinnamon.nvim',
  event = "BufReadPre",
  opts = {
    keymaps = {
      basic = true,
      extra = true,
    },
    -- Only scroll the window
    options = { mode = "window" },
  }
}
