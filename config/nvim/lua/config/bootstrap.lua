-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
  spec = { import = "plugins" },
  ui = {
    size = { width = 1, height = 1},
    backdrop = 100,
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
})

require("vim._core.ui2").enable()

vim.o.cmdheight = 0

vim.api.nvim_create_user_command("UndotreeShow", function()
  vim.cmd.packadd("nvim.undotree")
  vim.cmd.Undotree()
end, {})



vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-my-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ higroup = "Visual", timeout = 500 })
	end,
})

