require("oil").setup({
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  view_options = {
    show_hidden = true,
    natural_order = false,
  },
  win_options = {
    signcolumn = "yes:2",
  },
})
