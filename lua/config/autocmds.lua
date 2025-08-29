local autocmd = vim.api.nvim_create_autocmd

-- Auto sync plugins on save of plugins.lua
-- autocmd("BufWritePost", {
--   pattern = { "plugins.lua", "plugins/*/*.lua", "plugins/*.lua" },
--   command = "source <afile> | Lazy sync"
-- })
-- Disable tabline
-- autocmd("BufWinEnter", {
--   command = "set showtabline=0"
-- })
-- Use fzf-lua for vim.ui.select
-- BufWinEnter will slow at first time, but it's fine
-- autocmd("VimEnter", {
--   callback = function()
--     -- run after 200ms
--     vim.defer_fn(function()
--       require("fzf-lua").register_ui_select({}, true)
--     end, 200)
--   end,
-- })

-- auto lint on save
local autosave = require('autosave')
autosave.hook_after_saving = function()
  if vim.bo.filetype == "codecompanion" then
    return
  end
  require("lint").try_lint()
  vim.notify("Try Auto Linting", vim.log.levels.INFO, { title = "Lint" })
end
-- desc = "jump to the last position when reopening a file",
autocmd("BufWinEnter", {
  pattern = "*",
  command = [[ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]],
})
-- Highlight on yank
autocmd("TextYankPost",
  { callback = function() vim.hl.on_yank({ higroup = 'IncSearch', timeout = 100 }) end })
-- Disable diagnostics in node_modules (0 is current buffer only)
autocmd({ "BufRead", "BufNewFile" },
  { pattern = "*/node_modules/*", command = "lua vim.diagnostic.disable(0)" })
-- Enable spell checking for certain file types
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md", "*.tex" },
  command = "setlocal spell"
})
-- Set indent same level when crate list in markdown
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.md" },
  command = "set indentexpr="
})
-- Show `` in specific files
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md", "*.json" },
  command = "setlocal conceallevel=2"
})
-- disable cinnamon for specific filetypes
-- autocmd("FileType", {
--   pattern = { "help", "lazy", "Oil", "neo-tree", "dashboard", "packer", "startify", "fzf", "fugitive", "spectre_panel" },
--   callback = function() vim.b.cinnamon_disable = true end,
-- })

autocmd("InsertEnter", {
  callback = function()
    vim.g.snacks_scroll = false
  end,
})

autocmd("InsertLeave", {
  callback = function()
    vim.g.snacks_scroll = true
  end,
})
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "Oil",
    "grug-far",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns.blame",
    "codecompanion",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})

autocmd("BufEnter", {
  pattern = "CodeCompanion",
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false

    -- Get current filetype and set it to markdown if the current filetype is copilot-chat
    vim.bo.filetype = "markdown"
  end,
})

