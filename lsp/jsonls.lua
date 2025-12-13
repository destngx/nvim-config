-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/jsonls.lua

local M = {
	cmd = { "vscode-json-language-server", "--stdio", },
  filetypes = {
    "json",
    "jsonc",
  },
  root_markers = {
    ".git",
  },
  init_options = { provideFormatter = true },
  single_file_support = true,
  -- lazy-load schemastore when needed
  on_new_config = function(new_config)
    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
  end,
  settings = {
    json = {
      format = {
        enable = true,
      },

      validate = { enable = true },
      schemas = {
        -- Frontend & Build Tools
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json"
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json"
        },
        {
          fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
          url = "https://json.schemastore.org/prettierrc.json"
        },
        {
          fileMatch = { ".eslintrc", ".eslintrc.json" },
          url = "https://json.schemastore.org/eslintrc.json"
        },
        {
          fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
          url = "https://json.schemastore.org/babelrc.json"
        },
        {
          fileMatch = { "lerna.json" },
          url = "https://json.schemastore.org/lerna.json"
        },
        {
          fileMatch = { "now.json", "vercel.json" },
          url = "https://json.schemastore.org/now.json"
        },
        {
          fileMatch = { ".releaserc.json" },
          url = "https://json.schemastore.org/semantic-release.json"
        },
        {
          fileMatch = { "ecosystem.json" },
          url = "https://json.schemastore.org/pm2-ecosystem.json"
        },
        
        -- Cloud & Infrastructure
        {
          fileMatch = { "*.template.json", "*cloudformation*.json", "*cfn*.json" },
          url = "https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"
        },
        {
          fileMatch = { "serverless.json" },
          url = "https://json.schemastore.org/serverless.json"
        },
        {
          fileMatch = { "pulumi*.json" },
          url = "https://json.schemastore.org/pulumi.json"
        },
        
        -- Docker & Kubernetes
        {
          fileMatch = { "docker-compose*.json", "*compose*.json" },
          url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"
        },
        {
          fileMatch = { "kustomization.json" },
          url = "https://json.schemastore.org/kustomization.json"
        },
        
        -- Monitoring & Observability
        {
          fileMatch = { "*grafana*.json", "dashboard*.json", "*dashboard.json" },
          url = "https://json.schemastore.org/grafana-dashboard.json"
        },
        {
          fileMatch = { "prometheus*.json", "alertmanager*.json" },
          url = "https://json.schemastore.org/prometheus.json"
        },
        {
          fileMatch = { "service.datadog.json" },
          url = "https://json.schemastore.org/datadog-service-definition.json"
        },
        
        -- CI/CD
        {
          fileMatch = { ".github/workflows/*.json" },
          url = "https://json.schemastore.org/github-workflow.json"
        },
        {
          fileMatch = { ".github/dependabot.json" },
          url = "https://json.schemastore.org/dependabot-v2.json"
        },
        {
          fileMatch = { ".circleci/config.json" },
          url = "https://json.schemastore.org/circleci.json"
        },
        {
          fileMatch = { "azure-pipelines.json" },
          url = "https://json.schemastore.org/azure-pipelines.json"
        },
        {
          fileMatch = { "*gitlab-ci*.json" },
          url = "https://json.schemastore.org/gitlab-ci.json"
        },
        
        -- API & Documentation
        {
          fileMatch = { "*openapi*.json", "*swagger*.json", "*api*.json" },
          url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"
        },
        {
          fileMatch = { "asyncapi*.json" },
          url = "https://json.schemastore.org/asyncapi.json"
        },
        
        -- Code Quality & Linting
        {
          fileMatch = { ".markdownlint.json", ".markdownlintrc" },
          url = "https://json.schemastore.org/markdownlint.json"
        },
        {
          fileMatch = { ".yamllint" },
          url = "https://json.schemastore.org/yamllint.json"
        },
        {
          fileMatch = { ".pre-commit-config.json" },
          url = "https://json.schemastore.org/pre-commit-config.json"
        },
        {
          fileMatch = { "renovate.json", ".renovaterc.json" },
          url = "https://json.schemastore.org/renovate.json"
        },
        
        -- VS Code & Editor
        {
          fileMatch = { ".vscode/settings.json" },
          url = "https://json.schemastore.org/vscode-settings.json"
        },
        {
          fileMatch = { ".vscode/launch.json" },
          url = "https://json.schemastore.org/launch.json"
        },
        {
          fileMatch = { ".vscode/tasks.json" },
          url = "https://json.schemastore.org/task.json"
        },
        {
          fileMatch = { ".vscode/extensions.json" },
          url = "https://json.schemastore.org/vscode-extensions.json"
        },
      }
    },
  },
}




return M
