function RubocopConfig()
	local severity_map = {
		["fatal"] = vim.diagnostic.severity.ERROR,
		["error"] = vim.diagnostic.severity.ERROR,
		["warning"] = vim.diagnostic.severity.WARN,
		["convention"] = vim.diagnostic.severity.HINT,
		["refactor"] = vim.diagnostic.severity.INFO,
		["info"] = vim.diagnostic.severity.INFO,
	}

	return {
		cmd = "bundle",
		stdin = true,
		args = {
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
		},
		ignore_exitcode = true,
		parser = function(output)
			local diagnostics = {}
			local decoded = vim.json.decode(output)

			if not decoded.files[1] then
				return diagnostics
			end

			local offences = decoded.files[1].offenses

			for _, off in pairs(offences) do
				table.insert(diagnostics, {
					source = "rubocop",
					lnum = off.location.start_line - 1,
					col = off.location.start_column - 1,
					end_lnum = off.location.last_line - 1,
					end_col = off.location.last_column,
					severity = severity_map[off.severity],
					message = off.message,
					code = off.cop_name,
				})
			end

			return diagnostics
		end,
	}
end

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters.rubocop = RubocopConfig()

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
}
