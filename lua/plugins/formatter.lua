local function rubocop_config()
	local default_command = { command = "bundle", prepend_args = { "exec", "rubocop" } }

	if Util.has_docker_compose() then
		local combined_command = vim.list_extend({ default_command.command }, default_command.prepend_args)
		local combined_args = vim.list_extend({ "compose", "exec", "lsp" }, combined_command)

		return { command = "docker", prepend_args = combined_args }
	else
		return default_command
	end
end

return {
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		lazy = true,
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = true,
			format_on_save = function(bufnr)
				-- Disable autoformat on certain filetypes for languages that don't
				-- have a well standardized coding style.
				local disable_filetypes = { "c", "cpp" }
				if vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
					return
				end

				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end

				return { timeout_ms = 500, lsp_format = "fallback" }
			end,

			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
				go = { "goimports", "gofumpt" },
				ruby = { "rubocop" },
				eruby = { "rubocop" },
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				css = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
				json = { { "prettierd", "prettier" } },
				yaml = { { "prettierd", "prettier" } },
				markdown = { { "prettierd", "prettier" }, "markdownlint" },
				python = { "isort", "black" },
			},

			formatters = {
				injected = { options = { ignore_errors = true } },
				rubocop = rubocop_config(),
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		config = function(_, opts)
			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
					Snacks.notify.info("Disabled auto-formatting on this buffer")
				else
					vim.g.disable_autoformat = true
					Snacks.notify.info("Disabled auto-formatting on global")
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})

			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false

				Snacks.notify.info("Enabled auto-formatting on global")
			end, {
				desc = "Re-enable autoformat-on-save",
			})

			require("conform").setup(opts)
		end,
	},
	{
		"williamboman/mason.nvim",
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
