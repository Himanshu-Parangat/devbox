

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keep register content when pasting over selected text
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without overwriting register", silent = true })



-- Move selected block left, right and keep selection
vim.keymap.set("v", "<", "<gv", { desc = "Indent selection left and reselect", silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Indent selection right and reselect", silent = true })

-- Alternative keys for moving selected block
vim.keymap.set("v", "H", "<gv", { desc = "Indent selection left", silent = true })
vim.keymap.set("v", "L", ">gv", { desc = "Indent selection right", silent = true })

-- Move selected lines Up Down and keep selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down", silent = true})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up", silent = true})



-- Exit terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", silent = true})
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { desc = "Exit terminal mode", silent = true})


-- somewhere early in init.lua
local utils = require("config.utils")
utils.setup()

vim.keymap.set("n", "<leader>z",  utils.toggle_lua_line,          { desc = "Toggle lualine" })
vim.keymap.set("n", "<leader>tw", utils.toggle_wrap,               { desc = "Toggle line wrap" })
vim.keymap.set("n", "<leader>tc", utils.toggleListChars,           { desc = "Toggle hidden characters" })
vim.keymap.set("n", "<leader>td", utils.toggle_diagnostics,        { desc = "Toggle diagnostics" })
vim.keymap.set("n", "<leader>tl", utils.supress_virtual_line_text, { desc = "Toggle virtual line text" })
vim.keymap.set("n", "<leader>ti", utils.toggle_inlay_hints,        { desc = "Toggle inlay hints" })
vim.keymap.set("n", "<leader>tv", utils.toggle_virtual_text,       { desc = "Toggle virtual text" })
vim.keymap.set("n", "<leader>ts", utils.toggle_signs,               { desc = "Toggle diagnostic signs" })
vim.keymap.set("n", "<leader>tu", utils.toggle_underline,          { desc = "Toggle diagnostic underline" })
vim.keymap.set("n", "<leader>tn", utils.toggle_numbers,            { desc = "Toggle line/relative numbers" })
vim.keymap.set("n", "<leader>tsc",utils.toggle_signcolumn,          { desc = "Toggle sign column" })
vim.keymap.set("n", "<leader>tb", utils.toggle_statusline,         { desc = "Toggle bottom status bar" })
vim.keymap.set("n", "<leader>tL", utils.toggle_diagnostics_lsp,    { desc = "Toggle global LSP" })
