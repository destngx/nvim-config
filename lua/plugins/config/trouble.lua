local icons = DestNgxVim.icons

require("trouble").setup {
  position = "bottom", -- position of the list can be: bottom, top, left, right
  height = 10, -- height of the trouble list when position is top or bottom
  width = 50, -- width of the list when position is left or right
  mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
  fold_open = icons.chevronDown, -- icon used for open folds
  fold_closed = icons.chevronRight, -- icon used for closed folds
  group = true, -- group results by file
  padding = true, -- add an extra new line on top of the list
  indent_lines = true, -- add an indent guide below the fold icons
  auto_open = false, -- automatically open the list when you have diagnostics
  auto_close = true, -- automatically close the list when you have no diagnostics
  auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
  auto_fold = false, -- automatically fold a file trouble list at creation
  auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
  signs = {
    -- icons / text used for a diagnostic
    error       = icons.errorOutline,
    warning     = icons.warningTriangleNoBg,
    hint        = icons.lightbulbOutline,
    information = icons.infoOutline,
  },
  use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
  refresh = true,
  auto_refresh = true,
};
