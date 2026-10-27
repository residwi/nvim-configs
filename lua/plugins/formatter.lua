return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          Util.format.format({ force = true })
        end,
        mode = { "n", "x" },
        desc = "[C]ode [F]ormat",
      },
    },
    opts = {
      notify_on_error = true,
      default_format_opts = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        go = { "goimports", "gofumpt" },
        ruby = { "rubocop" },
        eruby = { "erb_lint" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        python = { "isort", "black" },
      },
      formatters = {
        -- Use `bundle exec` when the file's project has a Gemfile (resolved per buffer, not from startup cwd)
        rubocop = {
          command = function(_, ctx)
            return vim.fs.root(ctx.dirname, "Gemfile") and "bundle"
              or vim.fn.expand("~/.local/share/mise/shims/rubocop")
          end,
          prepend_args = function(_, ctx)
            return vim.fs.root(ctx.dirname, "Gemfile") and { "exec", "rubocop" } or {}
          end,
          cwd = function(_, ctx)
            return vim.fs.root(ctx.dirname, "Gemfile")
          end,
        },
        erb_lint = {
          stdin = false,
          -- erb_lint exits 1 whenever it found offenses, even after autocorrecting them
          exit_codes = { 0, 1 },
          command = function(_, ctx)
            return vim.fs.root(ctx.dirname, "Gemfile") and "bundle" or "erb_lint"
          end,
          args = function(_, ctx)
            return vim.fs.root(ctx.dirname, "Gemfile") and { "exec", "erb_lint", "--autocorrect", "$FILENAME" }
              or { "--autocorrect", "$FILENAME" }
          end,
          cwd = function(_, ctx)
            return vim.fs.root(ctx.dirname, "Gemfile")
          end,
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      -- Install the conform formatter on VeryLazy
      Util.on_very_lazy(function()
        Util.format.register({
          name = "conform.nvim",
          priority = 100,
          primary = true,
          format = function(buf)
            require("conform").format({ bufnr = buf })
          end,
          sources = function(buf)
            local ret = require("conform").list_formatters(buf)
            ---@param v conform.FormatterInfo
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        })
      end)
    end,
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "prettierd",
        "prettier",
        "isort",
        "black",
        "goimports",
        "gofumpt",
      },
    },
  },
}
