return {
  {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      -- neo-tree windows can't be restored from a session, they come back as a dead buffer
      close_filetypes_on_save = { "checkhealth", "neo-tree" },
      -- don't load telescope at startup just to register `:Telescope session-lens`;
      -- `:AutoSession search` still opens the picker on demand
      session_lens = { load_on_setup = false },
    },
  },
}
