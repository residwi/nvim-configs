return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      custom_highlights = function(C)
        -- https://github.com/catppuccin/nvim/pull/804#pullrequestreview-3080755868
        local O = require("catppuccin").options
        return {
          ["@variable.member"] = { fg = C.lavender }, -- For fields.
          ["@module"] = { fg = C.lavender, style = O.styles.miscs or { "italic" } }, -- For identifiers referring to modules and namespaces.
          ["@string.special.url"] = { fg = C.rosewater, style = { "italic", "underline" } }, -- urls, links and emails
          ["@type.builtin"] = { fg = C.yellow, style = O.styles.properties or { "italic" } }, -- For builtin types.
          ["@property"] = { fg = C.lavender, style = O.styles.properties or {} }, -- Same as TSField.
          ["@constructor"] = { fg = C.sapphire }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
          ["@keyword.operator"] = { link = "Operator" }, -- For new keyword operator
          ["@keyword.export"] = { fg = C.sky, style = O.styles.keywords },
          ["@markup.strong"] = { fg = C.maroon, style = { "bold" } }, -- bold
          ["@markup.italic"] = { fg = C.maroon, style = { "italic" } }, -- italic
          ["@markup.heading"] = { fg = C.blue, style = { "bold" } }, -- titles like: # Example
          ["@markup.quote"] = { fg = C.maroon, style = { "bold" } }, -- block quotes
          ["@markup.link"] = { link = "Tag" }, -- text references, footnotes, citations, etc.
          ["@markup.link.label"] = { link = "Label" }, -- link, reference descriptions
          ["@markup.link.url"] = { fg = C.rosewater, style = { "italic", "underline" } }, -- urls, links and emails
          ["@markup.raw"] = { fg = C.teal }, -- used for inline code in markdown and for doc in python (""")
          ["@markup.list"] = { link = "Special" },
          ["@tag"] = { fg = C.mauve }, -- Tags like html tag names.
          ["@tag.attribute"] = { fg = C.teal, style = O.styles.miscs or { "italic" } }, -- Tags like html tag names.
          ["@tag.delimiter"] = { fg = C.sky }, -- Tag delimiter like < > /
          ["@property.css"] = { fg = C.lavender },
          ["@property.id.css"] = { fg = C.blue },
          ["@type.tag.css"] = { fg = C.mauve },
          ["@string.plain.css"] = { fg = C.peach },
          ["@constructor.lua"] = { fg = C.flamingo }, -- For constructor calls and definitions: = { } in Lua.
          -- typescript
          ["@property.typescript"] = { fg = C.lavender, style = O.styles.properties or {} },
          ["@constructor.typescript"] = { fg = C.lavender },
          -- TSX (Typescript React)
          ["@constructor.tsx"] = { fg = C.lavender },
          ["@tag.attribute.tsx"] = { fg = C.teal, style = O.styles.miscs or { "italic" } },
          ["@type.builtin.c"] = { fg = C.yellow, style = {} },
          ["@type.builtin.cpp"] = { fg = C.yellow, style = {} },
        }
      end,
      float = { transparent = true },
      integrations = {
        lsp_trouble = true,
        mason = true,
        native_lsp = {
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
            ok = { "undercurl" },
          },
        },
        snacks = {
          enabled = true,
          indent_scope_color = "overlay0",
        },
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {},
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    config = function()
      local color = require("onedarkpro.helpers")

      require("onedarkpro").setup({
        colors = {
          onedark = { bg = "#1a212e" },
          dark = {
            telescope_selection = color.lighten("bg", 2, "onedark"),
          },
        },
        highlights = {
          -- Telescope
          TelescopeBorder = { fg = "${orange}", bg = "${float_bg}" },
          TelescopePromptCounter = { bg = "${float_bg}", fg = "${gray}" },
          TelescopePromptPrefix = { fg = "${blue}" },
          TelescopeSelectionCaret = { fg = "${blue}" },
          TelescopeSelection = { bg = "${telescope_selection}" },

          -- Editor
          Cursor = { bg = color.lighten("white", 2, "onedark"), fg = "${bg}" },
          CursorLineNr = { fg = "${blue}" },

          -- Ruby
          ["@string.special.symbol.ruby"] = { fg = "${cyan}" },
          ["@variable.ruby"] = { fg = "${fg}" },
          ["@variable.parameter.ruby"] = { link = "@variable.ruby" },
          ["@lsp.type.variable.ruby"] = { link = "@variable.ruby" },
        },
      })
    end,
  },
  {
    "navarasu/onedark.nvim",
    lazy = true,
    config = function()
      require("onedark").setup({
        style = "deep",
      })
    end,
  },
}
