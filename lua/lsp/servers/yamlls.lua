local M = {}

M.settings = {
  yaml = {
    schemas = {
      ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {"/.gitlab-ci.yml", ".gitlab/**/*.yml"},
      ["https://bitbucket.org/atlassianlabs/intellij-bitbucket-references-plugin/raw/master/src/main/resources/schemas/bitbucket-pipelines.schema.json"] = ".bitbucket-pipelines.yml",
      ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
    }
  }
}
return M
