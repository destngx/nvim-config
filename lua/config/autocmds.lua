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
-- local autosave = require('autosave')
-- autosave.hook_after_saving = function()
--   if vim.bo.filetype == "codecompanion" then
--     return
--   end
  -- require("lint").try_lint()
  -- vim.notify("Try Auto Linting", vim.log.levels.INFO, { title = "Lint" })
-- end
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

-- Auto-save on focus lost
autocmd("FocusLost", {
  pattern = "*",
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.cmd("silent! update")
    end
  end,
  desc = "Auto-save on focus lost"
})

-- Disable matchup for certain filetypes to prevent treesitter query errors
autocmd("FileType", {
  pattern = { "latex", "tex", "terraform", "hcl" },
  callback = function()
    vim.b.matchup_matchparen_enabled = 0
  end,
  desc = "Disable matchup for problematic filetypes"
})

local function restart_treesitter(bufnr)
  if not vim.treesitter then
    return
  end

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  pcall(vim.treesitter.stop, bufnr)
  pcall(vim.treesitter.start, bufnr)
end

local function hard_reload_current_buffer()
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  local buftype = vim.bo[bufnr].buftype

  if name == "" or buftype ~= "" then
    pcall(vim.cmd, "edit!")
    return
  end

  -- Save view before reloading
  local view = vim.fn.winsaveview()
  
  -- Use safer :edit! instead of buffer deletion to avoid crashes
  -- especially when buffer was opened via pickers like FzfLua
  local ok, err = pcall(vim.cmd, "edit! " .. vim.fn.fnameescape(name))
  
  if not ok then
    -- Fallback: try alternative reload method
    pcall(vim.cmd, "silent! checktime")
    vim.notify(
      string.format("Warning: Could not reload buffer: %s", err),
      vim.log.levels.WARN,
      { title = "File Reload" }
    )
    return
  end

  -- Restore view
  pcall(vim.fn.winrestview, view)
end

local function refresh_syntax_and_highlights(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  pcall(vim.cmd, "silent! filetype detect")
  restart_treesitter(bufnr)
  pcall(vim.cmd, "silent! syntax sync fromstart")
  pcall(vim.cmd, "redraw!")
end

-- Handle external file changes by auto-reloading
autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    -- Defer handling to avoid conflicts with pickers/floating windows
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()
      
      -- Safety check: ensure buffer is still valid
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      
      local filename = vim.fn.expand("%:t")
      local fullpath = vim.fn.expand("%:p")
      local modified = vim.bo[bufnr].modified
      local buftype = vim.bo[bufnr].buftype
      
      -- Skip special buffers (fzf, terminal, etc.)
      if buftype ~= "" then
        return
      end
      
      if modified then
        -- Buffer has unsaved changes - show warning and keep local version
        vim.notify(
          string.format(
            "Warning: %s changed externally but has unsaved local changes. Keeping local version.\nUse :e! to reload from disk.",
            filename
          ),
          vim.log.levels.WARN,
          { title = "File Changed" }
        )
      else
        -- Auto-reload without prompting for unmodified buffers
        local ok = pcall(function()
          hard_reload_current_buffer()
          local current_bufnr = vim.api.nvim_get_current_buf()
          refresh_syntax_and_highlights(current_bufnr)
          vim.notify(
            string.format("Auto-reloaded: %s", filename),
            vim.log.levels.INFO,
            { title = "File Changed" }
          )
        end)
        
        if not ok then
          -- Silent fallback if reload fails
          pcall(vim.cmd, "silent! checktime")
        end
      end
    end)
  end,
  desc = "Auto-reload external file changes"
})

-- Check for file changes when focus gained
autocmd("FocusGained", {
  pattern = "*",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
  desc = "Check for file changes when focus gained"
})

-- Check for file changes after shell command
autocmd("ShellCmdPost", {
  pattern = "*",
  callback = function()
    vim.cmd("checktime")
  end,
  desc = "Check for file changes after shell command"
})

-- Auto-create directories when saving file
autocmd("BufWritePre", {
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto-create directories"
})

-- Auto-resize windows when vim is resized
autocmd("VimResized", {
  callback = function()
    vim.cmd("wincmd =")
  end,
  desc = "Auto-resize windows"
})

