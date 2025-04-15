-- https://github.com/lukas-reineke/indent-blankline.nvim

vim.opt.list = true
-- vim.opt.listchars:append("space:⋅") -- view space as dot file
-- vim.opt.listchars:append("eol:↴")
-- local highlight = {
-- }
local exclude_ft = { "help", "git", "markdown", "snippets", "text", "gitconfig", "alpha", "dashboard", "buffer" }
require("ibl").setup {
  exclude = {
    filetypes = exclude_ft,
    buftypes = { "terminal", "nofile", "telescope", "bigfile" },
  },
  indent = {
    char = "│",
    smart_indent_cap = true,
  },
  scope = {
    enabled = true,
    -- show_start = true,
    -- show_end = true,
    show_exact_scope = true,
  }
}

local gid = vim.api.nvim_create_augroup("indent_blankline", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  group = gid,
  command = "IBLDisable",
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  group = gid,
  callback = function()
    if not vim.tbl_contains(exclude_ft, vim.bo.filetype) then
      vim.cmd([[IBLEnable]])
    end
  end,
})
