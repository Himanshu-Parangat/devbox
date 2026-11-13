return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- We're defining every mapping ourselves, so start from an empty preset
    keymap = {
      preset = 'none',

      -- Manually open the menu / toggle docs
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

      -- Close the menu. <C-[> is the same keycode as <Esc> in a terminal,
      -- so this also means Esc will close the menu (then fall back to
      -- normal Esc behavior, i.e. leave insert mode).
      ['<C-e>']  = { 'hide', 'fallback' },
      ['<C-[>']  = { 'hide', 'fallback' },

      -- Enter ONLY accepts when the menu is open & an item is selected.
      -- If the menu isn't open, it falls back to a normal newline.
      ['<CR>'] = { 'accept', 'fallback' },

      -- Move the selection up/down while menu is open
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<Up>']   = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },

      -- Tab / Shift-Tab: ONLY jump through snippet placeholders.
      -- They do nothing to the completion menu itself.
      ['<Tab>']   = { 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

      -- optional: scroll docs
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    appearance = {
      nerd_font_variant = 'Nerd Font Mono',
    },

    completion = {
      keyword = { range = 'full' },
      accept = { auto_brackets = { enabled = false } },

      -- Never auto-preselect an item; Enter should only accept
      -- something you actually navigated to with C-n/C-p/Up/Down.
      list = { selection = { preselect = false, auto_insert = false } },

      -- THE IMPORTANT PART: never show the menu automatically.
      -- Only `show` (bound to <C-space> above) opens it.
      menu = {
        auto_show = false,
        border = 'rounded',
        draw = {
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'source_name' },
          },
          components = {
            source_name = {
              width = { max = 30 },
              text = function(ctx) return '[' .. ctx.source_name .. ']' end,
              highlight = 'BlinkCmpSource',
            },
          },
        },
      },

      documentation = { auto_show = true },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
    config = function(_, opts)
    require('blink.cmp').setup(opts)

    -- Headless (container build): block until the prebuilt binary is downloaded
    if #vim.api.nvim_list_uis() == 0 then
      local done = false
      require('blink.cmp.fuzzy.download').ensure_downloaded(function(err)
        if err then
          io.stderr:write('blink.cmp download failed: ' .. tostring(err) .. '\n')
        end
        done = true
      end)
      vim.wait(120000, function() return done end, 100)
    end
  end,
}
