return {
	{
		"yioneko/nvim-vtsls",
		lazy = true,
		ft = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		keys = {
			{ "gD", "<cmd>VtsExec goto_source_definition<cr>", desc = "Goto Source Definition" },
			{ "gR", "<cmd>VtsExec file_references<cr>", desc = "File References" },
			{ "<leader>co", "<cmd>VtsExec organize_imports<cr>", desc = "Organize Imports" },
			{ "<leader>cM", "<cmd>VtsExec add_missing_imports<cr>", desc = "Add missing imports" },
			{ "<leader>cu", "<cmd>VtsExec remove_unused_imports<cr>", desc = "Remove unused imports" },
			{ "<leader>cD", "<cmd>VtsExec fix_all<cr>", desc = "Fix all diagnostics" },
			{ "<leader>cV", "<cmd>VtsExec select_ts_version<cr>", desc = "Select TS workspace version" },
		},
		opts = function()
			local settings = {
				complete_function_calls = true,
				vtsls = {
					enableMoveToFileCodeAction = true,
					autoUseWorkspaceTsdk = true,
					experimental = {
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
						variableTypes = { enabled = false },
					},
				},
			}
			-- copy typescript settings to javascript
			settings.javascript = vim.tbl_deep_extend("force", {}, settings.typescript, settings.javascript or {})

			return settings
		end,
		config = function(_, opts)
			require("vtsls").config(opts)
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"vtsls",
			},
		},
	},
}
