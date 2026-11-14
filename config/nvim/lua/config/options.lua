


vim.opt.number = true                     -- Show absolute line numbers
vim.opt.relativenumber = true             -- Show relative line numbers for easier navigation

vim.opt.iskeyword:remove("_")             -- Treat "_" as a word separator
vim.opt.iskeyword:remove("-")             -- Treat "-" as a word separator

vim.opt.undofile = true                   -- Enable persistent undo history
vim.opt.swapfile = false                  -- Disable swap files
vim.opt.backup = false                    -- Disable backup files
-- vim.opt.cmdheight = 2                  -- Set command line height

vim.opt.expandtab = true                  -- Use spaces instead of tab characters
vim.opt.tabstop = 2                       -- Set tab display width to 2 spaces
vim.opt.shiftwidth = 2                    -- Set indentation width to 2 spaces
vim.opt.softtabstop = 2                   -- Make Tab/Backspace behave like 2 spaces
vim.opt.smartindent = true                -- Enable automatic smart indentation

vim.opt.clipboard = ""
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    -- ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    -- ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
