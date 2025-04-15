local LazyUtil = require("lazy.core.util")
local M = {}

setmetatable(M, {
	__index = function(t, k)
		if LazyUtil[k] then
			return LazyUtil[k]
		end

		t[k] = require("utils." .. k)
		return t[k]
	end,
})

function M.is_win()
	return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

function M.is_loaded(name)
	local Config = require("lazy.core.config")
	return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
	if M.is_loaded(name) then
		fn(name)
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	end
end

function M.dedup(list)
	local ret = {}
	local seen = {}
	for _, v in ipairs(list) do
		if not seen[v] then
			table.insert(ret, v)
			seen[v] = true
		end
	end
	return ret
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
	if vim.api.nvim_get_mode().mode == "i" then
		vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
	end
end

function M.opts(name)
	local plugin = require("lazy.core.config").spec.plugins[name]
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

---@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

return M
