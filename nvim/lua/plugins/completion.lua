-- =========================================================
-- COMPLETION  (blink.cmp)
-- No LuaSnip: LSP snippets expand via blink's built-in engine.
-- Add friendly-snippets + sources 'snippets' if you ever want
-- snippet collections.
-- =========================================================

return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      keymap = {
        preset = 'none',
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-n>'] = { 'select_next' },
        ['<C-p>'] = { 'select_prev' },
        ['<C-Space>'] = { 'show' },
        ['<C-e>'] = { 'cancel' },
        ['<C-d>'] = { 'scroll_documentation_down' },
        ['<C-u>'] = { 'scroll_documentation_up' },
      },
      appearance = {
        nerd_font_variant = vim.g.have_nerd_font and 'mono' or 'normal',
      },
      completion = {
        keyword = { range = 'full' },
        trigger = { show_on_trigger_character = true }, -- show on . chars
        accept = { auto_brackets = { enabled = false } }, -- mini.pairs owns brackets
        list = { selection = { preselect = false, auto_insert = true } },
        menu = {
          draw = {
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind' },
            },
          },
        },
        documentation = { auto_show = true },
        ghost_text = { enabled = true },
      },
      sources = {
        default = { 'lsp', 'path', 'buffer' },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
      },
    },
  },
}
