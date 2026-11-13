---@brief
---
--- https://github.com/luals/lua-language-server
---
--- Lua language server.
---
--- `lua-language-server` can be installed by following the instructions [here](https://luals.github.io/#neovim-install).
---
--- The default `cmd` assumes that the `lua-language-server` binary can be found in `$PATH`.
---
--- If you primarily use `lua-language-server` for Neovim, and want to provide completions,
--- analysis, and location handling for plugins on runtime path, you can use the following
--- settings.

local root_markers1 = {
  '.emmyrc.json',
  '.luarc.json',
  '.luarc.jsonc',
}
local root_markers2 = {
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
}

---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers1, root_markers2, { '.git' } }
    or vim.list_extend(vim.list_extend(root_markers1, root_markers2), { '.git' }),

  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
        },
      },
    })
  end,

  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {

      codeLens = {
        enable = true,          -- default: false
      },

      completion = {
        autoRequire = true,
        callSnippet = 'Replace',    -- Disable | Both | Replace  (default: Disable)
        displayContext = 5,         -- 0 disables (default: 0)
        enable = true,
        keywordSnippet = 'Replace', -- Disable | Both | Replace (default: Replace)
        postfix = '@',
        requireSeparator = '.',
        showParams = true,
        showWord = 'Fallback',      -- Enable | Fallback | Disable
        workspaceWord = true,
      },

      diagnostics = {
        disable = {},                     -- e.g. { 'lowercase-global' }
        disableScheme = { 'git' },
        enable = true,
        globals = {},                     -- e.g. { 'vim' } (usually unneeded now)
        globalsRegex = {},
        ignoredFiles = 'Opened',      -- Enable | Opened | Disable
        libraryFiles = 'Opened',      -- Enable | Opened | Disable
        unusedLocalExclude = {},        -- e.g. { '_*' }
        workspaceDelay = 3000,
        workspaceEvent = 'OnSave',      -- OnChange | OnSave | None
        workspaceRate = 100,
      },


      format = {
        enable = true,
        defaultConfig = {},   -- populated via .editorconfig or explicit table, e.g. { indent_style = 'space', indent_size = '2' }
      },

      hint = {
        arrayIndex = 'Auto',     -- Enable | Auto | Disable
        await = true,
        awaitPropagate = false,
        enable = true,            -- default: false
        paramName = 'All',        -- All | Literal | Disable
        paramType = true,
        semicolon = 'Disable',    -- All | SameLine | Disable  (your original override)
        setType = false,
      },

      hover = {
        enable = true,
        expandAlias = true,
        previewFields = 50,
        viewNumber = true,
        viewString = true,
        viewStringMax = 1000,
      },

      language = {
        completeAnnotation = true,
        fixIndent = true,
      },


      runtime = {
        builtin = {
          basic = 'default',
          bit = 'default',
          bit32 = 'default',
          builtin = 'default',
          coroutine = 'default',
          debug = 'default',
          ffi = 'default',
          io = 'default',
          jit = 'default',
          math = 'default',
          os = 'default',
          package = 'default',
          string = 'default',
          table = 'default',
          ['table.clear'] = 'default',
          ['table.new'] = 'default',
          utf8 = 'default',
        },
        fileEncoding = 'utf8',      -- utf8 | ansi (Windows) | utf16le | utf16be
        meta = '${version} ${language} ${encoding}',
        nonstandardSymbol = {},     -- e.g. { 'continue', '//' }
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
        pathStrict = false,
        special = {},               -- e.g. { include = 'require' }
        unicodeName = false,
        version = 'LuaJIT',         -- Lua 5.1 | 5.2 | 5.3 | 5.4 | LuaJIT
      },

      semantic = {
        annotation = true,
        enable = true,
        keyword = false,
        variable = true,
      },

      signatureHelp = {
        enable = true,
      },


      type = {
        castNumberToInteger = false,
        checkTableShape = false,
        inferParamType = false,
        inferTableSize = 10,
        weakNilCheck = false,
        weakUnionCheck = false,
      },

      typeFormat = {
        config = {
          auto_complete_end = 'true',
          auto_complete_table_sep = 'true',
          format_line = 'true',
        },
      },

      window = {
        progressBar = true,
        statusBar = true,
      },

      workspace = {
        ignoreDir = { '.vscode' },
        ignoreSubmodules = true,
        maxPreload = 5000,
        preloadFileSize = 500,
        useGitIgnore = true,
        userThirdParty = {},
        checkThirdParty = 'Apply',   -- Ask | Apply | ApplyInMemory | Disable
        -- checkThirdParty = false, -- prevents this prompt going forward
        library = {
          vim.env.VIMRUNTIME,
          vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
          "${3rd}/luv/library", -- add this
        },
      },

    },
  },
}
