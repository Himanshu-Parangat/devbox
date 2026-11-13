return {
  'nvim-telescope/telescope.nvim', version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local action_layout = require("telescope.actions.layout")

    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>pq', builtin.quickfix, { desc = 'Telescope quickfix list' })
    vim.keymap.set('n', '<leader>pl', builtin.loclist, { desc = 'Telescope location list' })
    vim.keymap.set('n', '<leader>pr', builtin.registers, { desc = 'Telescope registers' })
    vim.keymap.set('n', '<leader>ps', builtin.spell_suggest, { desc = 'Telescope spell suggestions' })
    vim.keymap.set('n', '<leader>pd', builtin.diagnostics, { desc = 'Telescope diagnostics' })

    telescope.setup({
      defaults = {
        layout_strategy = "flex",
        sorting_strategy = "ascending",
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        layout_config = {
          width = 0.99,
          height = 0.99,

          horizontal = {
            prompt_position = "top",
            preview_width = 0.8,
          },

          vertical = {
            preview_height = 0.7,
          },
        },
        borderchars = {
          prompt = { "", "", "", "", "", "", "", "" },
          results = { "", "", "", "", "", "", "", "" },
          preview = { "", "", "", "", "", "", "", "" },
        },
        mappings = {
          n = { ["<M-p>"] = action_layout.toggle_preview },
          i = { ["<M-p>"] = action_layout.toggle_preview },
        }
      },
    })

  end
}
