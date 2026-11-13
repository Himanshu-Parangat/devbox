return {
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    config = function()
      require('render-markdown').setup({
        completions = { lsp = { enabled = true } },
        code = {
          sign = false,
          width = "block",
          left_pad = 2,
          right_pad = 2,
          -- border = 'thin',
        },
        heading = {
          sign = false,
          width = "block",
          left_pad = 2,
          right_pad = 2,
        }
      })

      vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { bg = 'NONE' })
    end
}
