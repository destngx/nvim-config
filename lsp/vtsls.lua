local filter = require("utils.filter").filter
local filterReactDTS = require("utils.filterReactDTS").filterReactDTS
local errorTranslator = require("ts-error-translator")

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = DestNgxVim.ui.float.border,
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = DestNgxVim.ui.float.border }
  ),
  ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
    errorTranslator.translate_diagnostics(err, result, ctx, config)
    vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
  end,
  -- ["textDocument/publishDiagnostics"] = vim.lsp.with(
  --   vim.lsp.diagnostic.on_publish_diagnostics,
  --   { virtual_text = DestNgxVim.lsp.virtual_text }
  -- ),
  ["textDocument/definition"] = function(err, result, method, ...)
    if vim.islist(result) and #result > 1 then
      local filtered_result = filter(result, filterReactDTS)
      return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method, ...)
    end

    vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
  end,
}

local settings = {
  complete_function_calls = true,
  vtsls = {
    enableMoveToFileCodeAction = true,
    autoUseWorkspaceTsdk = true,
    experimental = {
      completion = {
        enableServerSideFuzzyMatch = false,
      },
    },
  },
  typescript = {
    implementationCodeLens = { enabled = true },
    referencesCodeLens = { enabled = true, showOnAllFunctions = false },
    tsserver = {
      maxTsServerMemory = vim.fn.has('macunix') == 1 and 8192 or 16384,
    },
    updateImportsOnFileMove = { enabled = "always" },
    inlayHints = {
      parameterNames = { enabled = "literals" },
      parameterTypes = { enabled = false },
      variableTypes = { enabled = false },
      propertyDeclarationTypes = { enabled = false },
      functionLikeReturnTypes = { enabled = true },
      enumMemberValues = { enabled = true },
    },
    suggest = {
      completeFunctionCalls = true,
      includeCompletionsForModuleExports = true,
    },
  },
}
settings.javascript =
    vim.tbl_deep_extend("force", {}, settings.typescript, settings.javascript or {})

local on_attach = function(client, bufnr)
  client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
    print(ctx.bufnr)
    local action, uri, range = unpack(command.arguments)

    local function move(newf)
      client.request("workspace/executeCommand", {
        command = command.command,
        arguments = { action, uri, range, newf },
      })
    end

    local fname = vim.uri_to_fname(uri)
    client.request("workspace/executeCommand", {
      command = "typescript.tsserverRequest",
      arguments = {
        "getMoveToRefactoringFileSuggestions",
        {
          file = fname,
          startLine = range.start.line + 1,
          startOffset = range.start.character + 1,
          endLine = range["end"].line + 1,
          endOffset = range["end"].character + 1,
        },
      },
    }, function(_, result)
      ---@type string[]
      local files = result.body.files
      table.insert(files, 1, "Enter new path...")
      vim.ui.select(files, {
        prompt = "Select move destination:",
        format_item = function(f)
          return vim.fn.fnamemodify(f, ":~:.")
        end,
      }, function(f)
        if f and f:find("^Enter new path") then
          vim.ui.input({
            prompt = "Enter move destination:",
            default = vim.fn.fnamemodify(fname, ":h") .. "/",
            completion = "file",
          }, function(newf)
            return newf and move(newf)
          end)
        elseif f then
          move(f)
        end
      end)
    end)
  end
  require("which-key").add({
    { buffer = bufnr },
    { "<leader>c",   group = "TypeScript Actions", },
    { "<leader>ce",  "<cmd>TSC<CR>",                         desc = "workspace errors (TSC)" },
    { "<leader>cF",  "<cmd>VtsExec fix_all<CR>",             desc = "fix all" },
    { "<leader>ci",  "<cmd>VtsExec add_missing_imports<CR>", desc = "import all" },
    { "<leader>co",  "<cmd>VtsExec organize_imports<CR>",    desc = "organize imports" },
    { "<leader>cs",  "<cmd>VtsExec source_actions<CR>",      desc = "source actions" },
    { "<leader>cu",  "<cmd>VtsExec remove_unused<CR>",       desc = "remove unused" },
    { "<leader>cV",  "<cmd>VtsExec select_ts_version<CR>",   desc = "select TS version" },
    { "<leader>cF",  "<cmd>VtsExec file_references<CR>",     desc = "file references" },
  })
end

local M = {
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  cmd = { 'vtsls', '--stdio' },
  workspace_required = true,
  handlers = handlers,
  on_attach = on_attach,
  settings = settings,
}
return M
