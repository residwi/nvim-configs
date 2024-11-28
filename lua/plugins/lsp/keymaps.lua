local lsp_util = require("plugins.lsp.util")

local M = {}

---@type LazyKeysLspSpec[]|nil
M._keys = nil

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string|string[], cond?:fun():boolean}
---@alias LazyKeysLsp LazyKeys|{has?:string|string[], cond?:fun():boolean}

---@return LazyKeysLspSpec[]
function M.get()
	if M._keys then
		return M._keys
	end

	local telescope = require("telescope.builtin")

	-- stylua: ignore
	M._keys =  {
		{ "gd", telescope.lsp_definitions, desc = "LSP: [G]oto [D]efinition", has = "definition" },
		{ "gr", telescope.lsp_references, desc = "LSP: [G]oto [R]eferences", nowait = true },
		{ "gI", telescope.lsp_implementations, desc = "LSP: [G]oto [I]mplementation" },
		{ "gy", telescope.lsp_type_definitions, desc = "LSP: [G]oto T[y]pe Definition" },
		{ "gD", vim.lsp.buf.declaration, desc = "LSP: [G]oto [D]eclaration" },
		{ "K", function() return vim.lsp.buf.hover() end, desc = "LSP: Hover" },
		{ "gK", function() return vim.lsp.buf.signature_help() end, desc = "LSP: Signature Help", has = "signatureHelp" },
		{ "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "LSP: Signature Help", has = "signatureHelp" },
		{ "<leader>ca", vim.lsp.buf.code_action, desc = "LSP: [C]ode [A]ction", mode = { "n", "v" }, has = "codeAction" },
		{ "<leader>cc", vim.lsp.codelens.run, desc = "LSP: Run Codelens", mode = { "n", "v" }, has = "codeLens" },
		{ "<leader>cC", vim.lsp.codelens.refresh, desc = "LSP: Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
		{ "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
		{ "<leader>cr", vim.lsp.buf.rename, desc = "LSP: [R]ename", has = "rename" },
		{ "<leader>cA", lsp_util.action.source, desc = "LSP: Source Action", has = "codeAction" },
		{ "<leader>cs", function() telescope.lsp_document_symbols({ symbols = lsp_util.get_kind_filter() }) end, desc = "LSP: Goto [S]ymbol", has = "textDocument/documentSymbol" },
		{ "<leader>cS", function() telescope.lsp_workspace_symbols({ symbols = lsp_util.get_kind_filter() }) end, desc = "LSP: Goto [S]ymbol Workspace", has = "workspace/symbol" },
		{ "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight",
			desc = "LSP: Next Reference", cond = function() return Snacks.words.is_enabled() end },
		{ "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight",
			desc = "LSP: Prev Reference", cond = function() return Snacks.words.is_enabled() end },
		{ "<A-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight",
			desc = "LSP: Next Reference", cond = function() return Snacks.words.is_enabled() end },
		{ "<A-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
			desc = "LSP: Prev Reference", cond = function() return Snacks.words.is_enabled() end },
	}

	return M._keys
end

---@param method string|string[]
function M.has(buffer, method)
	if type(method) == "table" then
		for _, m in ipairs(method) do
			if M.has(buffer, m) then
				return true
			end
		end
		return false
	end
	method = method:find("/") and method or "textDocument/" .. method
	local clients = lsp_util.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

---@return LazyKeysLsp[]
function M.resolve(buffer)
	local Keys = require("lazy.core.handler.keys")
	if not Keys.resolve then
		return {}
	end
	local spec = vim.tbl_extend("force", {}, M.get())
	local opts = Util.opts("nvim-lspconfig")
	local clients = lsp_util.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
		vim.list_extend(spec, maps)
	end
	return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
	local Keys = require("lazy.core.handler.keys")
	local keymaps = M.resolve(buffer)

	for _, keys in pairs(keymaps) do
		local has = not keys.has or M.has(buffer, keys.has)
		local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

		if has and cond then
			local opts = Keys.opts(keys)
			opts.cond = nil
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = buffer
			vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
		end
	end
end

return M
