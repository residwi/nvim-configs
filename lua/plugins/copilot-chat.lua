return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = "CopilotChat",
    build = "make tiktoken", -- Only on MacOS or Linux
    event = "VeryLazy",
    opts = function()
      local user = vim.env.USER or "User"
      return {
        window = {
          width = 0.4,
        },
        headers = {
          user = "  " .. user .. "  ",
          assistant = "  Copilot  ",
          tool = "  Tool  ",
        },
        auto_insert_mode = true,
        show_folds = false, -- Disable folding for cleaner look
        prompts = {
          -- Code related prompts
          Refactor = {
            prompt = "/COPILOT_BASE\n\nPlease refactor the following code to improve its clarity and readability.",
          },
          FixError = {
            prompt = "/COPILOT_INSTRUCTIONS\n\nPlease explain the error in the following code and provide a solution.",
          },
          BetterNamings = {
            prompt = "/COPILOT_INSTRUCTIONS\n\nPlease provide better names for the following variables and functions.",
          },

          -- Text related prompts
          Summarize = {
            prompt = "Please summarize the following text.",
          },
          Spelling = {
            prompt = "Please correct any grammar and spelling errors in the following text.",
          },
          Wording = {
            prompt = "Please improve the grammar and wording of the following text.",
          },
          Concise = {
            prompt = "Please rewrite the following text to make it more concise.",
          },
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
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" },
      },
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

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.conceallevel = 0
        end,
      })

      chat.setup(opts)
    end,
  },
}
