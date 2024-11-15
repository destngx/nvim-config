vim.opt.softtabstop=2
vim.opt.tabstop=2
vim.opt.shiftwidth=2
-- Use custom wrapper around MacOS dictionary as keyword look-up
-- vim.opt.keywordprg=open-dict
-- vim.opt.listchars:append("space: ") -- view space as dot file

vim.keymap.set("n", "j", "<Down>")
vim.keymap.set("n", "k", "<Up>")
vim.keymap.set("n", "K", ":!open-dict <C-R><C-W><CR>", { noremap = true, silent = true })

