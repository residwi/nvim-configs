return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod" },
    -- Formatting is done by conform (goimports + gofumpt), and inlay hints / codelens by lsp/init.lua (native 0.12).
    -- go.nvim's defaults would turn inlay hints on for every buffer and run its own codelens refresh.
    opts = {
      lsp_inlay_hints = { enable = false },
      lsp_codelens = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          -- Only non-default values; see https://go.dev/gopls/settings
          settings = {
            gopls = {
              gofumpt = true,
              usePlaceholders = true,
              -- other lenses (generate, tidy, vendor, ...) are on by default
              codelenses = { test = true },
              -- https://go.dev/gopls/inlayHints
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                ignoredError = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      },
    },
  },
}
