---@class lsp.util
local M = {}

M.kind_filter = {
	default = {
		"Class",
		"Constructor",
		"Enum",
		"Field",
		"Function",
		"Interface",
		"Method",
		"Module",
		"Namespace",
		"Package",
		"Property",
		"Struct",
		"Trait",
	},
	markdown = false,
	help = false,
	-- you can specify a different filter for each filetype
	lua = {
		"Class",
		"Constructor",
		"Enum",
		"Field",
		"Function",
		"Interface",
		"Method",
		"Module",
		"Namespace",
		-- "Package", -- remove package since luals uses it for control flow structures
		"Property",
		"Struct",
		"Trait",
	},
}

---@param buf? number
---@return string[]?
function M.get_kind_filter(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	local ft = vim.bo[buf].filetype
	if M.kind_filter == false then
		return
	end
	if M.kind_filter[ft] == false then
		return
	end
	if type(M.kind_filter[ft]) == "table" then
		return M.kind_filter[ft]
	end
	---@diagnostic disable-next-line: return-type-mismatch
	return type(M.kind_filter) == "table" and type(M.kind_filter.default) == "table" and M.kind_filter.default or nil
end

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: vim.lsp.Client):boolean}
---@param opts? lsp.Client.filter
function M.get_clients(opts)
	local ret = {} ---@type vim.lsp.Client[]
	if vim.lsp.get_clients then
		ret = vim.lsp.get_clients(opts)
	else
		---@diagnostic disable-next-line: deprecated
		ret = vim.lsp.get_active_clients(opts)
		if opts and opts.method then
			---@param client vim.lsp.Client
			ret = vim.tbl_filter(function(client)
				return client.supports_method(opts.method, opts.bufnr)
			end, ret)
		end
	end
	return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.on_attach(on_attach, name)
	return vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf ---@type number
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client and (not name or client.name == name) then
				return on_attach(client, buffer)
			end
		end,
	})
end

---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
M._supports_method = {}

function M.setup()
	local register_capability = vim.lsp.handlers["client/registerCapability"]
	vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
		---@diagnostic disable-next-line: no-unknown
		local ret = register_capability(err, res, ctx)
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		if client then
			for buffer in pairs(client.attached_buffers) do
				vim.api.nvim_exec_autocmds("User", {
					pattern = "LspDynamicCapability",
					data = { client_id = client.id, buffer = buffer },
				})
			end
		end
		return ret
	end
	M.on_attach(M._check_methods)
	M.on_dynamic_capability(M._check_methods)
end

---@param client vim.lsp.Client
function M._check_methods(client, buffer)
	-- don't trigger on invalid buffers
	if not vim.api.nvim_buf_is_valid(buffer) then
		return
	end
	-- don't trigger on non-listed buffers
	if not vim.bo[buffer].buflisted then
		return
	end
	-- don't trigger on nofile buffers
	if vim.bo[buffer].buftype == "nofile" then
		return
	end
	for method, clients in pairs(M._supports_method) do
		clients[client] = clients[client] or {}
		if not clients[client][buffer] then
			if client.supports_method and client.supports_method(method, buffer) then
				clients[client][buffer] = true
				vim.api.nvim_exec_autocmds("User", {
					pattern = "LspSupportsMethod",
					data = { client_id = client.id, buffer = buffer, method = method },
				})
			end
		end
	end
end

---@param fn fun(client:vim.lsp.Client, buffer):boolean?
---@param opts? {group?: integer}
function M.on_dynamic_capability(fn, opts)
	return vim.api.nvim_create_autocmd("User", {
		pattern = "LspDynamicCapability",
		group = opts and opts.group or nil,
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local buffer = args.data.buffer ---@type number
			if client then
				return fn(client, buffer)
			end
		end,
	})
end

---@param method string
---@param fn fun(client:vim.lsp.Client, buffer)
function M.on_supports_method(method, fn)
	M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
	return vim.api.nvim_create_autocmd("User", {
		pattern = "LspSupportsMethod",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local buffer = args.data.buffer ---@type number
			if client and method == args.data.method then
				return fn(client, buffer)
			end
		end,
	})
end

---@return lspconfig.options
function M.get_config(server)
	local configs = require("lspconfig.configs")
	return rawget(configs, server)
end

---@return {default_config:lspconfig.Config}
function M.get_raw_config(server)
	local ok, ret = pcall(require, "lspconfig.configs." .. server)
	if ok then
		return ret
	end
	return require("lspconfig.server_configurations." .. server)
end

function M.is_enabled(server)
	local c = M.get_config(server)
	return c and c.enabled ~= false
end

---@param server string
---@param cond fun( root_dir, config): boolean
function M.disable(server, cond)
	local util = require("lspconfig.util")
	local def = M.get_config(server)
	---@diagnostic disable-next-line: undefined-field
	def.document_config.on_new_config = util.add_hook_before(
		def.document_config.on_new_config,
		function(config, root_dir)
			if cond(root_dir, config) then
				config.enabled = false
			end
		end
	)
end

---@param opts? LazyFormatter| {filter?: (string|lsp.Client.filter)}
function M.formatter(opts)
	opts = opts or {}
	local filter = opts.filter or {}
	filter = type(filter) == "string" and { name = filter } or filter
	---@cast filter lsp.Client.filter
	---@type LazyFormatter
	local ret = {
		name = "LSP",
		primary = true,
		priority = 1,
		format = function(buf)
			M.format(Util.merge({}, filter, { bufnr = buf }))
		end,
		sources = function(buf)
			local clients = M.get_clients(Util.merge({}, filter, { bufnr = buf }))
			---@param client vim.lsp.Client
			local ret = vim.tbl_filter(function(client)
				return client.supports_method("textDocument/formatting", buf)
					or client.supports_method("textDocument/rangeFormatting", buf)
			end, clients)
			---@param client vim.lsp.Client
			return vim.tbl_map(function(client)
				return client.name
			end, ret)
		end,
	}
	return Util.merge(ret, opts) --[[@as LazyFormatter]]
end

---@alias lsp.Client.format {timeout_ms?: number, format_options?: table} | lsp.Client.filter

---@param opts? lsp.Client.format
function M.format(opts)
	opts = vim.tbl_deep_extend(
		"force",
		{},
		opts or {},
		Util.opts("nvim-lspconfig").format or {},
		Util.opts("conform.nvim").format or {}
	)
	local ok, conform = pcall(require, "conform")
	-- use conform for formatting with LSP when available,
	-- since it has better format diffing
	if ok then
		opts.formatters = {}
		conform.format(opts)
	else
		vim.lsp.buf.format(opts)
	end
end

M.action = setmetatable({}, {
	__index = function(_, action)
		return function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { action },
					diagnostics = {},
				},
			})
		end
	end,
})

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

---@param opts LspCommand
function M.execute(opts)
	local params = {
		command = opts.command,
		arguments = opts.arguments,
	}
	if opts.open then
		require("trouble").open({
			mode = "lsp_command",
			params = params,
		})
	else
		return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
	end
end

return M
