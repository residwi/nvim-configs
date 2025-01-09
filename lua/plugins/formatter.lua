vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.api.nvim_create_user_command("FormatDiff", function()
	local lines = vim.fn.system("git diff --unified=0"):gmatch("[^\n\r]+")
	local ranges = {}
	for line in lines do
		if line:find("^@@") then
			local line_nums = line:match("%+.- ")
			if line_nums:find(",") then
				local _, _, first, second = line_nums:find("(%d+),(%d+)")
				table.insert(ranges, {
					start = { tonumber(first), 0 },
					["end"] = { tonumber(first) + tonumber(second), 0 },
				})
			else
				local first = tonumber(line_nums:match("%d+"))
				table.insert(ranges, {
					start = { first, 0 },
					["end"] = { first + 1, 0 },
				})
			end
		end
	end
	local format = require("conform").format
	for _, range in pairs(ranges) do
		format({ lsp_format = "fallback", range = range })
	end
end, { desc = "Format changed lines" })

---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
	local conform = require("conform")
	for i = 1, select("#", ...) do
		local formatter = select(i, ...)
		if conform.get_formatter_info(formatter, bufnr).available then
			return formatter
		end
	end
	return select(1, ...)
end

return {
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		lazy = true,
		cmd = "ConformInfo",
		keys = {
			{ "<leader>cf", "<cmd>Format<cr>", mode = { "n", "v" }, desc = "[C]ode [F]ormat" },
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
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				markdown = function(bufnr)
					return { first(bufnr, "prettierd", "prettier"), "markdownlint" }
				end,
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
