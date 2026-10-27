return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        "lazy.nvim",
        -- `vim.uv` types ship with Neovim 0.12 ($VIMRUNTIME/lua/uv/_meta.lua)
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
}
