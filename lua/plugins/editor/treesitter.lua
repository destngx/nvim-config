return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "typescript",
          "javascript",
          "html",
          "css",
          "gitcommit",
          "json",
          "json5",
          "lua",
          "vim",
          "sql",
          "python",
          "dockerfile",
          "yaml",
          "markdown",
          "markdown_inline",
          "diff",
          "terraform",
          "hcl",
          "helm"
        },                            -- one of "all", or a list of languages
        sync_install = false,         -- install languages synchronously (only applied to `ensure_installed`)
        ignore_install = { "haskell" }, -- list of parsers to ignore installing
        highlight = {
          enable = true,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection    = "<leader>gnn",
            node_incremental  = "<leader>gnr",
            scope_incremental = "<leader>gne",
            node_decremental  = "<leader>gnt",
          },
        },

        matchup = {
          enable = true,
        },
        autotag = {
          enable = true
        },

        markid = {
          enable = true
        },

        indent = {
          enable = true
        },

        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
          },
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["~"] = "@parameter.inner",
            },
          },
        },

        textsubjects = {
          enable = true,
          previous_selection = '<BS>',
          keymaps = {
            ['<CR>'] = 'textsubjects-smart', -- works in visual mode
          }
        },
      }
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
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = function()
      require("treesitter-context").setup {
        max_lines = 4,
      }
    end,
  },
}
