---@brief
--- https://github.com/tailwindlabs/tailwindcss-intellisense
---
--- Tailwind CSS Language Server can be installed via npm:
---
--- npm install -g @tailwindcss/language-server
---
--- To manually set the config file or CSS entry-point, see:
--- https://github.com/tailwindlabs/tailwindcss-intellisense#tailwindcssexperimentalconfigfile



local mason_tsdk = vim.fn.stdpath("data")
  .. "/mason/packages/astro-language-server/node_modules/typescript/lib"


---@type vim.lsp.Config
return {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  init_options = {
    typescript = { tsdk = mason_tsdk },
    environment = "node",
  },
  settings = {
    astro = {
      trace = { server = "verbose" },   -- or "off"/"messages"
      typescript = {
        diagnostics = { enabled = true },
      },
    },
    contentIntellisense = true,
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "all" },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
      },
      preferences = {
        importModuleSpecifier = "non-relative",
      },
    },
    html = {
      hover = { documentation = true },
    },
    css = {
      validate = true,
    },
  },
}
