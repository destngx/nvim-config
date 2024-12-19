local keymap = vim.keymap.set
local silent = { silent = true }
-- Save key strokes (now we do not need to press shift to enter command mode).
keymap({ "n", "x" }, ";", ":")

-- Turn the word under cursor to upper case
keymap("i", "<c-u>", "<Esc>viwUea")

-- disable the Q command
keymap("n", "Q", "<nop>")
-- Turn the current word into title case
keymap("i", "<c-t>", "<Esc>b~lea")

-- Open Oil
keymap("n", "<leader>e", "<cmd>Oil --float<CR>", { noremap = true, silent = true })

-- Shortcut for faster save
keymap("n", "<c-s>", "<cmd>update<cr>", { silent = true, desc = "save current buffer" })

-- Saves the file if modified and quit
keymap("n", "<leader>q", "<cmd>x<cr>", { silent = true, desc = "quit current window" })

-- Quit all opened buffers
keymap("n", "<leader>Q", "<cmd>qa!<cr>", { silent = true, desc = "quit nvim" })

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
-- keymap("n", "<leader>P", "m`o<ESC>p``", { desc = "paste below current line and keep cursor position" })
-- keymap("n", "<leader>P", "m`O<ESC>p``", { desc = "paste above current line" })

-- Center the screen on the next/prev search result with n/N
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

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

keymap("n", "<leader>z", "<cmd>ZenMode<CR>", silent)
keymap("n", "<leader>//", "<cmd>Dashboard<CR>", silent)
-- New file by CTRL-N
keymap("n", "<C-n>", "<cmd>AdvancedNewFile<CR>", silent)

keymap("n", "<leader>lt", "<cmd>lua require('nvim-tree.api').tree.toggle()<CR>", { desc = "toggle file tree" }, silent)
keymap("n", "<leader>ls", "<cmd>Trouble lsp_document_symbols toggle win.position=left focus=false<CR>",
  { desc = "Symbol Outline" }, silent)
-- fzflua
keymap("n", "<S-p>", "<CMD>lua require('fzf-lua').live_grep_resume()<CR>")
keymap("n", "<C-p>", "<CMD>lua require('fzf-lua').files()<CR>")
keymap("n", "<C-b>", "<CMD>lua require('fzf-lua').buffers()<CR>")
keymap("n", '""', "<CMD>lua require('fzf-lua').registers()<CR>")
-- vim.keymap.set({ "n" }, "<F0>", function()
--   fzf.help_tags()
-- end, { desc = "fzf help tags" })
-- vim.keymap.set({ "n" }, '""', function()
--   fzf.registers()
-- end, { desc = "fzf show registers content" })
-- vim.keymap.set({ "n" }, "<leader>gB", function()
--   fzf.git_branches()
-- end, { desc = "fzf git branches" })
-- vim.api.nvim_create_user_command("Autocmd", function()
--   fzf.autocmds()
-- end, { desc = "fzf autocmds list" })
-- vim.api.nvim_create_user_command("Maps", function()
--   fzf.keymaps()
-- end, { desc = "fzf maps list" })
-- vim.api.nvim_create_user_command("Highlights", function()
--   fzf.highlights()
-- end, { desc = "fzf highlights list" })
-- Remove highlights
keymap("n", "<CR>", ":noh<CR><CR>", silent)

-- Find word/file across project
-- keymap("n", "<Leader>pf",
--  "<CMD>lua require('plugins.telescope').project_files({ default_text = vim.fn.expand('<cword>'), initial_mode = 'normal' })<CR>")
-- keymap("n", "<Leader>pw", "<CMD>lua require('telescope.builtin').grep_string({ initial_mode = 'normal' })<CR>")

-- Buffers
-- keymap("n", "<leader>;", "<cmd>Telescope grapple tags<CR>", silent)
keymap("n", "gn", ":bn<CR>", silent)
keymap("n", "gN", ":bp<CR>", silent)
-- keymap("n", "<S-q>", ":lua require('mini.bufremove').delete(0, false)<CR>", silent)

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
-- keymap("n", "<C-x>", ":if !switch#Switch({'reverse': 1}) <bar> call speeddating#increment(-v:count1) <bar> endif<CR>",
--  silent)

-- Open links under cursor in browser with gx
if vim.fn.has('macunix') == 1 then
  keymap("n", "gx", "<cmd>silent execute '!open ' . shellescape('<cWORD>')<CR>", silent)
else
  keymap("n", "gx", "<cmd>silent execute '!xdg-open ' . shellescape('<cWORD>')<CR>", silent)
end

