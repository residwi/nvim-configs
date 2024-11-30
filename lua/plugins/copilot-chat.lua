local M = {}

---@param kind string
function M.pick(kind)
	return function()
		local actions = require("CopilotChat.actions")
		local items = actions[kind .. "_actions"]()
		if not items then
			Snacks.notify.warn("No " .. kind .. " found on the current line")
			return
		end
		require("CopilotChat.integrations.telescope").pick(items)
	end
end

local prompts = {
	-- Code related prompts
	Refactor = "/COPILOT_GENERATE\n\nPlease refactor the following code to improve its clarity and readability.",
	FixError = "Please explain the error in the following text and provide a solution.",
	BetterNamings = "Please provide better names for the following variables and functions.",
	-- Text related prompts
	Summarize = "Please summarize the following text.",
	Spelling = "Please correct any grammar and spelling errors in the following text.",
	Wording = "Please improve the grammar and wording of the following text.",
	Concise = "Please rewrite the following text to make it more concise.",
}

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		cmd = "CopilotChat",
		build = "make tiktoken", -- Only on MacOS or Linux
		event = "VeryLazy",
		opts = function()
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			return {
				auto_insert_mode = true,
				show_help = true,
				question_header = "  " .. user .. " ",
				answer_header = "  Copilot ",
				prompts = prompts,
				window = {
					width = 0.4,
				},
			}
		end,
		keys = {
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>aa",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "Clear (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input)
					end
				end,
				desc = "Quick Chat (CopilotChat)",
				mode = { "n", "v" },
			},
			{ "<leader>aQ", "<cmd>CopilotChatInline<cr>", mode = "x", desc = "Inline chat (CopilotChat)" },
			-- Show prompts actions with telescope
			{ "<leader>ap", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
			-- Generate commit message based on the git diff
			{
				"<leader>ac",
				"<cmd>CopilotChatCommit<cr>",
				desc = "Generate commit message for all changes (CopilotChat)",
			},
			-- Code related commands
			{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "Explain code (CopilotChat)" },
			{ "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "Generate tests (CopilotChat)" },
			{ "<leader>aR", "<cmd>CopilotChatReview<cr>", desc = "Review code (CopilotChat)" },
			{ "<leader>ar", "<cmd>CopilotChatRefactor<cr>", desc = "Refactor code (CopilotChat)" },
			{ "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "Better Naming (CopilotChat)" },
			-- Debug
			{ "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "Debug Info (CopilotChat)" },
			-- Fix the issue with diagnostic
			{ "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "Fix (CopilotChat)" },
			-- Copilot Chat Models
			{ "<leader>am", "<cmd>CopilotChatModels<cr>", desc = "Select Models (CopilotChat)" },
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")

			chat.setup(opts)

			-- Inline chat with Copilot
			vim.api.nvim_create_user_command("CopilotChatInline", function(args)
				chat.ask(args.args, {
					selection = select.visual,
					window = {
						layout = "float",
						relative = "cursor",
						width = 1,
						height = 0.4,
						row = 1,
					},
				})
			end, { nargs = "*", range = true })
		end,
	},
}
