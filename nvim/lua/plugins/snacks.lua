-- =========================================================
-- SNACKS  (picker + dashboard + notifier + scroll)
-- =========================================================

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
        },
      },

      notifier = { enabled = true },

      scroll = {
        enabled = true,
        animate = {
          duration = { step = 10, total = 40 }, -- shorter than default
          easing = 'linear',
        },
      },

      dashboard = {
        enabled = true,
        preset = {
          header = table.concat({
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
          }, '\n'),
          keys = {
            { key = 'f', desc = 'Find files', action = function() require('snacks').picker.files() end },
            { key = 'g', desc = 'Live grep', action = function() require('snacks').picker.grep() end },
            { key = 'b', desc = 'Buffers', action = function() require('snacks').picker.buffers() end },
            { key = 'r', desc = 'Recent files', action = function() require('snacks').picker.recent() end },
            { key = '/', desc = 'Search in file', action = function() require('snacks').picker.lines() end },
          },
        },

        sections = {
          { section = 'header' },
          { section = 'keys' },
          { section = 'recent_files' },
          { section = 'projects' },
        },
      },
    },
  },
}
