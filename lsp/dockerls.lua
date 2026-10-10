---@type vim.lsp.Config
return {
  attach_mode = "autoattach",
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  settings = {
    docker = {
      languageserver = {
        formatter = {
          ignoreMultilineInstructions = true,
        },
      },
    },
  },
}
