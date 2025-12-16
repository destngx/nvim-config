-- VectorCode plugin disabled - user no longer uses it
-- Kept for reference if needed in the future
--[[
return {
  "Davidyz/VectorCode",
  version = "*",                        -- optional, depending on whether you're on nightly or release
  build = "uv tool upgrade vectorcode", -- optional but recommended. This keeps your CLI up-to-date.
  dependencies = { "nvim-lua/plenary.nvim" },
  enabled = function()
    return DestNgxVim.plugins.ai.vectorcode.enabled
  end,
  opts = function()
    return {
      async_backend = "lsp",
      notify = true,
      n_query = 10,
      async_opts = {
        timeout_ms = 5000, -- 10 seconds
        event = { "BufWritePost" },
        query_cb = require("vectorcode.utils").make_surrounding_lines_cb(-1),
        debount = -1,
        n_query = 30,
      },
    }
  end
}
--]]

return {}
