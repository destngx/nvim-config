local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    css = { { "prettied", "prettier" } },
    graphql = { { "prettied", "prettier" } },
    html = { { "prettied", "prettier" } },
    javascript = { { "prettied", "prettier" } },
    javascriptreact = { { "prettied", "prettier" } },
    json = { { "prettied", "prettier" } },
    lua = { "stylua" },
    markdown = { { "prettied", "prettier" } },
    python = { "isort", "black" },
    sql = { "sql-formatter" },
    svelte = { { "prettied", "prettier" } },
    typescript = { { "prettied", "prettier" } },
    typescriptreact = { { "prettied", "prettier" } },
    yaml = { "prettier" },
  },
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
