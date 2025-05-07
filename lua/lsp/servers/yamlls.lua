local M = {}
M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true
  if vim.bo[bufnr].filetype == "helm" then
    vim.schedule(function()
      vim.cmd("LspStop ++force yamlls")
    end)
  end
end
M.settings = {
  yaml = {
    schemas = {
      ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = { "/.gitlab-ci.yml", ".gitlab/**/*.yml" },
      ["https://bitbucket.org/atlassianlabs/intellij-bitbucket-references-plugin/raw/master/src/main/resources/schemas/bitbucket-pipelines.schema.json"] =
      ".bitbucket-pipelines.yml",
      ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
    }
  }
}
vim.lsp.config.yaml = {
  on_attach = M.on_attach,
  settings = M.settings,
}
vim.lsp.enable("yaml")
