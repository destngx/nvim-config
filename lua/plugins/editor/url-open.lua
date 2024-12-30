-- lazy.nvim
return {
  "chrishrb/gx.nvim",
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
  cmd = { "Browse" },
  init = function()
    vim.g.netrw_nogx = 1   -- disable netrw gx
  end,
  config = true,
  --   "sontungexpt/url-open",
  -- enabled = false,
  --   branch = "mini",
  --   event = "VeryLazy",
  --   cmd = "URLOpenUnderCursor",
  --   config = function()
  --       local status_ok, url_open = pcall(require, "url-open")
  --       if not status_ok then
  --           return
  --       end
  --       url_open.setup ({})
  --   end,
}
