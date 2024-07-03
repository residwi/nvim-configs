return {
	"stevearc/conform.nvim",
	lazy = false,
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
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

		formatters = {
			rubocop = {
				command = "bundle",
				prepend_args = { "exec", "rubocop" },
			},
		},

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
	},
	config = function()
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
}