-- You can use use '<Plug>printer_print' to call the pluging inside more advanced keymaps
-- for example a keymap that always adds a prnt statement based on 'iw'
keymap("n", "gP", "<Plug>(printer_print)iw")
-- LSP
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", silent)                               -- Replaced with Glance plugin
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<CR>", silent) -- Replaced with Glance plugin
keymap("n", "<C-Space>", "<cmd>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("v", "<leader>ca", "<cmd>'<,'>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("n", "<leader>ce", "<cmd>TSC<CR>", { desc = "workspace error" }, silent)
keymap("n", "<leader>cF", "<cmd>TSToolsFixAll<CR>", { desc = "fix all" }, silent)
keymap("n", "<leader>ci", "<cmd>TSToolsAddMissingImports<CR>", { desc = "Typescript add missing import" }, silent)
keymap("n", "<leader>co", "<cmd>TSToolsOrganizeImports<CR>", { desc = "Typescript organize import" }, silent)
keymap("n", "<leader>cs", "<cmd>TSToolsSortImports<CR>", { desc = "Typescript sort import" }, silent)
keymap("n", "<leader>cu", "<cmd>TSToolsRemoveUnused<CR>", { desc = "Typescript remove unused import" }, silent)
keymap("n", "<leader>cd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "current file diagnostics" },
  silent)
keymap("n", "<leader>cD", "<cmd>Trouble diagnostics toggle<CR>", { desc = "workspace diagnostics" }, silent)
keymap("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", silent)
-- lint
keymap("n", "<leader>cL", function()
  require("lint").try_lint()
end, { desc = "lint file" })
keymap({ "n" }, "<leader>cf", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = "format file" })

keymap({ "v" }, "<leader>cf", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = "format selection" })


-- normal mode format using conform <leader>cf
-- keymap("v", "<leader>cf", function()
--   local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
--   local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
--
--   vim.lsp.buf.format({
--     range = {
--       ["start"] = { start_row, 0 },
--       ["end"] = { end_row, 0 },
--     },
--     async = true,
--   })
-- end, silent)
keymap("n", "<leader>cl", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>", silent)
keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>", silent)
-- keymap("n", "L", "<cmd>lua vim.lsp.buf.signature_help()<CR>", silent)
keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next({ float = { border = 'rounded', max_width = 100 }})<CR>", silent)
keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev({ float = { border = 'rounded', max_width = 100 }})<CR>", silent)
keymap("n", "K", function()
  local winid = require('ufo').peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end)

-- Obsidian
keymap("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", { desc = "Obsidian Template" }, silent)
keymap("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create New Note" }, silent)
keymap("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "View Backlinks" }, silent)
keymap("n", "<leader>oc", "<cmd>ObsidianToggleCheckbox<CR>", { desc = "ObsidianToggleCheckbox" }, silent)
keymap("v", "<leader>oc", "<cmd>ObsidianExtractNote<CR>", { desc = "Extract text to new note" }, silent)
keymap("v", "<leader>ol", "<cmd>ObsidianExtractNote<CR>", { desc = "View Links" }, silent)
keymap("v", "<leader>ost", "<cmd>ObsidianTags<CR>", { desc = "Searching for Tags in Vault" }, silent)
-- based64
keymap('v', '<leader>b', '<cmd>lua require("b64").encode()<cr>', silent)
keymap('v', '<leader>B', '<cmd>lua require("b64").decode()<cr>', silent)

-- recommended mappings
-- Todo Comments
keymap("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
keymap("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
-- split
keymap('n', '<leader>v', '<C-w>v', { desc = '<cmd>split right<CR>' }, silent)
keymap('n', '<leader>V', '<C-w>s', { desc = '<cmd>split below<CR>' }, silent)
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
-- keymap('n', '<A-h>', require('smart-splits').resize_left)
-- keymap('n', '<A-j>', require('smart-splits').resize_down)
-- keymap('n', '<A-k>', require('smart-splits').resize_up)
-- keymap('n', '<A-l>', require('smart-splits').resize_right)
-- moving between splits
keymap('n', '<C-h>', require('smart-splits').move_cursor_left)
keymap('n', '<C-j>', require('smart-splits').move_cursor_down)
keymap('n', '<C-k>', require('smart-splits').move_cursor_up)
keymap('n', '<C-l>', require('smart-splits').move_cursor_right)
-- keymap('n', '<C-\\>', require('smart-splits').move_cursor_previous)
-- swapping buffers between windows
keymap('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
keymap('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
keymap('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
keymap('n', '<leader><leader>l', require('smart-splits').swap_buf_right)
keymap('n', '<C-;>', '<cmd>lua require("smart-splits").move_cursor_bottom()<CR>', { noremap = true, silent = true })
-- url-open
keymap("n", "gx", "<esc>:URLOpenUnderCursor<cr>")
-- markdown
keymap('n', '<leader>mp', '<cmd>PasteImage<CR>', { desc = 'Paste Image in to Makrdown buffer' }, silent)
keymap('n', '<leader>mv', '<cmd>MarkdownPreview<CR>', { desc = 'Preview Makrdown in browser' }, silent)
-- AI
-- CodeCompanion

keymap('n', '<leader>aa', '<cmd>CodeCompanionChat<CR>', { desc = 'AI Chat Panel Open' }, silent)
keymap('n', '<leader>aq', '<cmd>CodeCompanion<CR>', { desc = 'AI Inline Quickchat' }, silent)
keymap('v', '<leader>aq', '<cmd>CodeCompanion<CR>', { desc = 'AI Inline Quickchat' }, silent)
keymap('n', '<leader>ap', '<cmd>CodeCompanionActions<CR>', { desc = 'AI Actions Selected' }, silent)
keymap('v', '<leader>ap', '<cmd>CodeCompanionActions<CR>', { desc = 'AI Actions Selected' }, silent)
keymap('v', '<leader>ad', '<cmd>CodeCompanionChat Add<CR>', { desc = 'AI Chat Add Selected' }, silent)
