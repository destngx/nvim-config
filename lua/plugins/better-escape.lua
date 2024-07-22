require("better_escape").setup {
  timeout = vim.o.timeoutlen,   -- the time in which the keys must be hit in ms. Use option timeoutlen by default
  default_mapping = true,
}
