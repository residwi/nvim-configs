local M = {}

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

function M.opts(name)
	local plugin = require("lazy.core.config").spec.plugins[name]
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

function M.has_docker_compose()
	local docker_compose_files = { "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml" }
	return vim.fs.root(0, docker_compose_files)
end

return M
