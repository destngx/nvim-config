local M = {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
}
-- M.on_attach = function(client, bufnr)
--   client.server_capabilities.documentFormattingProvider = true
--   client.server_capabilities.documentRangeFormattingProvider = true
--   if vim.bo[bufnr].filetype == "helm" then
--     vim.schedule(function()
--       vim.cmd("LspStop ++force yamlls")
--     end)
--   end
-- end
M.settings = {
  yaml = {
    hover = true,
    validate = false,
    completion = true,
    keyOrdering = false,
    format = { enabled = false },
    redhat = {
      telemetry = { enabled = false },
    },
    schemaStore = {
      enable = true,
      url = "https://www.schemastore.org/api/json/catalog.json",
    },
    schemas = {
      -- Kubernetes & Container Orchestration
      kubernetes = "*.yaml",
      ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json"] = "/*.k8s.yaml",
      ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
      ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
      ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
      
      -- CI/CD
      ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
      ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
      ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = { "*gitlab-ci*.{yml,yaml}", ".gitlab/**/*.yml" },
      ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "azure-pipelines.yml",
      ["https://bitbucket.org/atlassianlabs/intellij-bitbucket-references-plugin/raw/master/src/main/resources/schemas/bitbucket-pipelines.schema.json"] = ".bitbucket-pipelines.yml",
      ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
      ["https://json.schemastore.org/circleci"] = ".circleci/**/*.{yml,yaml}",
      ["https://json.schemastore.org/drone"] = ".drone.{yml,yaml}",
      ["https://json.schemastore.org/travis"] = ".travis.{yml,yaml}",
      
      -- Configuration Management
      ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
      
      -- Cloud Providers
      ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] = { "cloudformation/**/*.{yml,yaml}", "*cfn*.{yml,yaml}", "*cloudformation*.{yml,yaml}" },
      ["https://json.schemastore.org/aws-sam"] = { "sam*.{yml,yaml}", "template.{yml,yaml}" },
      ["https://json.schemastore.org/serverless"] = "serverless.{yml,yaml}",
      
      -- Monitoring & Observability
      ["https://json.schemastore.org/prometheus"] = { "prometheus*.{yml,yaml}", "alertmanager*.{yml,yaml}" },
      ["https://json.schemastore.org/prometheus.rules"] = { "alerts/*.{yml,yaml}", "rules/*.{yml,yaml}", "*rules.{yml,yaml}" },
      ["https://json.schemastore.org/datadog-service-definition"] = "service.datadog.{yml,yaml}",
      
      -- Service Mesh & Advanced K8s
      ["https://json.schemastore.org/istio-operator"] = "istio-operator*.{yml,yaml}",
      ["https://json.schemastore.org/traefik-v2"] = "traefik*.{yml,yaml}",
      ["https://json.schemastore.org/traefik-v2-file-provider"] = "traefik-config*.{yml,yaml}",
      
      -- API & Documentation
      ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
      ["https://json.schemastore.org/asyncapi"] = "asyncapi*.{yml,yaml}",
      
      -- Code Quality & Formatting
      ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
      ["https://json.schemastore.org/yamllint"] = ".yamllint",
      ["https://json.schemastore.org/pre-commit-config"] = ".pre-commit-config.{yml,yaml}",
      
      -- Package & Project Management
      ["https://json.schemastore.org/renovate"] = { "renovate.{yml,yaml}", ".renovaterc.{yml,yaml}" },
      ["https://json.schemastore.org/markdownlint"] = ".markdownlint.{yml,yaml}",
    }
  }
}

return M
