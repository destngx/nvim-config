return {
  "ravitemer/mcphub.nvim",
  enabled = DestNgxVim.plugins.ai.copilot.enabled,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
  config = function()
    require("mcphub").setup({
      auto_approve = function(params)
        -- Respect CodeCompanion's auto tool mode when enabled
        if vim.g.codecompanion_auto_tool_mode == true then
          return true   -- Auto approve when CodeCompanion auto-tool mode is on
        end

        -- Auto-approve GitHub issue reading
        if params.server_name == "github" and params.tool_name == "get_issue" then
          return true   -- Auto approve
        end

        -- Block access to private repos
        if params.arguments.repo == "private" then
          return "You can't access my private repo"   -- Error message
        end

        -- Auto-approve safe file operations in current project
        if params.tool_name == "read_file" then
          local path = params.arguments.path or ""
          if path:match("^" .. vim.fn.getcwd()) then
            return true     -- Auto approve
          end
        end

        -- Check if tool is configured for auto-approval in servers.json
        if params.is_auto_approved_in_server then
          return true   -- Respect servers.json configuration
        end

        return false -- Show confirmation prompt
      end,
    })
  end
}
