local function is_obsidian_note()
  return vim.bo.filetype == "markdown"
      and vim.api.nvim_buf_get_name(0):match('^/Users/destnguyxn/projects/obsidian%-vaults/.+%.md$')
end
local copilot_kind = "Copilot"
local keymap = {
  preset = 'super-tab',
  ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
  ["<C-e>"] = { "hide", "fallback" },
  ["<CR>"] = { "accept", "fallback" },

  ["<Tab>"] = {
    function(cmp)
      return cmp.select_next()
    end,
    "snippet_forward",
    "fallback",
  },
  ["<S-Tab>"] = {
    function(cmp)
      return cmp.select_prev()
    end,
    "snippet_backward",
    "fallback",
  },

  ["<Up>"] = { "select_prev", "fallback" },
  ["<Down>"] = { "select_next", "fallback" },
  ["<C-p>"] = { "select_prev", "fallback" },
  ["<C-n>"] = { "select_next", "fallback" },
  ["<C-k>"] = { "scroll_documentation_up", "fallback" },
  ["<C-j>"] = { "scroll_documentation_down", "fallback" },
}
---@module 'blink.cmp'
---@diagnostic disable-next-line: undefined-doc-name
---@type blink.cmp.Config
require("blink.cmp").setup({
  enabled = function()
    return not vim.tbl_contains(
          { "snacks_input", "prompts", "help", "lazy", "Oil", "neo-tree", "dashboard", "packer", "startify", "fzf",
            "fugitive", "spectre_panel",
            "DressingInput" }, vim.bo.filetype)
        and vim.bo.buftype ~= "prompt"
        and vim.b.completion ~= false
  end,
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = "mono",
  },

  cmdline = { enabled = false },
  completion = {
    accept = { auto_brackets = { enabled = true } },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 100,
      treesitter_highlighting = true,
      window = { border = "rounded" },
    },
    list = {
      cycle = {
        from_top = true,
        from_bottom = true,
      },
      selection = {
        preselect = true,
        auto_insert = true,
      },
    },
    menu = {
      border = "rounded",

      cmdline_position = function()
        if vim.g.ui_cmdline_pos ~= nil then
          local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
          return { pos[1] - 1, pos[2] }
        end
        local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
        return { vim.o.lines - height, 0 }
      end,

      draw = {
        columns = {
          { "kind_icon", "label", gap = 1 },
          { "kind" },
        },
        components = {
          kind_icon = {
            ellipsis = false,
            -- Attempt to use mini.icons
            text = function(ctx)
              if ctx.kind == copilot_kind then
                return DestNgxVim.icons[copilot_kind] or ""
              end
              local kind_icon, _, _ = require("mini.icons").get('lsp', ctx.kind)
              return kind_icon
            end,
            highlight = function(ctx)
              local _, hl, _ = require("mini.icons").get('lsp', ctx.kind)
              return hl
            end
          },
          label = {
            width = { fill = true, max = 60 },
            text = function(ctx)
              return require("colorful-menu").blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return require("colorful-menu").blink_components_highlight(ctx)
            end,
          },
          kind = {
            text = function(item)
              return item.kind
            end,
            highlight = "CmpItemKind",
          },
        },
      },
    },

    ghost_text = {
      enabled = DestNgxVim.plugins.completion.ghost_text,
    },
  },

  keymap = keymap,

  -- Experimental signature help support
  signature = {
    -- TODO: I already have this, by config the lsp server, which one is better?
    -- disable because of duplication
    enabled = false,
    window = { border = "rounded" },
  },

  sources = {
    default = function()
      local default_source = { "lsp", "path", "snippets", "buffer", "copilot", "codecompanion", "calc", "git", "npm", "ecolog" }
      return is_obsidian_note() and
          vim.list_extend(default_source, { "obsidian", "obsidian_new", "obsidian_tags" }) or default_source
    end,
    providers = {
      ecolog  = { name = 'ecolog', module = 'ecolog.integrations.cmp.blink_cmp' },
      obsidian = {
        name = "obsidian",
        module = "blink.compat.source",
        min_keyword_length = 1,
      },
      obsidian_new = {
        name = "obsidian_new",
        module = "blink.compat.source",
        min_keyword_length = 1,
      },
      obsidian_tags = {
        name = "obsidian_tags",
        module = "blink.compat.source",
        min_keyword_length = 1,
      },
      calc = { name = "calc", module = "blink.compat.source", min_keyword_length = 3 },
      git = { name = "git", module = "blink.compat.source" },
      npm = {
        name = "npm",
        module = "blink.compat.source",
        opts = {
          ignore = {},
          only_semantic_versions = true,
        }
      },
      codecompanion = {
        name = "CodeCompanion",
        module = "codecompanion.providers.completion.blink",
        enabled = true,
        min_keyword_length = 0,
        score_offset = 100,
      },
      copilot = {
        name = "copilot",
        module = "blink-cmp-copilot",
        min_keyword_length = 0,
        score_offset = 100,
        async = true,
        -- set position for copilot suggestions at first row
        transform_items = function(_, items)
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1
          CompletionItemKind[kind_idx] = copilot_kind
          for _, item in ipairs(items) do
            item.kind = kind_idx
          end
          return items
        end,
      },
      lsp = {
        min_keyword_length = 0, -- Number of characters to trigger porvider
        score_offset = 0,       -- Boost/penalize the score of the items
      },
      path = {
        min_keyword_length = 0,
      },
      snippets = {
        min_keyword_length = 3,
      },
      buffer = {
        min_keyword_length = 3,
        max_items = 5,
      },
    },
  },
})
