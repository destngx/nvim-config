local present, signs = pcall(require, "gitsigns")
if not present then
  return
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ Setup                                                    │
-- ╰──────────────────────────────────────────────────────────╯
signs.setup {
  signs                        = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  signs_staged                 = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
  },
  signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    interval = 700,
    follow_files = true
  },
  attach_to_untracked          = true,
  current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 700,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority                = 16,
  update_debounce              = 100,
  status_formatter             = nil, -- Use default
  max_file_length              = 40000,
  preview_config               = {
    -- Options passed to nvim_open_win
    border = DestNgxVim.ui.float.border,
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  on_attach                    = function(buf)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = buf
      vim.keymap.set(mode, l, r, opts)
    end

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Keymappings                                              │
    -- ╰──────────────────────────────────────────────────────────╯

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = "Next Hunk" })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = "Previous Hunk" })

    -- Actions
    map({ 'n', 'v' }, '<leader>ghs', gs.stage_hunk, { desc = "Stage Hunk" })
    map({ 'n', 'v' }, '<leader>ghr', gs.reset_hunk, { desc = "Reset Hunk" })
    map({ 'n' }, '<leader>ghS', gs.stage_buffer, { desc = "Stage Buffer" })
    map({ 'n' }, '<leader>ghu', gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
    map({ 'n' }, '<leader>ghR', gs.reset_buffer, { desc = "Reset Buffer" })
    map({ 'n' }, '<leader>ghp', gs.preview_hunk, { desc = "Preview Hunk" })
    map({ 'n' }, '<leader>ghm', function() gs.blame_line { full = true } end, { desc = "Full Blame line" })
    map({ 'n' }, '<leader>ghd', gs.diffthis, { desc = "Diff This" })
    map({ 'n' }, '<leader>ght', gs.toggle_deleted, { desc = "Show Deleted Files" })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select Hunk" })
  end
}
