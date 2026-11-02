-- =========================================================
-- GIT
-- =========================================================

return {
  {
    -- Gutter signs + hunk/blame actions
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        staged = { text = '✓' },
      },
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local map = function(keys, fn, desc) vim.keymap.set('n', keys, fn, { buffer = bufnr, desc = desc }) end

        -- Hunk navigation (feels natural alongside ]d/[d for diagnostics)
        map(']h', function() gs.nav_hunk 'next' end, 'Next hunk')
        map('[h', function() gs.nav_hunk 'prev' end, 'Prev hunk')

        -- Hunk actions under <leader>g
        map('<leader>gp', gs.preview_hunk, 'Preview hunk')
        map('<leader>gs', gs.stage_hunk, 'Stage hunk')
        map('<leader>gS', gs.stage_buffer, 'Stage buffer')
        map('<leader>gb', gs.blame_line, 'Blame line')
        map('<leader>gB', function() gs.blame_line { full = true } end, 'Blame line (full)')
        map('<leader>gr', gs.reset_hunk, 'Reset hunk')
      end,
    },
  },

  {
    -- Side-by-side diff + file history viewer
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
}
