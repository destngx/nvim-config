---@diagnostic disable: different-requires
return {
  -- Smooth scolling for any movement command or string of commands
  {
    'declancm/cinnamon.nvim',
    config = function()
      require('cinnamon').setup()
    end
  },
  -- handling soft and hard line wrapping in text-like files
  {
    "andrewferrier/wrapping.nvim",
    lazy = false,
    config = function()
      require("plugins.wrapping")
    end
  },
  -- Automatically turn off some features of neovim when working with large files
  { "LunarVim/bigfile.nvim" },
  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- ft = { "markdown" },
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      -- "BufReadPre" .. vim.fn.expand "~" .. "/obsidian-vaults/**.md",
      -- "BufNewFile" .. vim.fn.expand "~" .. "/obsidian-vaults/**.md",
      "BufReadPre /Users/destnguyxn/projects/obsidian-vaults/**.md",
      "BufNewFile /Users/destnguyxn/projects/obsidian-vaults/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required.
    },
    config = function()
      require("plugins.obsidian")
    end,
  },
  -- Themes
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
      require("config.colorscheme")
    end,
  },
  -- experimental interface for messages, command-line and the popup menu
  {
    "folke/noice.nvim",
    cond = EcoVim.plugins.experimental_noice.enabled,
    lazy = false,
    config = function()
      require("plugins.noice")
    end,
  },
  -- move by subwords and skip insignificant punctuation
  {
    "chrisgrieser/nvim-spider",
    cond = EcoVim.plugins.jump_by_subwords.enabled,
    lazy = true,
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
  -- show the current context of file in winbar
  {
    "SmiteshP/nvim-navic",
    config = function()
      require("plugins.navic")
    end,
    dependencies = "neovim/nvim-lspconfig",
  },
  { "nvim-lua/plenary.nvim" },
  { "David-Kunz/markid" },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },
  -- alternative icon pack
  {
    'yamatsum/nvim-nonicons',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  -- dashboard for neovim
  {
    "goolord/alpha-nvim",
    lazy = false,
    config = function()
      require("plugins.alpha")
    end,
  },

  -- advanced new files and folders
  {
    "Mohammed-Taher/AdvancedNewFile.nvim",
    lazy = false,
  },
  -- enhances syntax highlighting and code context
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
-- autosave config
  {
    "0x00-ketsu/autosave.nvim",
    lazy = false,
    config = function()
      require("autosave").setup {
        enabled = true,
        -- your config goes here
        -- or just leave it empty :)
        conditions = {
          filetype_is_not = { "markdown", "gitcommit" },
        },
      }
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
  -- refactor, replace, find
  {
    "nvim-pack/nvim-spectre",
    lazy = true,
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
  -- fuzzy finder and searching for everything
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    config = function()
      require("plugins.telescope")
    end,
    dependencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "cljoly/telescope-repo.nvim" },
    },
  },
  -- a file explorer tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = {
      "NvimTreeOpen",
      "NvimTreeClose",
      "NvimTreeToggle",
      "NvimTreeFindFile",
      "NvimTreeFindFileToggle",
    },
    keys = {
      { "<C-e>", "<cmd>lua require('nvim-tree.api').tree.toggle()<CR>", desc = "NvimTree" },
    },
    config = function()
      require("plugins.tree")
    end,
  },
  -- show context of current line
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
  },
  -- maintaining the cursor position during various actions
  {
    "gbprod/stay-in-place.nvim",
    lazy = false,
    config = true, -- run require("stay-in-place").setup()
  },
  -- refactoring like in Refactoring book by Martin Fowler
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = "Refactor",
    keys = {
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
  -- manage LSP servers, DAP servers, linters, and formatters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },

  -- AI quick code completion (not very privacy)
  {
    "jcdickinson/codeium.nvim",
    cond = EcoVim.plugins.ai.codeium.enabled,
    event = "InsertEnter",
    cmd = "Codeium",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = true,
  },
  -- AI Chat and code contex assistant
  {
    "frankroeder/parrot.nvim",
    dependencies = { "ibhagwan/fzf-lua" },
    lazy = false,
    cond = os.getenv "OPENAI_API_KEY" ~= nil or os.getenv "PERPLEXITY_API_KEY" ~= nil,
    config = function()
      require("plugins.parrot")
    end,
  },
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
      { "L3MON4D3/LuaSnip", dependencies = "rafamadriz/friendly-snippets" },
      {
        "David-Kunz/cmp-npm",
        config = function()
          require("plugins.cmp-npm")
        end,
      },
      "petertriho/cmp-git"
    },
  },

  -- Neovim UI enhancements
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("plugins.dressing")
    end,
  },
  -- add vscode like pictogram to neovim lsp
  { "onsails/lspkind-nvim" },
  --add pretty diagnostics, references, telescope result, quickfix and location list
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("plugins.trouble")
    end,
  },
  -- enhance Typescipt LSP
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
-- ╭─────────────────────────────────────────────────────────╮
-- │ As soon as this plugin detects you're trying to use     │
-- │ template strings (adding ${}) the quotes will be        │
-- │ changed to backticks                                    │
-- ╰─────────────────────────────────────────────────────────╯
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
  -- swap delitited items
  { "machakann/vim-swap",              event = "VimEnter" },
  -- Add indent object for vim (useful for languages like Python)
  { "michaeljsmith/vim-indent-object", event = "VimEnter" },
  -- project wide async ts type-checking
  {
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    config = true,
  },
  -- pretty window for previewing, navigating and changing lsp location
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
  -- enhances file operations using lsp
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
  -- splitting and joining block code efficiency
  -- TODO: config and learn how to use
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
  -- quick comment with treesitter support
  {
    "numToStr/Comment.nvim",
    lazy = false,
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("plugins.comment")
    end,
  },
  -- create comment box
  {
    "LudoPinelli/comment-box.nvim",
    lazy = false,
  },
  -- toggle terminal
  {
    "akinsho/nvim-toggleterm.lua",
    lazy = false,
    branch = "main",
    config = function()
      require("plugins.toggleterm")
    end,
  },
  -- add dot repeat for non native command
  { "tpope/vim-repeat",           lazy = false },
  -- speedy interact with date like text 28-02-2024
  -- TODO: config and learn how to use
  { "tpope/vim-speeddating",      lazy = false },
  -- better support when create table in markdown
  { "dhruvasagar/vim-table-mode", ft = { "markdown" } },
  -- add multicursors features to neovim
  -- TODO: config and learn how to use
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'smoka7/hydra.nvim',
    },
    opts = {
      hint_config = {
        border = EcoVim.ui.float.border or "rounded",
        position = 'bottom',
        show_name = false,
      }
    },
    keys = {
      {
        '<LEADER>M',
        '<CMD>MCstart<CR>',
        desc = 'multicursor',
      },
      {
        '<LEADER>M',
        '<CMD>MCvisual<CR>',
        mode = "v",
        desc = 'multicursor',
      },
      {
        '<C-Down>',
        '<CMD>MCunderCursor<CR>',
        desc = 'multicursor down',
      },
    },
  },
  -- Peak line at number when typing a number in command_palette
  {
    "nacro90/numb.nvim",
    lazy = false,
    config = function()
      require("plugins.numb")
    end,
  },
  --- highlight and search todo, hack, bug,... comments
  {
    "folke/todo-comments.nvim",
    lazy = false,
    event = "BufEnter",
    config = function()
      require("plugins.todo-comments")
    end,
  },
  -- zen view mode feature
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    config = function()
      require("plugins.zen")
    end,
    cond = EcoVim.plugins.zen.enabled,
  },
  -- only light a main focus code part base on your cursor
  {
    "folke/twilight.nvim",
    config = true,
    cond = EcoVim.plugins.zen.enabled,
  },
  -- navigate like flash
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      char = {
        keys = { "f", "F", "t", "T" },
      }
    },
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
      },
    },
  },
  -- key guiding
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    lazy = true,
    config = function()
      require("plugins.which-key")
    end,
  },
  -- galaxyline and status bar
  {
    "ecosse3/galaxyline.nvim",
    config = function()
      require("plugins.galaxyline")
    end,
    event = "VeryLazy",
  },
  -- wiping out buffer
  {
    "echasnovski/mini.bufremove",
    version = "*",
    config = function()
      require("mini.bufremove").setup({
        silent = true,
      })
    end,
  },
  -- add a tab like bar for buffers
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      "echasnovski/mini.bufremove",
    },
    version = "*",
    config = function()
      require("plugins.bufferline")
    end,
    keys = {
      { "<Space>1",    "<cmd>BufferLineGoToBuffer 1<CR>" },
      { "<Space>2",    "<cmd>BufferLineGoToBuffer 2<CR>" },
      { "<Space>3",    "<cmd>BufferLineGoToBuffer 3<CR>" },
      { "<Space>4",    "<cmd>BufferLineGoToBuffer 4<CR>" },
      { "<Space>5",    "<cmd>BufferLineGoToBuffer 5<CR>" },
      { "<Space>6",    "<cmd>BufferLineGoToBuffer 6<CR>" },
      { "<Space>7",    "<cmd>BufferLineGoToBuffer 7<CR>" },
      { "<Space>8",    "<cmd>BufferLineGoToBuffer 8<CR>" },
      { "<Space>9",    "<cmd>BufferLineGoToBuffer 9<CR>" },
      { "<A-1>",       "<cmd>BufferLineGoToBuffer 1<CR>" },
      { "<A-2>",       "<cmd>BufferLineGoToBuffer 2<CR>" },
      { "<A-3>",       "<cmd>BufferLineGoToBuffer 3<CR>" },
      { "<A-4>",       "<cmd>BufferLineGoToBuffer 4<CR>" },
      { "<A-5>",       "<cmd>BufferLineGoToBuffer 5<CR>" },
      { "<A-6>",       "<cmd>BufferLineGoToBuffer 6<CR>" },
      { "<A-7>",       "<cmd>BufferLineGoToBuffer 7<CR>" },
      { "<A-8>",       "<cmd>BufferLineGoToBuffer 8<CR>" },
      { "<A-9>",       "<cmd>BufferLineGoToBuffer 9<CR>" },
      { "<Leader>bb",  "<cmd>BufferLineMovePrev<CR>",                desc = "Move back" },
      { "<Leader>bl",  "<cmd>BufferLineCloseLeft<CR>",               desc = "Close Left" },
      { "<Leader>br",  "<cmd>BufferLineCloseRight<CR>",              desc = "Close Right" },
      { "<Leader>bn",  "<cmd>BufferLineMoveNext<CR>",                desc = "Move next" },
      { "<Leader>bp",  "<cmd>BufferLinePick<CR>",                    desc = "Pick Buffer" },
      { "<Leader>bP",  "<cmd>BufferLineTogglePin<CR>",               desc = "Pin/Unpin Buffer" },
      { "<Leader>bsd", "<cmd>BufferLineSortByDirectory<CR>",         desc = "Sort by directory" },
      { "<Leader>bse", "<cmd>BufferLineSortByExtension<CR>",         desc = "Sort by extension" },
      { "<Leader>bsr", "<cmd>BufferLineSortByRelativeDirectory<CR>", desc = "Sort by relative dir" },
    }
  },
  -- a fancy and configurable notifications manager
  {
    "rcarriga/nvim-notify",
    config = function()
      require("plugins.nvim-notify")
    end,
    init = function()
      local banned_messages = {
        "No information available",
        "LSP[tsserver] Inlay Hints request failed. Requires TypeScript 4.4+.",
        "LSP[tsserver] Inlay Hints request failed. File not opened in the editor.",
      }
      vim.notify = function(msg, ...)
        for _, banned in ipairs(banned_messages) do
          if msg == banned then
            return
          end
        end
        return require("notify")(msg, ...)
      end
    end,
  },
  -- perform package.json commands and show details
  -- TODO: config and learn how to use
  {
    "vuki656/package-info.nvim",
    event = "BufEnter package.json",
    config = function()
      require("plugins.package-info")
    end,
  },
  -- preview markdown in a web browser
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  -- autochange project root dir when open file
  {
    "airblade/vim-rooter",
    event = "VeryLazy",
    config = function()
      vim.g.rooter_patterns = EcoVim.plugins.rooter.patterns
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_resolve_links = 1
    end,
  },
  -- TODO: config and learn how to use
  {
    "Shatur/neovim-session-manager",
    lazy = false,
    config = function()
      require("plugins.session-manager")
    end,
    keys = {
      { "<Leader>/sc", "<cmd>SessionManager load_session<CR>",             desc = "choose session" },
      { "<Leader>/sr", "<cmd>SessionManager delete_session<CR>",           desc = "remove session" },
      { "<Leader>/sd", "<cmd>SessionManager load_current_dir_session<CR>", desc = "load current dir session" },
      { "<Leader>/sl", "<cmd>SessionManager load_last_session<CR>",        desc = "load last session" },
      { "<Leader>/ss", "<cmd>SessionManager save_current_session<CR>",     desc = "save session" },
    }
  },
  -- quickly make surround action
  -- TODO: config and learn how to use
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = true
  },
  -- dim inactive windows
  {
    "sunjon/shade.nvim",
    lazy = false,
    config = function()
      require("shade").setup()
      require("shade").toggle()
    end,
  },
  -- fold your code
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    end,
  },
  -- align text interactively
  -- TODO: config and learn how to use
  {
    "echasnovski/mini.align",
    lazy = false,
    version = "*",
    config = function()
      require("mini.align").setup()
    end,
  },
  -- extend and create a/i textobjects
  {
    "echasnovski/mini.ai",
    lazy = false,
    version = "*",
    config = function()
      require("mini.ai").setup()
    end,
  },
  -- speedy add print debug line
  -- TODO: config and learn how to use
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
  -- auto add indent
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    config = function()
      require("plugins.indent")
    end,
  },
  -- auto add close pair
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("plugins.autopairs")
    end,
  },
  -- color highlighting in code
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("plugins.nvchad-colorizer")
    end,
  },
  -- hint the tailwind color
  {
    "js-everts/cmp-tailwind-colors",
    config = true,
  },
  -- conceal long class tailwind
  -- TODO: config and learn how to use
  {
    "razak17/tailwind-fold.nvim",
    opts = {
      min_chars = 50,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
  },
  -- view all apllied tailwind on an element
  -- TODO: config and learn how to use
  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<Leader>cv", "<CMD>TWValues<CR>", desc = "Tailwind CSS values" },
    },
    opts = {
      border = EcoVim.ui.float.border or "rounded", -- Valid window border style,
      show_unknown_classes = true                   -- Shows the unknown classes popup
    }
  },
  -- sorting tailwind class
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
  -- Git sign for added, modified, and removed lines
  -- TODO: config and learn how to use
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
  -- view diff by git
  -- TODO: config and learn how to use
  {
    "sindrets/diffview.nvim",
    lazy = true,
    enabled = true,
    event = "BufRead",
    config = function()
      require("plugins.git.diffview")
    end,
    keys = {
      { "<Leader>gd", "<cmd>lua require('plugins.git.diffview').toggle_file_history()<CR>", desc = "diff file" },
      { "<Leader>gS", "<cmd>lua require('plugins.git.diffview').toggle_status()<CR>",       desc = "status" }
    },
  },
  -- view git conflict visualize
  -- TODO: config and learn how to use
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
  -- manage git worktree
  -- TODO: config and learn how to use
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
  -- the best git integrate for neovim
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
  -- edit and review github issues and pull requests
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "Octo",
    },
    config = function()
      require('plugins.git.octo')
    end
  },

  -- Testing
  -- TODO: config and learn how to use
  -- {
  --   "rcarriga/neotest",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "haydenmeade/neotest-jest",
  --   },
  --   config = function()
  --     require("plugins.neotest")
  --   end,
  -- },
  -- {
  --   "andythigpen/nvim-coverage",
  --   dependencies = "nvim-lua/plenary.nvim",
  --   cmd = {
  --     "Coverage",
  --     "CoverageSummary",
  --     "CoverageLoad",
  --     "CoverageShow",
  --     "CoverageHide",
  --     "CoverageToggle",
  --     "CoverageClear",
  --   },
  --   config = function()
  --     require("coverage").setup()
  --   end,
  -- },

  -- DAP
  -- TODO: config and learn how to use
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
}
