local M = {
  attach_mode = "autoattach",
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash", "zsh" },
  ignoredRootPaths = { "~" }
}


return M
