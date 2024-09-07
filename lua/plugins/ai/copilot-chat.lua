return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = DestNgxVim.plugins.ai.copilot.enabled,
    event = "VeryLazy",
    opts = {
      show_help = "no",
      prompts = {
        Explain = "Explain how it works.",
        Review = "Review the following code and provide concise suggestions.",
        Tests = "Briefly explain how the selected code works, then generate unit tests.",
        Refactor = "Refactor the code to improve clarity and readability.",
      },
    },
    build = function()
      vim.defer_fn(function()
        vim.cmd("UpdateRemotePlugins")
        vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
      end, 3000)
    end,
    keys = {
      { "<leader>acb", ":CopilotChatBuffer<cr>",      desc = "CopilotChat - Buffer" },
      { "<leader>ace", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>act", "<cmd>CopilotChatTests<cr>",   desc = "CopilotChat - Generate tests" },
      {
        "<leader>aca",
        "<cmd>CopilotChat<cr>",
        desc = "CopilotChat - Toggle ", -- Toggle vertical split
      },
      {
        "<leader>acf",
        "<cmd>CopilotChatFixDiagnostic<cr>", -- Get a fix for the diagnostic message under the cursor.
        desc = "CopilotChat - Fix diagnostic",
      },
    },
  }
}
