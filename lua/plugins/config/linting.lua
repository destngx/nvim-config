local lint = require("lint")
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")

local mason_ensure_installed_linter = {
  "hadolint",
  "tflint",
  "vale",
  "eslint_d",
  "shellcheck",
  "sqlfluff",
}

if mason_registry_ok then
  for _, linter in ipairs(mason_ensure_installed_linter) do
    if not mason_registry.is_installed(linter) and mason_registry.has_package(linter) then
      vim.notify("Missing install " .. linter .. " linter")
      -- custom hadolint version because latest stable macos version is not working on ARM
      if linter == "hadolint" then
        linter = "hadolint@v2.12.1-beta"
      end
      vim.cmd("MasonInstall " .. linter)
    end
  end
end

local util = require('lspconfig.util')
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
    return nil
  end

  -- Additional check if package.json has eslintConfig field
  local pkg_file = util.path.join(root, 'package.json')
  if vim.fn.filereadable(pkg_file) == 1 then
    local content = vim.fn.readfile(pkg_file)
    local content_str = table.concat(content, "\n")
    if content_str:match('"eslintConfig"') then
      return "eslint_d"
    elseif not util.path.exists(util.path.join(root, '.eslintrc')) then
      return nil
    end
  end

  return "eslint_d"
end
lint.linters_by_ft = {
  javascript = { eslint_d() },
  typescript = { eslint_d() },
  javascriptreact = { eslint_d() },
  typescriptreact = { eslint_d() },
  svelte = { eslint_d() },
  python = { "pylint" },
  makrdown = { "markdownlint-cli2", "vale" },
  dockerfile = { "hadolint" },
  terraform = { "tflint" },
  tf = { "tflint" },
  hcl = { "terraform_validate" },
  sh = { "shellcheck" },
  sql = { "sqlfluff" },
}
