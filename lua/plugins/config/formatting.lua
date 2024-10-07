local conform = require("conform")
local formatters = {
  "biome",
  "prettierd",
  "prettier",
  ["markdown-toc"] = {
    condition = function(_, ctx)
      for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
        if line:find("<!%-%- toc %-%->") then
          return true
        end
      end
    end,
  },
  ["markdownlint-cli2"] = {
    condition = function(_, ctx)
      local diag = vim.tbl_filter(function(d)
        return d.source == "markdownlint"
      end, vim.diagnostic.get(ctx.buf))
      return #diag > 0
    end,
  },

}

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

  -- Default to Prettier if no config is found
  return { "prettier", stop_after_first = true }
end

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
  "markdown",
  "markdown.mdx",
  "graphql",
  "handlebars",
}
conform.setup({
  formatters_by_ft = (function()
    local result = {}
    for _, ft in ipairs(filetypes_with_dynamic_formatter) do
      if ft == "markdown" or ft == "markdown.mdx" then
        result[ft] = { "markdown-toc", "markdownlint-cli2" }
      else
        result[ft] = biome_or_prettier
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
