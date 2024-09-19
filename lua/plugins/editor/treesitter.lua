return {
  {
  "nvim-treesitter/nvim-treesitter",
  event = "BufReadPre",
  opts = {
    ensure_installed = {
      "typescript",
      "javascript",
      "html",
      "css",
      "vue",
      "gitcommit",
      "graphql",
      "json",
      "json5",
      "lua",
      "markdown",
      "vim",
      "sql",
      "python",
      "dockerfile",
      "yaml",
      "markdown",
      "markdown_inline",
    },                              -- one of "all", or a list of languages
    sync_install = false,           -- install languages synchronously (only applied to `ensure_installed`)
    ignore_install = { "haskell" }, -- list of parsers to ignore installing
    highlight = {
      enable = true,
    },

    incremental_selection = {
      enable = false,
      keymaps = {
        init_selection    = "<leader>gnn",
        node_incremental  = "<leader>gnr",
        scope_incremental = "<leader>gne",
        node_decremental  = "<leader>gnt",
      },
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
        goto_next_start = {
          ["]]"] = "@function.outer",
          ["]m"] = "@class.outer",
        },
        goto_next_end = {
          ["]["] = "@function.outer",
          ["]M"] = "@class.outer",
        },
        goto_previous_start = {
          ["[["] = "@function.outer",
          ["[m"] = "@class.outer",
        },
        goto_previous_end = {
          ["[]"] = "@function.outer",
          ["[M"] = "@class.outer",
        },
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
  },
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
