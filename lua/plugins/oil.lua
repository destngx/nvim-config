require("oil").setup({
  experimental_watch_for_changes = false,

  view_options = {
    show_hidden = true,
    natural_order = false,
  },
  win_options = {
    signcolumn = "yes:2",
  },
  keymaps = {
    ["<leader>p"] = function()
      local oil = require("oil")
      local filename = oil.get_cursor_entry().name
      local dir = oil.get_current_dir()
      oil.close()

      local img_clip = require("img-clip")
      img_clip.paste_image({}, dir .. filename)
    end,
  },
})
