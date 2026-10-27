local settings = {
  vtsls = {
    enableMoveToFileCodeAction = true,
    autoUseWorkspaceTsdk = true,
    experimental = {
      maxInlayHintLength = 30,
      completion = {
        enableServerSideFuzzyMatch = true,
      },
    },
  },
  typescript = {
    updateImportsOnFileMove = { enabled = "always" },
    suggest = {
      completeFunctionCalls = true,
    },
    inlayHints = {
      enumMemberValues = { enabled = true },
      functionLikeReturnTypes = { enabled = true },
      parameterNames = { enabled = "literals" },
      parameterTypes = { enabled = true },
      propertyDeclarationTypes = { enabled = true },
    },
  },
}
-- copy typescript settings to javascript
settings.javascript = vim.tbl_deep_extend("force", {}, settings.typescript, settings.javascript or {})

return {
  -- Provides `:VtsExec` in vtsls buffers
  {
    "yioneko/nvim-vtsls",
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          -- server settings must live in the LSP config; `require("vtsls").config()` only takes plugin options
          settings = settings,
          -- buffer-local, only where vtsls is attached
          keys = {
            { "gD", "<cmd>VtsExec goto_source_definition<cr>", desc = "Goto Source Definition" },
            { "gR", "<cmd>VtsExec file_references<cr>", desc = "File References" },
            { "<leader>co", "<cmd>VtsExec organize_imports<cr>", desc = "Organize Imports" },
            { "<leader>cM", "<cmd>VtsExec add_missing_imports<cr>", desc = "Add missing imports" },
            { "<leader>cu", "<cmd>VtsExec remove_unused_imports<cr>", desc = "Remove unused imports" },
            { "<leader>cD", "<cmd>VtsExec fix_all<cr>", desc = "Fix all diagnostics" },
            { "<leader>cV", "<cmd>VtsExec select_ts_version<cr>", desc = "Select TS workspace version" },
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "vtsls",
      },
    },
  },
}
