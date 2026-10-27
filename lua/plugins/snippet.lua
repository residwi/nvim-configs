local function jump(direction)
  local is_active = MiniSnippets.session.get(false) ~= nil
  if is_active then
    MiniSnippets.session.jump(direction)
    return true
  end
end

return {
  -- add mini.snippets
  desc = "Manage and expand snippets (alternative to Luasnip)",
  {
    "nvim-mini/mini.snippets",
    event = "InsertEnter", -- don't depend on other plugins to load...
    dependencies = "rafamadriz/friendly-snippets",
    opts = function()
      Util.cmp.actions.snippet_stop = function() end -- by design, <esc> should not stop the session!
      Util.cmp.actions.snippet_forward = function()
        return jump("next")
      end

      local mini_snippets = require("mini.snippets")
      return {
        snippets = { mini_snippets.gen_loader.from_lang() },

        -- Following the behavior of vim.snippets,
        -- the intended usage of <esc> is to be able to temporarily exit into normal mode for quick edits.
        --
        -- If you'd rather stop the snippet on <esc>, activate the line below in your own config:
        -- mappings = { stop = "<esc>" }, -- <c-c> by default, see :h MiniSnippets-session
      }
    end,
  },

  -- blink.cmp integration: mini.snippets snippets show up in the completion menu
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      snippets = { preset = "mini_snippets" },
    },
  },
}
