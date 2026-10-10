-- Self-contained: nvim-lspconfig is lazy-loaded, so its lsp/eslint.lua is not on the
-- runtimepath when this config resolves. Adapted from that file for the 0.11+ API.

local ESLINT_CONFIG_FILES = {
  ".eslintrc",
  ".eslintrc.cjs",
  ".eslintrc.js",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  "eslint.config.cjs",
  "eslint.config.cts",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.mts",
  "eslint.config.ts",
}
local PROJECT_MARKERS = { { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }, { ".git" } }
local DENO_MARKERS = { "deno.json", "deno.jsonc", "deno.lock" }

---@param path string
---@return boolean
local function _has_eslint_config_key(path)
  local read_ok, lines = pcall(vim.fn.readfile, path)
  return read_ok and table.concat(lines, "\n"):find('"eslintConfig"', 1, true) ~= nil
end

--- Whether an ESLint config (or a legacy package.json "eslintConfig") sits between the
--- file and the project root.
---@param filename string
---@param project_root string
---@return boolean
local function _uses_eslint(filename, project_root)
  return vim.fs.find(function(name, path)
    if name == "package.json" then
      return _has_eslint_config_key(vim.fs.joinpath(path, name))
    end
    return vim.tbl_contains(ESLINT_CONFIG_FILES, name)
  end, {
    path = vim.fs.dirname(filename),
    type = "file",
    limit = 1,
    upward = true,
    stop = vim.fs.dirname(project_root),
  })[1] ~= nil
end

---@type vim.lsp.Config
local M = {
  attach_mode = "ondemand",
  -- Prefer the project's own server; Yarn PnP projects need `yarn exec`
  cmd = function(dispatchers, config)
    local cmd = { "vscode-eslint-language-server", "--stdio" }
    local root_dir = config and config.root_dir
    if root_dir then
      local local_cmd = vim.fs.joinpath(root_dir, "node_modules/.bin", cmd[1])
      if vim.fn.executable(local_cmd) == 1 then
        cmd[1] = local_cmd
      end
      if vim.uv.fs_stat(root_dir .. "/.pnp.cjs") or vim.uv.fs_stat(root_dir .. "/.pnp.js") then
        cmd = vim.list_extend({ "yarn", "exec" }, cmd)
      end
    end
    return vim.lsp.rpc.start(cmd, dispatchers)
  end,
  filetypes = {
    "javascript",
    "javascript.jsx",
    "javascriptreact",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    if vim.fs.root(bufnr, DENO_MARKERS) then
      return
    end
    -- One server per project (monorepos included); the server finds each package's config
    local project_root = vim.fs.root(bufnr, PROJECT_MARKERS) or vim.fn.getcwd()
    if _uses_eslint(vim.api.nvim_buf_get_name(bufnr), project_root) then
      on_dir(project_root)
    end
  end,
  -- https://github.com/Microsoft/vscode-eslint#settings-options
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine"
      },
      showDocumentation = {
        enable = true
      }
    },
    codeActionOnSave = {
      enable = true,
      mode = "all"
    },
    -- Flat vs eslintrc is left to the installed ESLint version's default
    experimental = {},
    format = true,
    onIgnoredFiles = "off",
    quiet = false,
    rulesCustomizations = {},
    run = "onType",
    useESLintClass = false,
    validate = "on",
    packageManager = nil,
    problems = {
      shortenToSingleLine = false,
    },
    -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
    -- This path is relative to the workspace folder (root dir) of the server instance.
    nodePath = "",
    -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
    workingDirectory = { mode = "location" },
  },
  before_init = function(_, config)
    -- The "workspaceFolder" is a VSCode concept. It limits how far the
    -- server will traverse the file system when locating the ESLint config
    -- file (e.g., .eslintrc).
    if config.root_dir then
      config.settings = config.settings or {}
      config.settings.workspaceFolder = {
        uri = vim.uri_from_fname(config.root_dir),
        name = vim.fn.fnamemodify(config.root_dir, ":t"),
      }
    end
  end,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
      client:request_sync("workspace/executeCommand", {
        command = "eslint.applyAllFixes",
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = vim.lsp.util.buf_versions[bufnr],
          },
        },
      }, nil, bufnr)
    end, { desc = "Apply all ESLint fixes" })
  end,
  handlers = {
    ["eslint/openDoc"] = function(_, result)
      if result then
        vim.ui.open(result.url)
      end
      return {}
    end,
    ["eslint/confirmESLintExecution"] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("ESLint probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
    end,
  },
}

return M
