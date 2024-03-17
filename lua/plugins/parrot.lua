local cmd_prefix = "Prt"

require("parrot").setup {
  providers = {
    openai = {
      api_key = os.getenv "OPENAI_API_KEY",
    },
    anthropic = {
      api_key = os.getenv "ANTHROPIC_API_KEY",
    },
  },
  cmd_prefix = cmd_prefix,
  chat_conceal_model_params = false,
  hooks = {
    Complete = function(prt, params)
      local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted."
        ]]
      local agent = prt.get_command_agent()
      prt.Prompt(
        params,
        prt.ui.Target.append,
        nil,
        agent.model,
        template,
        agent.system_prompt,
        agent.provider
      )
    end,
    Explain = function(prt, params)
      local template = [[
        Explain the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Use the markdown format with codeblocks.
        A brief explanation of what the code above is doing:
        ]]
      local agent = prt.get_chat_agent()
      prt.logger.info("Explaining selection with agent: " .. agent.name)
      prt.Prompt(
        params,
        prt.ui.Target.popup,
        nil,
        agent.model,
        template,
        agent.system_prompt,
        agent.provider
      )
    end,
    FixBugs = function(prt, params)
      local template = [[
        You are an expert in {{filetype}}.
        Fix bugs in the below code from {{filename}} carefully and logically:

        ```{{filetype}}
        {{selection}}
        ```

        Fixed code:
        ]]
      local agent = prt.get_command_agent()
      prt.logger.info("Fixing bugs in selection with agent: " .. agent.name)
      prt.Prompt(
        params,
        prt.ui.Target.popup,
        nil,
        agent.model,
        template,
        agent.system_prompt,
        agent.provider
      )
    end,
    Optimize = function(prt, params)
      local template = [[
        You are an expert in {{filetype}}.
        Optimize the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Optimized code:
        ]]
      local agent = prt.get_command_agent()
      prt.logger.info("Optimizing selection with agent: " .. agent.name)
      prt.Prompt(
        params,
        prt.ui.Target.popup,
        nil,
        agent.model,
        template,
        agent.system_prompt,
        agent.provider
      )
    end,
    UnitTests = function(prt, params)
      local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Please respond by writing table driven unit tests for the code above.
        ]]
      local agent = prt.get_command_agent()
      prt.logger.info("Creating unit tests for selection with agent: " .. agent.name)
      prt.Prompt(
        params,
        prt.ui.Target.enew,
        nil,
        agent.model,
        template,
        agent.system_prompt,
        agent.provider
      )
    end,
    ProofReader = function(prt, params)
      local chat_system_prompt = [[
        I want you to act as a proofreader. I will provide you with texts and
        I would like you to review them for any spelling, grammar, or
        punctuation errors. Once you have finished reviewing the text,
        provide me with any necessary corrections or suggestions to improve the
        text. Highlight the corrections with markdown bold or italics style.
        ]]
      local agent = prt.get_chat_agent()
      prt.logger.info("Proofreading selection with agent: " .. agent.name)
      prt.cmd.ChatNew(params, agent.model, chat_system_prompt)
    end,
    Debug = function(prt, params)
      local template = [[
        I want you to act as {{filetype}} expert.
        Review the following code, carefully examine it, and report potential
        bugs and edge cases alongside solutions to resolve them.
        Keep your explanation short and to the point:

        ```{{filetype}}
        {{selection}}
        ```
        ]]
      local agent = prt.get_chat_agent()
      prt.logger.info("Debugging selection with agent: " .. agent.name)
      prt.Prompt(
        params,
        prt.ui.Target.enew,
        nil,
        agent.model,
        template,
        agent.system_prompt,
        agent.provider
      )
    end,
  },
  keys = {
    -- Normal and Insert mode mappings
    { "<Leader>pc", "<cmd>PrtChatNew<cr>",           mode = { "n", "i" },           desc = "New Chat" },
    { "<C-g>t", "<cmd>PrtChatToggle tabnew<cr>", mode = { "n", "i" },           desc = "Toggle Popup Chat" },
    { "<C-g>f", "<cmd>PrtChatFinder<cr>",        mode = { "n", "i" },           desc = "Chat Finder" },
    { "<C-g>r", "<cmd>PrtRewrite<cr>",           mode = { "n", "i" },           desc = "Inline Rewrite" },
    { "<C-g>a", "<cmd>PrtAppend<cr>",            mode = { "n", "i" },           desc = "Append" },
    { "<C-g>o", "<cmd>PrtPrepend<cr>",           mode = { "n", "i" },           desc = "Prepend" },

    -- Visual mode mappings
    { "<C-g>c", "<cmd>PrtChatNew<cr>",           mode = "v",                    desc = "Visual Chat New" },
    { "<C-g>r", "<cmd>PrtRewrite<cr>",           mode = "v",                    desc = "Visual Rewrite" },
    { "<C-g>a", "<cmd>PrtAppend<cr>",            mode = "v",                    desc = "Visual Append" },
    { "<C-g>o", "<cmd>PrtPrepend<cr>",           mode = "v",                    desc = "Visual Prepend" },
    { "<C-g>e", "<cmd>PrtEnew<cr>",              mode = "v",                    desc = "Visual Enew" },

    -- Additional mappings
    { "<C-g>s", "<cmd>PrtStop<cr>",              mode = { "n", "i", "v", "x" }, desc = "Stop" },
    { "<C-g>i", "<cmd>PrtComplete<cr>",          mode = { "n", "i", "v", "x" }, desc = "Complete the visual selection" },

    -- Context and agent/provider selection mappings
    { "<C-g>x", "<cmd>PrtContext<cr>",           mode = "n",                    desc = "Open file with custom context" },
    { "<C-g>n", "<cmd>PrtAgent<cr>",             mode = "n",                    desc = "Select agent or show info" },
    { "<C-g>p", "<cmd>PrtProvider<cr>",          mode = "n",                    desc = "Select provider or show info" },
  },
}
