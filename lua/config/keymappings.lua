local keymap = vim.keymap.set
local silent = { silent = true }

-- Save key strokes (now we do not need to press shift to enter command mode).
keymap({ "n", "x" }, ";", ":")

-- Turn the word under cursor to upper case
keymap("i", "<c-u>", "<Esc>viwUea")

-- Turn the current word into title case
keymap("i", "<c-t>", "<Esc>b~lea")

-- Shortcut for faster save and quit
keymap("n", "<leader>w", "<cmd>update<cr>", { silent = true, desc = "save buffer" })

-- Saves the file if modified and quit
keymap("n", "<leader>q", "<cmd>x<cr>", { silent = true, desc = "quit current window" })

-- Quit all opened buffers
keymap("n", "<leader>Q", "<cmd>qa!<cr>", { silent = true, desc = "quit nvim" })

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
keymap("n", "<leader>P", "m`o<ESC>p``", { desc = "paste below current line" })
-- keymap("n", "<leader>P", "m`O<ESC>p``", { desc = "paste above current line" })

-- Better window movement
keymap("n", "<C-h>", "<C-w>h", silent)
keymap("n", "<C-j>", "<C-w>j", silent)
keymap("n", "<C-k>", "<C-w>k", silent)
keymap("n", "<C-l>", "<C-w>l", silent)

