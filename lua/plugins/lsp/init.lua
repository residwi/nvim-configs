local diagnotics_icons = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile", "BufWritePre" },
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			"mason.nvim", -- NOTE: Must be loaded before dependants
			{ "mason-org/mason-lspconfig.nvim", config = function() end },

			-- Useful status updates for LSP.
			-- NOTE: `opts = {}` is the same as calling `require("fidget").setup({})`
			{ "j-hui/fidget.nvim", opts = {} },
		},
		opts = {
			-- options for vim.diagnostic.config()
			---@type vim.diagnostic.Opts
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "icons",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = diagnotics_icons.Error,
						[vim.diagnostic.severity.WARN] = diagnotics_icons.Warn,
						[vim.diagnostic.severity.HINT] = diagnotics_icons.Hint,
						[vim.diagnostic.severity.INFO] = diagnotics_icons.Info,
					},
				},
			},
			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = true,
				exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
			},
			-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the code lenses.
			codelens = {
				enabled = false,
			},
			-- add any global capabilities here
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			servers = {
				"gopls",
				"ruby_lsp",
				"rubocop",
				"tailwindcss",
				"html",
				"cssls",
				"dockerls",
				"docker_compose_language_service",
				"lua_ls",
				"eslint",
				"jsonls",
				"yamlls",
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},

		config = function(_, opts)
			local lsp_util = require("plugins.lsp.util")
			Util.format.register(lsp_util.formatter())

			-- setup keymaps
			lsp_util.on_attach(function(client, buffer)
				require("plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			lsp_util.setup()
			lsp_util.on_dynamic_capability(require("plugins.lsp.keymaps").on_attach)

			-- inlay hints
			if opts.inlay_hints.enabled then
				lsp_util.on_supports_method("textDocument/inlayHint", function(client, buffer)
					if
						vim.api.nvim_buf_is_valid(buffer)
						and vim.bo[buffer].buftype == ""
						and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
					end
				end)
			end

			-- code lens
			if opts.codelens.enabled and vim.lsp.codelens then
				lsp_util.on_supports_method("textDocument/codeLens", function(client, buffer)
					vim.lsp.codelens.refresh()
					vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
						buffer = buffer,
						callback = vim.lsp.codelens.refresh,
					})
				end)
			end

			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = function(diagnostic)
					for d, icon in pairs(diagnotics_icons) do
						if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
							return icon
						end
					end
				end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = {}
			for _, server in ipairs(opts.servers) do
				local exists, lsp = pcall(require, "plugins.lsp.servers." .. server)
				servers[server] = exists and lsp.config or {}
			end

			local has_blink, blink = pcall(require, "blink.cmp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_blink and blink.get_lsp_capabilities() or {},
				opts.capabilities or {}
			)

			-- get all the servers that are available through mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers =
					vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
			end

			local exclude_automatic_enable = {} ---@type string[]

			local function configure(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return true
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return true
					end
				end

				vim.lsp.config(server, server_opts)

				-- manually enable if mason=false or if this is a server that cannot be installed with mason-lspconfig
				if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
					vim.lsp.enable(server)

					return true
				end

				return false
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					if server_opts.enabled ~= false then
						-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
						if configure(server) then
							exclude_automatic_enable[#exclude_automatic_enable + 1] = server
						else
							ensure_installed[#ensure_installed + 1] = server
						end
					else
						exclude_automatic_enable[#exclude_automatic_enable + 1] = server
					end
				end
			end

			if have_mason then
				mlsp.setup({
					ensure_installed = vim.tbl_deep_extend(
						"force",
						ensure_installed,
						Util.opts("mason-lspconfig.nvim").ensure_installed or {}
					),
					automatic_enable = {
						exclude = exclude_automatic_enable,
					},
				})
			end
		end,
	},
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
		version = false,
	},
}
