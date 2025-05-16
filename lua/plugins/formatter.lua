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
				mode = { "n", "v" },
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
				eruby = { "rubocop" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", "markdownlint", stop_after_first = true },
				python = { "isort", "black" },
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
				rubocop = {
					command = "bundle",
					prepend_args = { "exec", "rubocop" },
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
				"rubocop",
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
