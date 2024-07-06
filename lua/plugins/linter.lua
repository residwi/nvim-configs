return {
	{
		"mfussenegger/nvim-lint",
		event = "LazyFile",
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				sh = { "shellcheck" },
				ruby = { "rubocop" },
				eruby = { "erb_lint" },
				markdown = { "markdownlint" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				python = { "pylint" },
				dockerfile = { "hadolint" },
			}

			lint.linters.rubocop.cmd = "bundle"
			lint.linters.rubocop.args = {
				"exec",
				"rubocop",
				"--format",
				"json",
				"--force-exclusion",
				"--server",
				"--stdin",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
			}

			-- Create autocommand which carries out the actual linting
			-- on the specified events.
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"shellcheck",
				"rubocop",
				"erb-lint",
				"markdownlint",
				"eslint_d",
				"pylint",
				"hadolint",
			},
		},
	},
}
