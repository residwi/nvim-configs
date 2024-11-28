local M = {}

M.config = {
	-- mason = false, -- set to false if you don't want this server to be installed with mason

	-- Use this to add any additional keymaps
	-- for specific lsp servers
	---@type LazyKeysSpec[]
	-- keys = {},

	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
			},
			codeLens = {
				enable = true,
			},
			completion = {
				callSnippet = "Replace",
			},
			doc = {
				privateName = { "^_" },
			},
			hint = {
				enable = true,
				setType = false,
				paramType = true,
				paramName = "Disable",
				semicolon = "Disable",
				arrayIndex = "Disable",
			},
			diagnostics = {
				-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				-- disable = { "missing-fields" },
				globals = { "vim" },
			},
		},
	},
}

return M
