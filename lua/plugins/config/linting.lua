local lint = require("lint")
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")

local mason_ensure_installed_linter = {
  "hadolint",
  "tflint",
  "vale",
  "eslint_d",
  "shellcheck",
  "sqlfluff",
  "trivy",  -- Security scanner for containers and IaC
  "golangci-lint",  -- Go linter
}

if mason_registry_ok then
  for _, linter in ipairs(mason_ensure_installed_linter) do
    if not mason_registry.is_installed(linter) and mason_registry.has_package(linter) then
      vim.notify("Missing install " .. linter .. " linter")
      -- custom hadolint version because latest stable macos version is not working on ARM
      -- fixed
      -- if linter == "hadolint" then
      --   linter = "hadolint@v2.12.1-beta"
      -- end
      vim.cmd("MasonInstall " .. linter)
    end
  end
end

local util = require('utils.lspconfig')
local eslint_d = function(fname)
  local root = util.root_pattern(
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    'package.json'
  )(fname)

  if not root then
    return {}
  end

  -- Additional check if package.json has eslintConfig field
  local pkg_file = util.path.join(root, 'package.json')
  if vim.fn.filereadable(pkg_file) == 1 then
    local content = vim.fn.readfile(pkg_file)
    local content_str = table.concat(content, "\n")
    if content_str:match('"eslintConfig"') then
      return { "eslint_d" }
    elseif not util.path.exists(util.path.join(root, '.eslintrc')) then
      return {}
    end
  end

  return { "eslint_d" }
end

local markdown = function()
  if vim.bo.filetype == "codecompanion" then
    return {}
  end
  return { "markdownlint-cli2", "vale" }
end

local dockerfile_linters = function()
  local linters = { "hadolint" }
  if vim.fn.executable("trivy") == 1 then
    table.insert(linters, "trivy")
  end
  return linters
end

local terraform_linters = function()
  local linters = { "tflint" }
  if vim.fn.executable("trivy") == 1 then
    table.insert(linters, "trivy")
  end
  if vim.fn.executable("checkov") == 1 then
    table.insert(linters, "checkov")
  end
  return linters
end

local k8s_yaml_linters = function()
  local filename = vim.fn.expand("%:t")
  if filename:match("k8s") or filename:match("kube") or filename:match("deployment") or filename:match("service") then
    local linters = {}
    if vim.fn.executable("trivy") == 1 then
      table.insert(linters, "trivy")
    end
    if vim.fn.executable("checkov") == 1 then
      table.insert(linters, "checkov")
    end
    return linters
  end
  return {}
end

-- Custom linter configurations for security tools

-- Trivy linter for Dockerfiles and IaC security
lint.linters.trivy = {
  cmd = "trivy",
  stdin = false,
  args = function()
    return {
      "config",
      "--format", "json",
      "--exit-code", "0",
      vim.api.nvim_buf_get_name(0)
    }
  end,
  stream = "stdout",
  ignore_exitcode = true,
  parser = function(output, _)
    local diagnostics = {}
    local ok, decoded = pcall(vim.json.decode, output)
    
    if not ok or not decoded then
      return diagnostics
    end

    -- Trivy config output format
    if decoded.Results then
      for _, result in ipairs(decoded.Results) do
        if result.Misconfigurations then
          for _, misconfig in ipairs(result.Misconfigurations) do
            local severity = misconfig.Severity:lower()
            local level = vim.diagnostic.severity.INFO
            
            if severity == "critical" or severity == "high" then
              level = vim.diagnostic.severity.ERROR
            elseif severity == "medium" then
              level = vim.diagnostic.severity.WARN
            end

            table.insert(diagnostics, {
              lnum = (misconfig.CauseMetadata and misconfig.CauseMetadata.StartLine or 1) - 1,
              end_lnum = (misconfig.CauseMetadata and misconfig.CauseMetadata.EndLine or 1) - 1,
              col = 0,
              message = string.format("[%s] %s: %s", misconfig.ID, misconfig.Title, misconfig.Message),
              severity = level,
              source = "trivy",
            })
          end
        end
      end
    end

    return diagnostics
  end,
}

-- Checkov linter for IaC security (requires: pip install checkov)
lint.linters.checkov = {
  cmd = "checkov",
  stdin = false,
  args = function()
    return {
      "--file", vim.api.nvim_buf_get_name(0),
      "--output", "json",
      "--quiet",
      "--compact",
    }
  end,
  stream = "stdout",
  ignore_exitcode = true,
  parser = function(output, _)
    local diagnostics = {}
    local ok, decoded = pcall(vim.json.decode, output)
    
    if not ok or not decoded then
      return diagnostics
    end

    -- Parse checkov results
    if decoded.results and decoded.results.failed_checks then
      for _, check in ipairs(decoded.results.failed_checks) do
        local severity = vim.diagnostic.severity.WARN
        
        if check.check_class and check.check_class:match("CKV_SECRET") then
          severity = vim.diagnostic.severity.ERROR
        end

        table.insert(diagnostics, {
          lnum = (check.file_line_range and check.file_line_range[1] or 1) - 1,
          end_lnum = (check.file_line_range and check.file_line_range[2] or 1) - 1,
          col = 0,
          message = string.format("[%s] %s", check.check_id, check.check_name),
          severity = severity,
          source = "checkov",
        })
      end
    end

    return diagnostics
  end,
}

-- Linters by filetype with security tools
lint.linters_by_ft = {
  javascript = eslint_d,
  typescript = eslint_d,
  javascriptreact = eslint_d,
  typescriptreact = eslint_d,
  svelte = eslint_d,
  python = { "pylint" },
  markdown = markdown,
  
  -- Docker with security scanning
  dockerfile = dockerfile_linters,
  
  -- Terraform/IaC with security scanning
  terraform = terraform_linters,
  tf = terraform_linters,
  
  hcl = { "terraform_validate" },
  sh = { "shellcheck" },
  sql = { "sqlfluff" },
  
  -- Go linting
  go = { "golangci-lint" },
  
  -- Kubernetes YAML with security scanning
  yaml = k8s_yaml_linters,
}
