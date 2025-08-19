-- Set to `false` to prevent "non-lsp snippets"" from appearing inside completion windows
local include_in_completion = true

local function expand_from_lsp(snippet)
  local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
  insert({ body = snippet })
end

local function jump(direction)
  local is_active = MiniSnippets.session.get(false) ~= nil
  if is_active then
    MiniSnippets.session.jump(direction)
    return true
  end
end

---@type fun(snippets, insert) | nil
local expand_select_override = nil

return {
  -- add mini.snippets
  desc = "Manage and expand snippets (alternative to Luasnip)",
  {
    "echasnovski/mini.snippets",
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

        expand = {
          select = function(snippets, insert)
            -- Close completion window on snippet select - vim.ui.select
            -- Needed to remove virtual text for fzf-lua and telescope, but not for mini.pick...
            local select = expand_select_override or MiniSnippets.default_select
            select(snippets, insert)
          end,
        },
      }
    end,
  },

  -- blink.cmp integration
  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      -- Return early
      if include_in_completion then
        opts.snippets = { preset = "mini_snippets" }
        return
      end

      -- Standalone --
      local blink = require("blink.cmp")
      expand_select_override = function(snippets, insert)
        -- Schedule, otherwise blink's virtual text is not removed on vim.ui.select
        blink.cancel()
        vim.schedule(function()
          MiniSnippets.default_select(snippets, insert)
        end)
      end
      --
      -- Blink performs a require on blink.cmp.sources.snippets.default
      -- By removing the source, that default engine will not be used
      opts.sources.default = vim.tbl_filter(function(source)
        return source ~= "snippets"
      end, opts.sources.default)
      opts.snippets = { -- need to repeat blink's preset here
        expand = function(snippet)
          expand_from_lsp(snippet)
          blink.resubscribe()
        end,
        active = function()
          return MiniSnippets.session.get(false) ~= nil
        end,
        jump = function(direction)
          jump(direction == -1 and "prev" or "next")
        end,
      }
    end,
  },
}
