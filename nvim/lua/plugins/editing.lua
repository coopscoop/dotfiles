-- =========================================================
-- MINI.NVIM  (icons + ai textobjects + surround + pairs + statusline)
-- =========================================================

return {
  {
    'nvim-mini/mini.nvim',
    config = function()
      -- Icons: provide the icon system used by the UI
      require('mini.icons').setup {}
      MiniIcons.mock_nvim_web_devicons()

      -- Textobjects: va), yiiq, ci' etc.
      require('mini.ai').setup {
        mappings = {
          around_next = 'aa',
          inside_next = 'ii',
        },
        n_lines = 500,
      }

      -- Surround: sa (add), sd (delete), sr (replace), sf/sF (find)
      -- Example: saiw) wraps word in parens, sd' deletes quotes, sr)' replaces ) with '
      require('mini.surround').setup {
        mappings = {
          add = 'sa',
          delete = 'sd',
          replace = 'sr',
          find = 'sf',
          find_left = 'sF',
          highlight = 'sh',
          update_n_lines = 'sn',
        },
      }

      require('mini.pairs').setup {
        modes = { insert = true, command = false },
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        skip_ts = { 'string' },
        skip_unbalanced = true,
        markdown = true,
      }

      -- Statusline
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },
}
