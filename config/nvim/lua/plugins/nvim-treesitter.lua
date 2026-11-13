return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    -- setup (only install dir etc.)
    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- install parsers
--    ts.install({
--      "lua",
--      "javascript",
--      "tsx",
--      "html",
--      "css",
--    }, { sync = true })

     local task = ts.install({ "lua", "javascript", "tsx", "html", "css" })

     -- headless (e.g. container build): block until finished
     if #vim.api.nvim_list_uis() == 0 then
       task:wait(300000)
     end

    -- enable highlighting manually
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    -- optional: indent
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
