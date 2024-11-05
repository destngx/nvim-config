-- Auto sync plugins on save of plugins.lua
vim.api.nvim_create_autocmd("BufWritePost", { pattern = "plugins.lua", command = "source <afile> | PackerSync" })
-- Disable tabline
vim.api.nvim_create_autocmd("BufWinEnter", {
  command = "set showtabline=0"
})
-- desc = "jump to the last position when reopening a file",
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  command = [[ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]],
})
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost",
  { callback = function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 }) end })
-- Disable diagnostics in node_modules (0 is current buffer only)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" },
  { pattern = "*/node_modules/*", command = "lua vim.diagnostic.disable(0)" })
-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md", "*.tex" },
  command = "setlocal spell"
})
-- Set indent same level when crate list in markdown
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.md" },
  command = "set indentexpr="
})
-- Show `` in specific files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md", "*.json" },
  command = "setlocal conceallevel=2"
})
-- disable cinnamon for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"help", "lazy", "Oil", "NvimTree", "dashboard", "packer", "startify", "fzf", "fugitive", "spectre_panel"},
    callback = function() vim.b.cinnamon_disable = true end,
})
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
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

-- ╭──────────────────────────────────────────────────────────╮
-- │ Hide tabline and statusline on startup screen            │
-- ╰──────────────────────────────────────────────────────────╯
-- vim.api.nvim_create_augroup("dashboard_tabline", { clear = true })
--
-- vim.api.nvim_create_autocmd("FileType", {
--   group = "dashboard_tabline",
--   pattern = "dashboard",
--   command = "set showtabline=0 laststatus=0 noruler",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   group = "dashboard_tabline",
--   pattern = "dashboard",
--   callback = function()
--     vim.api.nvim_create_autocmd("BufUnload", {
--       group = "dashboard_tabline",
--       buffer = 0,
--       command = "set showtabline=2 ruler laststatus=3",
--     })
--   end,
-- })
-- Attach specific keybindings in which-key for specific filetypes
-- local present, _ = pcall(require, "which-key")
-- if not present then return end
-- local _, pwk = pcall(require, "plugins.which-key")
--
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = "*.md",
--   callback = function()
--     pwk.attach_markdown(0)
--   end
-- })
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.ts", "*.tsx" },
--   callback = function() pwk.attach_typescript(0) end
-- })
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "package.json" },
--   callback = function() pwk.attach_npm(0) end
-- })
-- vim.api.nvim_create_autocmd("FileType",
--   {
--     pattern = "*",
--     callback = function()
--       if DestNgxVim.plugins.zen.enabled and vim.bo.filetype ~= "alpha" then
--         pwk.attach_zen(0)
--       end
--     end
--   })
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*test.js", "*test.ts", "*test.tsx" },
--   callback = function() pwk.attach_jest(0) end
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "spectre_panel",
--   callback = function() pwk.attach_spectre(0) end
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "NvimTree",
--   callback = function() pwk.attach_nvim_tree(0) end
-- })
