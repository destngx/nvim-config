-- Diagnostic config

local codes = {
  -- Lua
  no_matching_function = {
    message = DestNgxVim.icons.telescope .. " Can't find a matching function",
    "redundant-parameter",
    "ovl_no_viable_function_in_call",
  },
  empty_block = {
    message = DestNgxVim.icons.forbidden .. " That shouldn't be empty here",
    "empty-block",
  },
  missing_symbol = {
    message = DestNgxVim.icons.forbidden .. " Here should be a symbol",
    "miss-symbol",
  },
  expected_semi_colon = {
    message = DestNgxVim.icons.comment .. " Please put the `;` or `,`",
    "expected_semi_declaration",
    "miss-sep-in-table",
    "invalid_token_after_toplevel_declarator",
  },
  redefinition = {
    message = DestNgxVim.icons.warningCircle .. " That variable was defined before",
    icon = DestNgxVim.icons.warningCircle,
    "redefinition",
    "redefined-local",
    "no-duplicate-imports",
    "@typescript-eslint/no-redeclare",
    "import/no-duplicates"
  },
  no_matching_variable = {
    message = DestNgxVim.icons.telescope .. " Can't find that variable",
    "undefined-global",
    "reportUndefinedVariable",
  },
  trailing_whitespace = {
      message = DestNgxVim.icons.forbidden .. " Whitespaces are useless",
    "trailing-whitespace",
    "trailing-space",
  },
  unused_variable = {
    message = DestNgxVim.icons.forbidden .. " Don't define variables you don't use",
    icon = DestNgxVim.icons.forbidden .. " ",
    "unused-local",
    "@typescript-eslint/no-unused-vars",
    "no-unused-vars"
  },
  unused_function = {
    message = DestNgxVim.icons.forbidden .. " Don't define functions you don't use",
    "unused-function",
  },
  useless_symbols = {
    message = DestNgxVim.icons.trash .. " Remove that useless symbols",
    "unknown-symbol",
  },
  wrong_type = {
    message = DestNgxVim.icons.warningTriangle .. " Try to use the correct types",
    "init_conversion_failed",
  },
  undeclared_variable = {
    message = DestNgxVim.icons.questionCircle .. " Have you delcared that variable somewhere?",
    "undeclared_var_use",
  },
  lowercase_global = {
    message = DestNgxVim.icons.questionCircle .. " Should that be a global? (if so make it uppercase)",
    "lowercase-global",
  },
  -- Typescript
  no_console = {
    icon = DestNgxVim.icons.forbidden,
    "no-console",
  },
  -- Prettier
  prettier = {
    icon = DestNgxVim.icons.paint,
    "prettier/prettier"
  }
}
local function format_diagnostic(diagnostic)
  local code = diagnostic and diagnostic.user_data and diagnostic.user_data.lsp.code

  if not diagnostic.source or not code then
    return string.format('%s', diagnostic.message)
  end

  if diagnostic.source == 'eslint' then
    for _, table in pairs(codes) do
      if vim.tbl_contains(table, code) then
        return string.format('%s [%s]', table.icon .. diagnostic.message, code)
      end
    end

    return string.format('%s [%s]', diagnostic.message, code)
  end

  for _, table in pairs(codes) do
    if vim.tbl_contains(table, code) then
      return table.message
    end
  end

  return string.format('%s [%s]', diagnostic.message, diagnostic.source)
end
local virtual_lines = {
  current_line = true,
  severity = {
    min = vim.diagnostic.severity.HINT,
    max = vim.diagnostic.severity.ERROR,
  },
  format = format_diagnostic
}
-- Diagnostic config
local diagnostic_config = {
  float = {
    source = false,
    format = format_diagnostic
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    }
  },
  underline = true,
  update_in_insert = false,
  virtual_text = DestNgxVim.lsp.virtual_text and {
    prefix = DestNgxVim.icons.circle,
  } or false,
}

vim.diagnostic.config(diagnostic_config)
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local config = vim.deepcopy(diagnostic_config)
    if vim.bo.filetype ~= "markdown" then
      config.virtual_lines = virtual_lines
    else
      config.virtual_lines = false
    end
    vim.diagnostic.config(config)
  end
})
-- Default Codelens command
-- Each LSP client can override this function to provide custom codelens
vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
  local locations = command.arguments[3]
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if locations and #locations > 0 then
    local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
    vim.fn.setloclist(0, {}, " ", { title = "References", items = items, context = ctx })
    vim.api.nvim_command("lopen")
  end
end
vim.api.nvim_create_autocmd({ "LspAttach", "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = vim.lsp.codelens.refresh,
})

-- UI
local lspui_ok, lspui = pcall(require, 'lspconfig.ui.windows')
if not lspui_ok then
  return
end

lspui.default_options.border = DestNgxVim.ui.float.border or 'rounded'
