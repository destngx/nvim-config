local sqlite_job_id
local sqlite_job_done = false
local sqlite_job_error
local sqlite_enabled = vim.fn.executable("nix") == 1

if sqlite_enabled then
  vim.schedule(function()
    sqlite_job_id = vim.fn.jobstart({
      "nix",
      "eval",
      "--raw",
      "nixpkgs#sqlite.out.outPath",
      "--apply",
      'p: p + "/lib/libsqlite3.dylib"',
    }, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        local sqlite_path = data and data[1]
        if sqlite_path and sqlite_path ~= "" then
          vim.g.sqlite_clib_path = sqlite_path
        end
      end,
      on_stderr = function(_, data)
        local message = data and table.concat(data, "\n")
        if message and message ~= "" then
          sqlite_job_error = message
        end
      end,
      on_exit = function(_, exit_code)
        sqlite_job_done = true
        if exit_code ~= 0 then
          sqlite_job_error = sqlite_job_error or "nix eval failed"
        end
      end,
    })
  end)
end

vim.g.wait_for_sqlite_clib_path = function()
  if not sqlite_enabled then
    return
  end
  if not sqlite_job_done and sqlite_job_id and sqlite_job_id > 0 then
    vim.wait(30000, function()
      return sqlite_job_done
    end, 10)
  end
  if not vim.g.sqlite_clib_path then
    error(sqlite_job_error or "Could not resolve the Nix SQLite library path")
  end
end

local options = {
  clipboard      = "unnamed,unnamedplus",   --- Copy-paste between vim and everything else
  cmdheight      = 0,                       --- Give more space for displaying messages
  completeopt    = "menu,menuone,noselect", --- Better autocompletion
  cursorline     = true,                    --- Highlight of current line
  emoji          = false,                   --- Fix emoji display
  expandtab      = true,                    --- Use spaces instead of tabs
  foldcolumn     = "0",
  foldnestmax    = 0,
  foldlevel      = 99,                 --- Using ufo provider need a large value
  foldlevelstart = 99,                 --- Expand all folds by default
  ignorecase     = true,               --- Needed for smartcase
  laststatus     = 3,                  --- Have a global statusline at the bottom instead of one for each window
  mouse          = "a",                --- Enable mouse
  number         = true,               --- Shows current line number
  pumheight      = 15,                 --- Max num of items in completion menu
  pumwidth       = 30,                 --- Min width of completion menu
  pumblend       = 10,                 --- Transparency of completion menu
  relativenumber = true,               --- Enables relative number
  scrolloff      = 8,                  --- Always keep space when scrolling to bottom/top edge
  sidescrolloff  = 8,                  --- Always keep space when scrolling to left/right edge
  showtabline    = 0,                  --- Always show tabs
  signcolumn     = "yes:2",            --- Add extra sign column next to line number
  smartcase      = true,               --- Uses case in search
  smartindent    = true,               --- Makes indenting smart
  smarttab       = false,              --- Makes tabbing smarter will realize you have 2 vs 4
  -- autoload       = true,                    --- Autoload buffer
  splitright     = true,               --- Vertical splits will automatically be to the right
  splitbelow     = true,               --- Horizontal splits will automatically be below
  splitkeep      = "screen",           --- Keep screen position when opening splits
  autoread       = true,               --- autoreaad buffer
  swapfile       = false,              --- Swap not needed
  tabstop        = 2,                  --- Insert 2 spaces for a tab
  softtabstop    = 2,                  --- Insert 2 spaces for a tab
  shiftwidth     = 2,                  --- Change a number of space characters inserted for indentation
  termguicolors  = true,               --- Correct terminal colors
  winblend       = 0,                  --- Transparency for floating windows (0-100)
  timeoutlen     = 200,                --- Faster completion (cannot be lower than 200 because then commenting doesn't work)
  undofile       = true,               --- Sets undo to file
  updatetime     = 100,                --- Faster completion
  viminfo        = "'1000",            --- Increase the size of file history
  wildignore     = "*node_modules/**", --- Don't search inside Node.js modules (works for gutentag)
  wrap           = false,              --- Display long lines as just one line
  linebreak      = true,               --- Wrap lines at convenient points
  breakindent    = true,               --- Preserve indentation in wrapped text
  showbreak      = "↪ ",               --- String to put at the start of wrapped lines
  writebackup    = false,              --- Not needed
  -- Neovim defaults
  autoindent     = true,               --- Good auto indent
  backspace      = "indent,eol,start", --- Making sure backspace works
  backup         = false,              --- Recommended by coc
  --- Concealed text is completely hidden unless it has a custom replacement character defined (needed for dynamically showing tailwind classes)
  conceallevel   = 1,
  concealcursor  = "",      ---Set to an empty string to expand tailwind class when on cursorline
  encoding       = "utf-8", --- The encoding displayed
  errorbells     = false,   --- Disables sound effect for errors
  fileencoding   = "utf-8", --- The encoding written to file
  incsearch      = true,    --- Start searching before pressing enter
  showmode       = false,   --- Don't show things like -- INSERT -- anymore
  showcmd        = false,   --- Don't show command in the last line
  ruler          = false,   --- Don't show cursor position in command line
}

local globals = {
  mapleader                    = ' ',  --- Map leader key to SPC
  maplocalleader               = ',',  --- Map local leader key to comma
  speeddating_no_mappings      = 1,    --- Disable default mappings for speeddating
  codecompanion_auto_tool_mode = true, --- Enable auto tool mode for code companion
}

vim.opt.shortmess:append('c');
vim.opt.formatoptions:remove('c');
vim.opt.formatoptions:remove('r');
vim.opt.formatoptions:remove('o');
vim.opt.fillchars:append('stl: ');
vim.opt.fillchars:append('eob: ');
vim.opt.fillchars:append('fold: ');
vim.opt.fillchars:append('foldopen: ');
vim.opt.fillchars:append('foldsep: ');
vim.opt.fillchars:append('foldclose:');
vim.opt.fillchars:append('vert:│');
vim.opt.fillchars:append('vertleft:│');
vim.opt.fillchars:append('vertright:│');
vim.opt.fillchars:append('horiz:─');
vim.opt.fillchars:append('horizup:┴');
vim.opt.fillchars:append('horizdown:┬');
vim.opt.fillchars:append('verthoriz:┼');

for k, v in pairs(options) do
  vim.opt[k] = v
end

for k, v in pairs(globals) do
  vim.g[k] = v
end

local function is_remote_session()
  return os.getenv("SSH_TTY") ~= nil
    or os.getenv("SSH_CLIENT") ~= nil
    or os.getenv("SSH_CONNECTION") ~= nil
    or os.getenv("MOSH") ~= nil
    or os.getenv("TMUX") ~= nil  -- Enable OSC 52 in tmux regardless of TERM_PROGRAM
end

if is_remote_session() then
  -- For tmux on macOS: pipe through pbcopy for system clipboard
  if os.getenv("TMUX") then
    vim.g.clipboard = {
      name = 'tmux + pbcopy',
      copy = {
        ['+'] = { 'sh', '-c', 'cat | pbcopy' },
        ['*'] = { 'sh', '-c', 'cat | pbcopy' },
      },
      paste = {
        ['+'] = { 'pbpaste' },
        ['*'] = { 'pbpaste' },
      },
    }
  else
    -- SSH/Mosh: use OSC 52
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
      },
      paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
      },
    }
  end
end

