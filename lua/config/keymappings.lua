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
keymap("n", "<leader>e", "<cmd>Oil --float<CR>", { noremap = true, silent = true, desc = "File Explorer" })

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

keymap("n", "<leader>//", "<cmd>Dashboard<CR>", silent)
-- New file by CTRL-N
keymap("n", "<C-n>", "<cmd>AdvancedNewFile<CR>", silent)

keymap("n", "<leader>lt", ":Neotree reveal toggle<CR>",
  { desc = "toggle file tree", silent = true })
-- keymap("n", "<leader>ls", "<cmd>Trouble lsp_document_symbols toggle win.position=left focus=false<CR>",
keymap("n", "<leader>ls", "<cmd>Neotree document_symbols toggle<CR>",
  { desc = "Symbol Outline", silent = true })
-- fzflua
keymap("n", "<S-p>", "<CMD>lua require('fzf-lua').live_grep_resume()<CR>", { desc = "Search keywords", silent = true })
keymap("n", "<C-p>", "<CMD>lua require('fzf-lua').files()<CR>", { desc = "Search files", silent = true })
keymap("n", "<leader>sb", "<CMD>lua require('fzf-lua').buffers()<CR>", { desc = "Search buffers", silent = true })
keymap("n", "<leader>ss", "<CMD>lua require('fzf-lua').lsp_document_symbols()<CR>", { desc = "Search lsp_document_symbols", silent = true })
keymap("n", '<leader>s"', "<CMD>lua require('fzf-lua').registers()<CR>",
  { desc = "Show registers content", silent = true })
keymap("n", '<leader>sm', "<CMD>lua require('fzf-lua').marks()<CR>", { desc = "Show marks", silent = true })
keymap("n", '<leader>so', "<CMD>lua require('fzf-lua').oldfiles()<CR>", { desc = "Show recent files", silent = true })
-- Remove highlights
keymap("n", "<CR>", ":noh<CR><CR>", silent)

-- Buffers
-- keymap("n", "gn", ":bn<CR>", silent)
-- keymap("n", "gN", ":bp<CR>", silent)
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
-- keymap("n", "<Space>,", ":cp<CR>", silent)
-- keymap("n", "<Space>.", ":cn<CR>", silent)
-- Toggle quicklist
-- keymap("n", "<leader>q", "<cmd>lua require('utils').toggle_quicklist()<CR>", silent)

-- Manually invoke speeddating in case switch.vim didn't work
keymap("n", "<C-a>", ":if !switch#Switch() <bar> call speeddating#increment(v:count1) <bar> endif<CR>", silent)
keymap("n", "<C-x>", ":if !switch#Switch({'reverse': 0}) <bar> call speeddating#increment(-v:count1) <bar> endif<CR>",
  silent)

-- Open links under cursor in browser with gx
-- check if current nvim run in macos
if vim.fn.has('macunix') == 1 then
  keymap("n", "gx", "<cmd>silent execute '!open ' . shellescape('<cWORD>')<CR>", silent)
else
  keymap("n", "gx", "<cmd>silent execute '!xdg-open ' . shellescape('<cWORD>')<CR>", silent)
end

-- You can use use '<Plug>printer_print' to call the pluging inside more advanced keymaps
-- for example a keymap that always adds a prnt statement based on 'iw'
keymap("n", "gP", "<Plug>(printer_print)iw")
-- LSP
-- keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", silent)                               -- Replaced with Glance plugin
-- keymap("n", "gr", "<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<CR>", silent) -- Replaced with Glance plugin
keymap("n", "gy", "<cmd>FzfLua lsp_typedefs        jump_to_single_result=true ignore_current_line=true<cr>",
  { desc = "Goto Type Definition", silent = true })
keymap("n", "gI", "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>",
  { desc = "Goto Implementation", silent = true })
keymap("n", "gd", "<cmd>FzfLua lsp_definitions     jump_to_single_result=true ignore_current_line=true<cr>",
  { desc = "Goto Definition", silent = true })
keymap("n", "gr", "<cmd>FzfLua lsp_references      jump_to_single_result=true ignore_current_line=true<cr>",
  { desc = "References", nowait = true, silent = true })
keymap("n", "<C-Space>", vim.lsp.codelens.run, { desc = "Run CodeLens", silent = true })
keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("v", "<leader>ca", "<cmd>'<,'>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("n", "<leader>ce", "<cmd>TSC<CR>", { desc = "workspace error", silent = true })
keymap("n", "<leader>cd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
  { desc = "current file diagnostics", silent = true })
keymap("n", "<leader>cD", function()
  for _, client in pairs(vim.lsp.buf_get_clients()) do
    require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
  end

  vim.defer_fn(function()
    require("trouble").open({ mode = "diagnostics" })
  end, 1000)
end, { desc = "workspace diagnostics" })
-- refactor symbol
-- keymap("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", silent)
keymap("n", "<leader>cr", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { desc = "Refactor Symbol", expr = true, silent = true })
keymap("n", "<leader>cl", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>", silent)
keymap("n", "<leader>ch", "<cmd>lua vim.lsp.buf.signature_help()<CR>", silent)
keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next({ float = { border = 'rounded', max_width = 100 }})<CR>", silent)
keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev({ float = { border = 'rounded', max_width = 100 }})<CR>", silent)
keymap("n", "K", function()
  -- Use custom wrapper around MacOS dictionary as keyword look-up
  if vim.bo.filetype == "markdown" then
    local word = vim.fn.expand("<cword>"):gsub("[^%w%s-]", "")
    local success, _ = pcall(vim.fn.system, "open dict://" .. word)
    if not success then
      vim.notify("Dictionary lookup failed", vim.log.levels.WARN)
    end
    return
  end

  local ufo = require('ufo')
  local peek_window = ufo.peekFoldedLinesUnderCursor()
  if not peek_window then
    vim.lsp.buf.hover()
  end
end)
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

-- Markdown
keymap('n', '<leader>mp', '<cmd>PasteImage<CR>', { desc = 'Paste Image in to Makrdown buffer', silent = true })
-- Obsidian
keymap("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", { desc = "Obsidian Template", silent = true })
keymap("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create New Note", silent = true })
keymap("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "View Backlinks", silent = true })
keymap("n", "<leader>oc", "<cmd>ObsidianToggleCheckbox<CR>", { desc = "ObsidianToggleCheckbox", silent = true })
keymap("v", "<leader>oc", "<cmd>ObsidianExtractNote<CR>", { desc = "Extract text to new note", silent = true })
keymap("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "View Links", silent = true })
keymap("n", "<leader>oT", "<cmd>ObsidianTags<CR>", { desc = "Searching for Tags in Vault", silent = true })
-- based64
keymap('v', '<leader>b', '<cmd>lua require("b64").encode()<cr>', { desc = "Base64 Encode", silent = true })
keymap('v', '<leader>B', '<cmd>lua require("b64").decode()<cr>', silent)
-- Snacks.lazygit
keymap('n', '<leader>gg', '<cmd>lua Snacks.lazygit()<cr>', silent)
-- -- recommended mappings
-- -- Todo Comments
-- keymap("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
-- keymap("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
-- split
keymap('n', '<leader>v', '<C-w>v', { desc = '<cmd>split right<CR>', silent = true })
keymap('n', '<leader>V', '<C-w>s', { desc = '<cmd>split below<CR>', silent = true })
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
keymap('n', '<leader><leader>h', require('smart-splits').swap_buf_left, { desc = 'Swap buffer with left window' })
keymap('n', '<leader><leader>j', require('smart-splits').swap_buf_down, { desc = 'Swap buffer with down window' })
keymap('n', '<leader><leader>k', require('smart-splits').swap_buf_up, { desc = 'Swap buffer with up window' })
keymap('n', '<leader><leader>l', require('smart-splits').swap_buf_right, { desc = 'Swap buffer with right window' })
-- url-open
-- keymap("n", "gx", "<esc>:URLOpenUnderCursor<cr>", { desc = "Open URL under cursor in browser", silent = true })

-- AI
-- CodeCompanion
keymap('n', '<leader>aa', '<cmd>CodeCompanion /context_file<CR>', { desc = 'AI Chat With Context', silent = true })
keymap('n', '<leader>ac', '<cmd>CodeCompanionChat<CR>', { desc = 'AI Empty Chat Panel', silent = true })
keymap('n', '<leader>aq', '<cmd>CodeCompanion<CR>', { desc = 'AI Inline Quickchat', silent = true })
keymap('v', '<leader>aq', '<cmd>CodeCompanion<CR>', { desc = 'AI Inline Quickchat', silent = true })
keymap('n', '<leader>ap', '<cmd>CodeCompanionActions<CR>', { desc = 'AI Actions Selected', silent = true })
keymap('v', '<leader>ap', '<cmd>CodeCompanionActions<CR>', { desc = 'AI Actions Selected', silent = true })
keymap('v', '<leader>ad', '<cmd>CodeCompanionChat Add<CR>', { desc = 'AI Chat Add Selected', silent = true })
-- Security
-- Ecolog
keymap('n', '<leader>cp', '<cmd>EcologShelterToggle<CR>', { desc = 'Peek Mask Variable', silent = true })
