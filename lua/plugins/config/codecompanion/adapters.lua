local function is_obsidian_note()
  return vim.bo.filetype == "markdown"
      and vim.api.nvim_buf_get_name(0):match('^/Users/destnguyxn/projects/obsidian%-vaults/.+%.md$')
end
return {
  COPILOT = {
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          -- set gpt-4.1 as default model for since github copilot count premium token claims for claude-sonnet-4
          -- model = is_obsidian_note() and { default = "gpt-4.1"} or { default = "claude-sonnet-4" },
          model = { default = "claude-sonnet-4.5"},
        },
      })
    end,
  }
}
