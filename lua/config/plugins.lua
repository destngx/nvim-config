return {
  {
    "vhyrro/luarocks.nvim",
    enabled = os.getenv "IS_WSL" ~= "true",
    lazy = false,
    priority = 1001, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    enabled = os.getenv "IS_WSL" ~= "true",
    lazy = true,
    event = "BufReadPre",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("plugins.image")
    end
  },
  { "tpope/vim-sleuth",      event = "BufReadPre" },
  {
    'mrjones2014/smart-splits.nvim',
    event = "VimEnter",
  },
  {
    "refractalize/oil-git-status.nvim",
    event = "VimEnter",
    config = true,
    dependencies = {
      {
        'stevearc/oil.nvim',
        event = "VimEnter",
        config = function()
          require("plugins.oil")
        end,
      },
    },
  },
  -- {
  --   'MeanderingProgrammer/markdown.nvim',
  --   event = "BufReadPre",
  --   name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --     require('plugins.markdown')
  --   end,
  -- },
  {
    'declancm/cinnamon.nvim',
    event = "BufReadPre",
    config = function()
      require('cinnamon').setup()
    end
  },
  {
    "andrewferrier/wrapping.nvim",
    event = "BufReadPre",
    config = function()
      require("plugins.wrapping")
    end
  },
  { "LunarVim/bigfile.nvim", event = "VimEnter" },
  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    event = {
      "BufReadPre /home/destnguyxn/projects/obsidian-vaults/**.md",
      "BufNewFile /home/destnguyxn/projects/obsidian-vaults/**.md",
    },
    dependencies = { "nvim-lua/plenary.nvim", },
    config = function()
      require("plugins.obsidian")
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        dir_path = "Attachments",
        relative_to_current_file = true,
      },
      filetypes = {
        markdown = {
          template = "![[$FILE_NAME]]", ---@type string
        },
        vimwiki = {
          template = "![[$FILE_NAME]]", ---@type string
        },
      }
    },
  },
  -- Themes
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("config.colorscheme")
  --     vim.o.background = "dark"
  --     vim.cmd([[colorscheme gruvbox]])
  --   end,
  -- },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("config.colorscheme")
      vim.cmd([[colorscheme kanagawa-dragon]])
    end,
  },
  {
    "folke/noice.nvim",
    enabled = DestNgxVim.plugins.experimental_noice.enabled,
    event = "VeryLazy",
    config = function()
      require("plugins.noice")
    end,
  },
  {
    "chrisgrieser/nvim-spider",
    enabled = DestNgxVim.plugins.jump_by_subwords.enabled,
    event = "BufEnter",
    keys = { "w", "e", "b", "ge" },
    config = function()
      vim.keymap.set({ "n", "o", "x" }, "W", "w", { desc = "Normal w" })
      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
      vim.keymap.set(
        { "n", "o", "x" },
        "ge",
        "<cmd>lua require('spider').motion('ge')<CR>",
        { desc = "Spider-ge" }
      )
    end,
  },
  { "nvim-lua/plenary.nvim", lazy = false },
  -- highlight same-name identifider with the same color
  { "David-Kunz/markid",     event = "BufReadPre" },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      require("plugins.alpha")
    end,
  },

  -- Treesitter
  {
    "Mohammed-Taher/AdvancedNewFile.nvim",
    event = "BufReadPre",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    config = function()
      require("plugins.treesitter")
    end,
    dependencies = {
      "hiphish/rainbow-delimiters.nvim",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
      {
        "m-demare/hlargs.nvim",
        config = function()
          require("hlargs").setup({ color = "#F7768E" })
        end,
      },
    },
  },
  -- show context of current line
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = function()
      require("treesitter-context").setup {
        max_lines = 4,
      }
    end,
  },

  -- Navigating (Telescope/Tree/Refactor)
  {
    "0x00-ketsu/autosave.nvim",
    event = "InsertLeave",
    config = function()
      require("autosave").setup {
        enabled = true,
        conditions = {
          filetype_is_not = { "markdown", "gitcommit", "oil", "alpha" },
        },
      }
    end,
  },
  {
    "ibhagwan/fzf-lua",
    event = "VimEnter",
    branch = "main",
    config = function()
      require("plugins.fzf")
    end,
  },
  -- better escape
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("plugins.better-escape")
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    keys = {
      {
        "<Leader>pr",
        "<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
        desc = "refactor",
      },
      {
        "<Leader>pr",
        "<cmd>lua require('spectre').open_visual()<CR>",
        mode = "v",
        desc = "refactor",
      }
    }
  },
  {
    "AckslD/nvim-neoclip.lua",
    event = "BufReadPre",
    dependencies = {
      { 'kkharji/sqlite.lua', module = 'sqlite' },
      -- you'll need at least one of these
      { 'ibhagwan/fzf-lua' },
    },
    config = function()
      require('neoclip').setup({
        enable_persistent_history = true,
      })
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    event = "BufEnter",
    ft = "qf",
    init = function()
      require('plugins.bqf-init')
    end,
  },
  -- {
  --   "fnune/recall.nvim",
  --   version = "*",
  --   event = "BufEnter",
  --   config = function()
  --     local recall = require("recall")
  --     recall.setup({})
  --
  --     vim.keymap.set("n", "mm", recall.toggle, { noremap = true, silent = true })
  --     vim.keymap.set("n", "mn", recall.goto_next, { noremap = true, silent = true })
  --     vim.keymap.set("n", "mp", recall.goto_prev, { noremap = true, silent = true })
  --     vim.keymap.set("n", "mc", recall.clear, { noremap = true, silent = true })
  --   end,
  -- },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("plugins.tree")
    end,
  },
  {
    "gbprod/stay-in-place.nvim",
    event = "BufEnter",
    config = true, -- run require("stay-in-place").setup()
  },
  {
    "ThePrimeagen/refactoring.nvim",
    event = "BufEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = "Refactor",
    kees = {
      { "<leader>re", ":Refactor extract ",              mode = "x",          desc = "Extract function" },
      { "<leader>rf", ":Refactor extract_to_file ",      mode = "x",          desc = "Extract function to file" },
      { "<leader>rv", ":Refactor extract_var ",          mode = "x",          desc = "Extract variable" },
      { "<leader>ri", ":Refactor inline_var",            mode = { "x", "n" }, desc = "Inline variable" },
      { "<leader>rI", ":Refactor inline_func",           mode = "n",          desc = "Inline function" },
      { "<leader>rb", ":Refactor extract_block",         mode = "n",          desc = "Extract block" },
      { "<leader>rf", ":Refactor extract_block_to_file", mode = "n",          desc = "Extract block to file" },
    },
    config = true
  },

  -- LSP Base
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    servers = nil,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
  {
    "johmsalas/text-case.nvim",
    event = "BufEnter",
    --   dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup(
        {
          default_keymappings_enabled = true,
          prefix = "gu",
          substitude_command_name = nil,
        }
      )
    end,
    keys = { "gu" }
  },
  -- AI
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    enabled = DestNgxVim.plugins.ai.copilot.enabled,
    config = function()
      require("plugins.copilot")
    end,
    dependencies = { 'AndreM222/copilot-lualine' }
  },
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
    }
  },
  {
    "jcdickinson/codeium.nvim",
    enabled = DestNgxVim.plugins.ai.codeium.enabled,
    event = "InsertEnter",
    cmd = "Codeium",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({ enabled_chat = true })
    end,
  },
  -- {
  --   "frankroeder/parrot.nvim",
  --   dependencies = { "ibhagwan/fzf-lua" },
  --   lazy = false,
  --   enabled = (os.getenv "OPENAI_API_KEY" ~= nil or os.getenv "PERPLEXITY_API_KEY" ~= nil) and
  --       DestNgxVim.plugins.ai.parrot.enabled,
  --   config = function()
  --     require("plugins.parrot")
  --   end,
  -- },
  -- LSP Cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      ---@diagnostic disable-next-line: different-requires
      require("plugins.cmp")
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "saadparwaiz1/cmp_luasnip",
      -- {
      --   "David-Kunz/cmp-npm",
      --   config = function()
      --     require("plugins.cmp-npm")
      --   end,
      -- },
      {
        "zbirenbaum/copilot-cmp",
        enabled = DestNgxVim.plugins.ai.copilot.enabled,
        config = function()
          require("copilot_cmp").setup()
        end,
      },
      "petertriho/cmp-git"
    },
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
    build = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load { paths = { vim.fn.stdpath("config") .. "/snippets" } }
    end
  },
  -- LSP Addons
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("plugins.dressing")
    end,
  },
  { "onsails/lspkind-nvim" },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("plugins.trouble")
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("plugins.typescript-tools")
    end,
  },
  {
    "axelvc/template-string.nvim",
    event = "InsertEnter",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = true, -- run require("template-string").setup()
  },
  -- Python indent (follows the PEP8 style)
  { "Vimjas/vim-python-pep8-indent",   ft = { "python" } },
  -- Python-related text object
  { "jeetsukumaran/vim-pythonsense",   ft = { "python" } },
  { "machakann/vim-swap",              event = "VimEnter" },
  -- Add indent object for vim (useful for languages like Python)
  { "michaeljsmith/vim-indent-object", event = "VimEnter" },
  -- {
  --   "dmmulroy/tsc.nvim",
  --   cmd = { "TSC" },
  --   filetypes = { "typescript", "typescriptreact" },
  --   config = function ()
  --     require("tsc").setup({
  --       run_as_monorepo = true,
  --       use_trouble_qflist = true,
  --       use_diagnostics = true
  --     })
  --   end,
  -- },
  {
    "dnlhc/glance.nvim",
    config = function()
      require("plugins.glance")
    end,
    cmd = { "Glance" },
    keys = {
      { "gd", "<cmd>Glance definitions<CR>",      desc = "LSP Definition" },
      { "gr", "<cmd>Glance references<CR>",       desc = "LSP References" },
      { "gm", "<cmd>Glance implementations<CR>",  desc = "LSP Implementations" },
      { "gy", "<cmd>Glance type_definitions<CR>", desc = "LSP Type Definitions" },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-tree.lua" },
    },
    config = function()
      require("lsp-file-operations").setup()
    end
  },
  -- General
  -- { "AndrewRadev/switch.vim",      lazy = false },
  -- { "AndrewRadev/splitjoin.vim", lazy = false },
  -- {
  --   "mistricky/codesnap.nvim",
  --   build = "make build_generator",
  --   version = "^1",
  --   cmd = "CodeSnapPreviewOn",
  --   opts = {
  --     watermark = nil
  --   }
  -- },
  {
    "Wansmer/treesj",
    lazy = true,
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "gJ", "<cmd>TSJToggle<CR>", desc = "Toggle Split/Join" },
    },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("plugins.comment")
    end,
  },
  {
    "LudoPinelli/comment-box.nvim",
    keys = {
      { "<leader>cc", "<cmd>lua require('comment-box').llbox()<CR>", desc = "comment box" },
      { "<leader>cc", "<cmd>lua require('comment-box').llbox()<CR>", mode = "v",          desc = "comment box" },
    }
  },
  { "tpope/vim-repeat",      event = "BufReadPre" },
  { "tpope/vim-speeddating", event = "BufReadPre" },
  -- { "dhruvasagar/vim-table-mode", ft = { "markdown" } },
  -- {
  --   "smoka7/multicursors.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'smoka7/hydra.nvim',
  --   },
  --   opts = {
  --     hint_config = {
  --       border = DestNgxVim.ui.float.border or "rounded",
  --       position = 'bottom',
  --       show_name = false,
  --     }
  --   },
  --   keys = {
  --     {
  --       '<LEADER>M',
  --       '<CMD>MCstart<CR>',
  --       desc = 'multicursor',
  --     },
  --     {
  --       '<LEADER>M',
  --       '<CMD>MCvisual<CR>',
  --       mode = "v",
  --       desc = 'multicursor',
  --     },
  --     {
  --       '<C-Down>',
  --       '<CMD>MCunderCursor<CR>',
  --       desc = 'multicursor down',
  --     },
  --   },
  -- },
  {
    "nacro90/numb.nvim",
    event = "BufEnter",
    config = function()
      require("plugins.numb")
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufEnter",
    config = function()
      require("plugins.todo-comments")
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    config = function()
      require("plugins.zen")
    end,
    enabled = DestNgxVim.plugins.zen.enabled,
  },
  {
    "folke/twilight.nvim",
    config = true,
    enabled = DestNgxVim.plugins.zen.enabled,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.flash-jump")
    end,
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      -- {
      --   "r",
      --   mode = "o",
      --   function()
      --     require("flash").remote()
      --   end,
      --   desc = "Remote Flash"
      -- },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.which-key")
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    config = function()
      require("plugins.lualine")
    end,
  },
  -- {
  --   "echasnovski/mini.bufremove",
  --   version = "*",
  --   config = function()
  --     require("mini.bufremove").setup({
  --       silent = true,
  --     })
  --   end,
  -- },
  -- {
  --   "cbochs/grapple.nvim",
  --   event = "VimEnter",
  --   dependencies = {
  --     { "nvim-tree/nvim-web-devicons" }
  --   },
  --   opts = {
  --     scope = "git",
  --     icons = true,
  --     quick_select = "123456789",
  --   },
  --   keys = {
  --     { "<leader>'", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
  --   },
  -- },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("plugins.notify")
    end,
  },
  -- {
  --   "rcarriga/nvim-notify",
  --   config = function()
  --     require("plugins.notify")
  --   end,
  -- },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "airblade/vim-rooter",
    event = "VeryLazy",
    config = function()
      vim.g.rooter_patterns = DestNgxVim.plugins.rooter.patterns
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_resolve_links = 1
    end,
  },
  {
    "Shatur/neovim-session-manager",
    lazy = false,
    config = function()
      require("plugins.session-manager")
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = true
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    end,
  },
  {
    "echasnovski/mini.bufremove",
    lazy = "VeryLazy",
  },

  {
    "echasnovski/mini.align",
    event = "BufEnter",
    version = "*",
    config = function()
      require("mini.align").setup()
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "BufEnter",
    version = "*",
    config = function()
      require("mini.ai").setup()
    end,
  },
  {
    "rareitems/printer.nvim",
    event = "BufEnter",
    ft = {
      "lua",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = function()
      require("plugins.printer")
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    config = function()
      require("plugins.indent")
    end,
  },

  -- Snippets & Language & Syntax
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("plugins.autopairs")
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("plugins.nvchad-colorizer")
    end,
  },
  {
    "js-everts/cmp-tailwind-colors",
    config = true,
  },
  {
    "razak17/tailwind-fold.nvim",
    opts = {
      min_chars = 50,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
  },
  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<Leader>cv", "<CMD>TWValues<CR>", desc = "Tailwind CSS values" },
    },
    opts = {
      border = DestNgxVim.ui.float.border or "rounded", -- Valid window border style,
      show_unknown_classes = true                       -- Shows the unknown classes popup
    }
  },
  {
    "laytan/tailwind-sorter.nvim",
    cmd = {
      "TailwindSort",
      "TailwindSortOnSaveToggle"
    },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    build = "cd formatter && npm i && npm run build",
    config = true,
  },
  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.git.signs")
    end,
    keys = {
      { "<Leader>ghd", desc = "diff hunk" },
      { "<Leader>ghp", desc = "preview" },
      { "<Leader>ghR", desc = "reset buffer" },
      { "<Leader>ghr", desc = "reset hunk" },
      { "<Leader>ghs", desc = "stage hunk" },
      { "<Leader>ghS", desc = "stage buffer" },
      { "<Leader>ght", desc = "toggle deleted" },
      { "<Leader>ghu", desc = "undo stage" }
    }
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
    config = function()
      require("plugins.git.diffview")
    end,
    keys = {
      { "<Leader>gd", "<cmd>lua require('plugins.git.diffview').toggle_file_history()<CR>", desc = "diff file" },
      { "<Leader>gS", "<cmd>lua require('plugins.git.diffview').toggle_status()<CR>",       desc = "status" }
    },
  },
  {
    "akinsho/git-conflict.nvim",
    lazy = false,
    config = function()
      require("plugins.git.conflict")
    end,
    keys = {
      { "<Leader>gcb", '<cmd>GitConflictChooseBoth<CR>',   desc = 'choose both' },
      { "<Leader>gcn", '<cmd>GitConflictNextConflict<CR>', desc = 'move to next conflict' },
      { "<Leader>gcc", '<cmd>GitConflictChooseOurs<CR>',   desc = 'choose current' },
      { "<Leader>gcp", '<cmd>GitConflictPrevConflict<CR>', desc = 'move to prev conflict' },
      { "<Leader>gci", '<cmd>GitConflictChooseTheirs<CR>', desc = 'choose incoming' },
    }
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    keys = {
      "<Leader>gwc",
      "<Leader>gww",
    },
    config = function()
      require("plugins.git.worktree")
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitCurrentFile",
      "LazyGitFilterCurrentFile",
      "LazyGitFilter",
    },
    config = function()
      vim.g.lazygit_floating_window_scaling_factor = 0.9
    end,
    keys = {
      { "<Leader>gg", "<cmd>LazyGit<CR>", desc = "lazygit" },
    },
  },
  -- {
  --   "pwntester/octo.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   cmd = {
  --     "Octo",
  --   },
  --   config = function()
  --     require('plugins.git.octo')
  --   end
  -- },

  -- Testing
  {
    "rcarriga/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "haydenmeade/neotest-jest",
    },
    config = function()
      require("plugins.neotest")
    end,
  },
  {
    "andythigpen/nvim-coverage",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = {
      "Coverage",
      "CoverageSummary",
      "CoverageLoad",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
    },
    config = function()
      require("coverage").setup()
    end,
  },

  -- DAP
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("plugins.dap")
    end,
    keys = {
      "<Leader>da",
      "<Leader>db",
      "<Leader>dc",
      "<Leader>dd",
      "<Leader>dh",
      "<Leader>di",
      "<Leader>do",
      "<Leader>dO",
      "<Leader>dt",
    },
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "mxsdev/nvim-dap-vscode-js",
    },
  },
  {
    "LiadOz/nvim-dap-repl-highlights",
    config = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    build = function()
      if not require("nvim-treesitter.parsers").has_parser("dap_repl") then
        vim.cmd(":TSInstall dap_repl")
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('plugins.formatting')
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      require('plugins.linting')
    end,
  },
}
