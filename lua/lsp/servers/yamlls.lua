local M = {}

M.settings = {
  yaml = {
    schemas = {
      ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/.gitlab-ci.yml",
      ["https://json.schemastore.org/semantic-release.json"] = "/.releaserc.yml",
      ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
    }
  }
}
return M