---- Go to start or end of line easier
keymap({ "n", "x" }, "H", "^")
keymap({ "n", "x" }, "L", "g_")
-- Go to the beginning and end of current line in insert mode quickly
keymap("i", "<C-A>", "<HOME>")
keymap("i", "<C-E>", "<END>")
-- Go to beginning of command in command-line mode
keymap("c", "<C-A>", "<HOME>")
-- Do not move my cursor when joining lines.
keymap("n", "J", "", {
  desc = "join line",
  callback = function()
    vim.cmd([[
      normal! mzJ`z
      delmarks z
    ]])
  end,
})

-- Move selected line / block of text in visual mode
keymap("x", "J", ":move '>+1<CR>gv-gv", silent)
keymap("x", "K", ":move '<-2<CR>gv-gv", silent)

-- Always use very magic mode for searching
keymap("n", "/", [[/\v]])

-- insert semicolon in the end
keymap("i", "<A-;>", "<Esc>miA;<Esc>`ii")

-- Keep visual mode indenting
keymap("v", "<", "<gv", silent)
keymap("v", ">", ">gv", silent)

-- Case change in visual mode
keymap("v", "`", "u", silent)
keymap("v", "<A-`>", "U", silent)

-- Save file by CTRL-S
keymap("n", "<C-s>", ":w<CR>", silent)
keymap("i", "<C-s>", "<ESC> :w<CR>", silent)

-- Telescope
keymap("n", "<C-p>", "<CMD>lua require('plugins.telescope').project_files()<CR>")
keymap("n", "<S-p>", "<CMD>lua require('plugins.telescope.pickers.multi-rg')()<CR>")

-- Remove highlights
keymap("n", "<CR>", ":noh<CR><CR>", silent)

-- Find word/file across project
keymap("n", "<Leader>pf",
  "<CMD>lua require('plugins.telescope').project_files({ default_text = vim.fn.expand('<cword>'), initial_mode = 'normal' })<CR>")
keymap("n", "<Leader>pw", "<CMD>lua require('telescope.builtin').grep_string({ initial_mode = 'normal' })<CR>")

-- Buffers
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", silent)
keymap("n", "gn", ":bn<CR>", silent)
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", silent)
keymap("n", "gp", ":bp<CR>", silent)
keymap("n", "<S-q>", ":lua require('mini.bufremove').delete(0, false)<CR>", silent)

-- Move between bufferline buffers
keymap("n", "<Space>1", ":BufferLineGoToBuffer 1<CR>", silent)
keymap("n", "<Space>2", ":BufferLineGoToBuffer 2<CR>", silent)
keymap("n", "<Space>3", ":BufferLineGoToBuffer 3<CR>", silent)
keymap("n", "<Space>4", ":BufferLineGoToBuffer 4<CR>", silent)
keymap("n", "<Space>5", ":BufferLineGoToBuffer 5<CR>", silent)
keymap("n", "<Space>6", ":BufferLineGoToBuffer 6<CR>", silent)
keymap("n", "<Space>7", ":BufferLineGoToBuffer 7<CR>", silent)
keymap("n", "<Space>8", ":BufferLineGoToBuffer 8<CR>", silent)
keymap("n", "<Space>9", ":BufferLineGoToBuffer 9<CR>", silent)
keymap("n", "<A-1>", ":BufferLineGoToBuffer 1<CR>", silent)
keymap("n", "<A-2>", ":BufferLineGoToBuffer 2<CR>", silent)
keymap("n", "<A-3>", ":BufferLineGoToBuffer 3<CR>", silent)
keymap("n", "<A-4>", ":BufferLineGoToBuffer 4<CR>", silent)
keymap("n", "<A-5>", ":BufferLineGoToBuffer 5<CR>", silent)
keymap("n", "<A-6>", ":BufferLineGoToBuffer 6<CR>", silent)
keymap("n", "<A-7>", ":BufferLineGoToBuffer 7<CR>", silent)
keymap("n", "<A-8>", ":BufferLineGoToBuffer 8<CR>", silent)
keymap("n", "<A-9>", ":BufferLineGoToBuffer 9<CR>", silent)
-- Don't yank on delete char
keymap("n", "x", '"_x', silent)
keymap("n", "X", '"_X', silent)
keymap("v", "x", '"_x', silent)
keymap("v", "X", '"_X', silent)

-- Don't yank on visual paste
keymap("v", "p", '"_dP', silent)

-- Copy entire buffer.
keymap("n", "<leader>y", "<cmd>%yank<cr>", { desc = "yank entire buffer" })

-- Avoid issues because of remapping <c-a> and <c-x> below
vim.cmd([[
  nnoremap <Plug>SpeedDatingFallbackUp <c-a>
  nnoremap <Plug>SpeedDatingFallbackDown <c-x>
]])

-- Quickfix
keymap("n", "<Space>,", ":cp<CR>", silent)
keymap("n", "<Space>.", ":cn<CR>", silent)

-- Toggle quicklist
-- keymap("n", "<leader>q", "<cmd>lua require('utils').toggle_quicklist()<CR>", silent)

-- Manually invoke speeddating in case switch.vim didn't work
keymap("n", "<C-a>", ":if !switch#Switch() <bar> call speeddating#increment(v:count1) <bar> endif<CR>", silent)
keymap("n", "<C-x>", ":if !switch#Switch({'reverse': 1}) <bar> call speeddating#increment(-v:count1) <bar> endif<CR>",
  silent)

-- Open links under cursor in browser with gx
if vim.fn.has('macunix') == 1 then
  keymap("n", "gx", "<cmd>silent execute '!open ' . shellescape('<cWORD>')<CR>", silent)
else
  keymap("n", "gx", "<cmd>silent execute '!xdg-open ' . shellescape('<cWORD>')<CR>", silent)
end

-- Refactor with spectre
keymap("n", "<Leader>pr", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", silent)
keymap("v", "<Leader>pr", "<cmd>lua require('spectre').open_visual()<CR>")

-- LSP
-- keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", silent)
-- keymap("n", "gr", "<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<CR>", silent)
keymap("n", "<C-Space>", "<cmd>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("v", "<leader>ca", "<cmd>'<,'>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", silent)
keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", silent)
keymap("v", "<leader>cf", function()
  local start_row, _ = table.unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, _ = table.unpack(vim.api.nvim_buf_get_mark(0, ">"))

  vim.lsp.buf.format({
    range = {
      ["start"] = { start_row, 0 },
      ["end"] = { end_row, 0 },
    },
    async = true,
  })
end, silent)
keymap("n", "<leader>cl", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>", silent)
keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>", silent)
keymap("n", "cL", "<cmd>lua vim.lsp.buf.signature_help()<CR>", silent)
keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next({ float = { border = 'rounded', max_width = 100 }})<CR>", silent)
keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev({ float = { border = 'rounded', max_width = 100 }})<CR>", silent)
keymap("n", "K", function()
  local winid = require('ufo').peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end)

-- Comment Box
keymap("n", "<leader>ac", "<cmd>lua require('comment-box').lbox()<CR>", silent)
keymap("v", "<leader>ac", "<cmd>lua require('comment-box').lbox()<CR>", silent)
