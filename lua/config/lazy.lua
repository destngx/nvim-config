local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("config.plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "kanagawa-wave" } },
  checker = { enabled = false },
  change_detection = { enabled = true, notify = false },
  concurrency = 5,
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tutor",
        "zipPlugin",
      },
    },
  },
  debug = false,
  ui = {
    border = DestNgxVim.ui.float.border,
  }
})

vim.keymap.set("n", "<leader>/l", "<cmd>:Lazy<cr>")
