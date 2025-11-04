local diagnotics_icons = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

local lsp_util = require("plugins.lsp.util")

return {
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      "mason.nvim", -- NOTE: Must be loaded before dependants
      { "mason-org/mason-lspconfig.nvim", config = function() end },

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require("fidget").setup({})`
      { "j-hui/fidget.nvim", opts = {} },
    },
    opts_extend = { "servers.*.keys" },
    opts = {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "icons",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = diagnotics_icons.Error,
            [vim.diagnostic.severity.WARN] = diagnotics_icons.Warn,
            [vim.diagnostic.severity.HINT] = diagnotics_icons.Hint,
            [vim.diagnostic.severity.INFO] = diagnotics_icons.Info,
          },
        },
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim.
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = true,
        exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
      },
      -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the code lenses.
      codelens = {
        enabled = false,
      },
      -- Enable this to enable the builtin LSP folding on Neovim.
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the folds.
      folds = {
        enabled = true,
      },
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      -- Sets the default configuration for an LSP client (or all clients if the special name "*" is used).
      ---@type table<string, vim.lsp.Config|{mason?:boolean, enabled?:boolean}|boolean>
      servers = {
        -- configuration for all lsp servers
        ["*"] = {
          capabilities = {
            workspace = {
              fileOperations = {
                didRename = true,
                willRename = true,
              },
            },
          },
          -- stylua: ignore
          keys = {
            { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
            { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
            { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
            { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
            { "gD", vim.lsp.buf.declaration, desc = "LSP: [G]oto [D]eclaration" },
            { "K", function() return vim.lsp.buf.hover() end, desc = "LSP: Hover" },
            { "gK", function() return vim.lsp.buf.signature_help() end, desc = "LSP: Signature Help", has = "signatureHelp" },
            { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "LSP: Signature Help", has = "signatureHelp" },
            { "<leader>ca", vim.lsp.buf.code_action, desc = "LSP: [C]ode [A]ction", mode = { "n", "x" }, has = "codeAction" },
            { "<leader>cc", vim.lsp.codelens.run, desc = "LSP: Run Codelens", mode = { "n", "x" }, has = "codeLens" },
            { "<leader>cC", vim.lsp.codelens.refresh, desc = "LSP: Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
            { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode = {"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
            { "<leader>cr", vim.lsp.buf.rename, desc = "LSP: [R]ename", has = "rename" },
            { "<leader>cA", lsp_util.action.source, desc = "LSP: Source Action", has = "codeAction" },
            { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight", desc = "LSP: Next Reference", enabled = function() return Snacks.words.is_enabled() end },
            { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight", desc = "LSP: Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
            { "<A-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight", desc = "LSP: Next Reference", enabled = function() return Snacks.words.is_enabled() end },
            { "<A-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight", desc = "LSP: Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
          },
        },
        gopls = {},
        ruby_lsp = {
          mason = false,
          cmd = { vim.fn.expand("~/.asdf/shims/ruby-lsp") },
        },
        rubocop = {
          mason = false,
          -- Only run rubocop if a Gemfile is present in the project root
          cmd = vim.fn.filereadable(vim.fs.joinpath(vim.fn.getcwd(), "Gemfile")) == 1
              and { "bundle", "exec", "rubocop", "--lsp" }
            or { vim.fn.expand("~/.asdf/shims/rubocop"), "--lsp" },
        },
        tailwindcss = {
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
        },
        html = {},
        cssls = {},
        dockerls = {},
        docker_compose_language_service = {},
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason

          -- Use this to add any additional keymaps
          -- for specific lsp servers
          ---@type LazyKeysSpec[]
          -- keys = {},

          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              diagnostics = {
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- disable = { "missing-fields" },
                globals = { "vim" },
              },
            },
          },
        },
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
        jsonls = {
          before_init = function(_, new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              validate = { enable = true },
              format = { enable = true },
            },
          },
        },
        yamlls = {
          -- Have to add this for yamlls to understand that we support line folding
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- lazy-load schemastore when needed
          before_init = function(_, new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },

    config = vim.schedule_wrap(function(_, opts)
      -- setup autoformat
      Util.format.register(lsp_util.formatter())

      -- setup keymaps
      for server, server_opts in pairs(opts.servers) do
        if type(server_opts) == "table" and server_opts.keys then
          require("plugins.lsp.keymaps").set({ name = server ~= "*" and server or nil }, server_opts.keys)
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- folds
      if opts.folds.enabled then
        Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
          if Util.set_default("foldmethod", "expr") then
            Util.set_default("foldexpr", "v:lua.vim.lsp.foldexpr()")
          end
        end)
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      -- diagnostics
      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = function(diagnostic)
          for d, icon in pairs(diagnotics_icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
          return "●"
        end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      if opts.servers["*"] then
        vim.lsp.config("*", opts.servers["*"])
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason = Util.has("mason-lspconfig.nvim")
      local mason_all = have_mason
          and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {} --[[ @as string[] ]]
      local mason_exclude = {} ---@type string[]

      ---@return boolean? exclude automatic setup
      local function configure(server)
        if server == "*" then
          return false
        end

        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as vim.lsp.Config|{mason?:boolean, enabled?:boolean}]]

        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end

        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, sopts) then
          mason_exclude[#mason_exclude + 1] = server
        else
          vim.lsp.config(server, sopts) -- configure the server
          if not use_mason then
            vim.lsp.enable(server)
          end
        end
        return use_mason
      end

      local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
      if have_mason then
        require("mason-lspconfig").setup({
          ensure_installed = vim.list_extend(install, Util.opts("mason-lspconfig.nvim").ensure_installed or {}),
          automatic_enable = { exclude = mason_exclude },
        })
      end
    end),
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false,
  },
}
