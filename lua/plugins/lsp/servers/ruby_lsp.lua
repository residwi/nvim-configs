local M = {}

M._cmd = function()
	if Util.has_docker_compose() then
		return { "docker", "compose", "run", "--rm", "lsp", "bundle", "exec", "ruby-lsp" }
	else
		return { vim.fn.expand("~/.asdf/shims/ruby-lsp") }
	end
end

M.config = {
	mason = false,
	cmd = M._cmd(),
}

return M
