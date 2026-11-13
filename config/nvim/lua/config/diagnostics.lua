local icons = require("config.icons")

vim.o.winborder = "rounded"

vim.lsp.buf.hover({
  border = "rounded",
  max_width = 100,
  max_height = 30,
})

vim.diagnostic.config({
  underline = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostic.ERROR,
      [vim.diagnostic.severity.WARN] = icons.diagnostic.WARN,
      [vim.diagnostic.severity.HINT] = icons.diagnostic.HINT,
      [vim.diagnostic.severity.INFO] = icons.diagnostic.INFO,
    },
  },
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
    spacing = 1,
  },

  -- virtual_text = {
  --   spacing = 2,
  --   source = "if_many",
  --   prefix = "●",
  -- },
  virtual_text = false,

  virtual_lines = {
    overflow = "scroll",
    only_current_line = false,
  }
})


