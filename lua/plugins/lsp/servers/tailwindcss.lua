local M = {}

M.config = {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          -- ERB support
          -- https://github.com/tailwindlabs/tailwindcss-intellisense/issues/515#issuecomment-1819593117
          [[\bclass:\s*'([^']*)']],
          [[\bclass:\s*\"([^"]*)"]],
        },
      },
    },
  },
}

return M
