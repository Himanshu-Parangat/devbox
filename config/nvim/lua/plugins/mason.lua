return {
  "mason-org/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },

  config = function()
    local mason = require("mason")
    local masonToolInstaller = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        width = 1,
        height = 1,
      },
    })

    masonToolInstaller.setup({
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "pyright",
        "prettier",
      },
    })
  end,
}
