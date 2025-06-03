local lint = require("lint")
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")

local mason_ensure_installed_linter = {
  "hadolint",
  "tflint",
  "vale",
  "eslint_d",
  "shellcheck",
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

lint.linters_by_ft = {
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  svelte = { "eslint_d" },
  python = { "pylint" },
  makrdown = { "markdownlint-cli2", "vale" },
  dockerfile = { "hadolint" },
  terraform = { "tflint" },
  tf = { "tflint" },
  hcl = { "terraform_validate" },
  sh = { "shellcheck" },
}
