local M = {}

M._cmd = function()
	local default_command = { "bundle", "exec", "rubocop", "--lsp" }

	if Util.has_docker_compose() then
		return vim.list_extend({ "docker", "compose", "run", "--rm", "lsp" }, default_command)
	else
		return default_command
	end
end

M.config = {
	cmd = M._cmd(),
}

return M
