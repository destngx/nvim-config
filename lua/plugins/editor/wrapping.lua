return
{
  "andrewferrier/wrapping.nvim",
  ft = { "markdown", "lua" },
  opts = {
    softener = { markdown = true, lua = true },
    create_keymaps = false,
    notify_on_switch = false,
    auto_set_mode_filetype_allowlist = {
      "asciidoc",
      "gitcommit",
      "latex",
      "mail",
      "markdown",
      "rst",
      "tex",
      "text",
      "lua",
    },
  }
}
