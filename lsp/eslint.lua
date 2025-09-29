local util = require('utils.lspconfig')
local M = {
  root_dir = function(fname)
    local root = util.root_pattern(
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
      "eslint.config.ts"
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
        return root
      elseif not util.path.exists(util.path.join(root, '.eslintrc')) then
        return nil
      end
    end

    return root
  end,
  cmd = {
    "vscode-eslint-language-server",
    "--stdio",
  },
  filetypes = {
    "javascript",
    "javascript.jsx",
    "javascriptreact",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
  },
  root_markers = {
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
  },
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
    experimental = {
      useFlatConfig = false,
    },
    dynamicRegistration = true,
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
  on_new_config = function(config, new_root_dir)
    -- The "workspaceFolder" is a VSCode concept. It limits how far the
    -- server will traverse the file system when locating the ESLint config
    -- file (e.g., .eslintrc).
    config.settings.workspaceFolder = {
      uri = new_root_dir,
      name = vim.fn.fnamemodify(new_root_dir, ":t"),
    }

    -- Support flat config
    if
        vim.fn.filereadable(new_root_dir .. "/eslint.config.js") == 1
        or vim.fn.filereadable(new_root_dir .. "/eslint.config.mjs") == 1
        or vim.fn.filereadable(new_root_dir .. "/eslint.config.cjs") == 1
        or vim.fn.filereadable(new_root_dir .. "/eslint.config.ts") == 1
        or vim.fn.filereadable(new_root_dir .. "/eslint.config.mts") == 1
        or vim.fn.filereadable(new_root_dir .. "/eslint.config.cts") == 1
    then
      config.settings.experimental.useFlatConfig = true
    end

    -- Support Yarn2 (PnP) projects
    local pnp_cjs = new_root_dir .. "/.pnp.cjs"
    local pnp_js = new_root_dir .. "/.pnp.js"
    if vim.loop.fs_stat(pnp_cjs) or vim.loop.fs_stat(pnp_js) then
      config.cmd = vim.list_extend({ "yarn", "exec" }, config.cmd)
    end
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

local on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end

M.on_attach = on_attach;

return M
