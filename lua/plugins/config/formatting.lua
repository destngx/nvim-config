local conform = require("conform")
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")

local mason_ensure_installed_formatter = {
  "terraform_fmt"
}
if mason_registry_ok then
  for _, formatter in ipairs(mason_ensure_installed_formatter) do
    if not mason_registry.is_installed(formatter) and mason_registry.has_package(formatter) then
      vim.notify("Please install " .. formatter .. " formatter")
      vim.cmd("MasonInstall " .. formatter)
    end
  end
end

local function find_config(bufnr, config_files)
  return vim.fs.find(config_files, {
    upward = true,
    stop = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
  })[1]
end

local function biome_or_prettier(bufnr)
  local has_biome_config = find_config(bufnr, { "biome.json", "biome.jsonc" })
  if has_biome_config then
    return { "biome", stop_after_first = true }
  end

  local has_prettier_config = find_config(bufnr, {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
  })
  if has_prettier_config then
    return { "prettier", stop_after_first = true }
  end

  -- Default to None if no config is found
  return {}
end

local filetypes_without_dynamic_formatter = {
  "markdown",
  "markdown.mdx",
}
local filetypes_with_dynamic_formatter = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
  "css",
  "scss",
  "less",
  "html",
  "json",
  "jsonc",
  "yaml",
  "graphql",
  "handlebars",
  "hcl",
  "terraform",
  "tf",
  terraform = { "terraform_fmt" },
  tf = { "terraform_fmt" },
  ["terraform-vars"] = { "terraform_fmt" },
}
conform.setup({
  formatters_by_ft = (function()
    local result = {}
    for _, ft in ipairs(filetypes_with_dynamic_formatter) do
      result[ft] = biome_or_prettier
    end
    for _, ft in ipairs(filetypes_without_dynamic_formatter) do
      if ft == "markdown" or ft == "markdown.mdx" then
        result[ft] = { "markdown-toc", "markdownlint-cli2" }
      end
      if ft == "terraform" or ft == "terraform-vars" or ft == "tf" then
        result[ft] = { "terraform_fmt" }
      end
    end

    return result
  end)(),
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end

  conform.format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
