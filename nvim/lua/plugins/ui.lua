-- =========================================================
-- UI  (which-key, colorscheme, buffer bar, todo signs, smart panes)
-- =========================================================

return {
  -- -------------------------------------------------------
  -- WHICH-KEY  (all leader group labels live here)
  -- -------------------------------------------------------

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    opts = {
      delay = 0,
      preset = 'helix', -- vertically stacked entries

      win = {
        border = 'rounded',
        padding = { 1, 2 },
        zindex = 1000,
        wo = { winblend = 10 },
      },

      layout = {
        align = 'right',
        width = { min = 30, max = 42 },
        height = { min = 4, max = 25 },
        mappings = vim.g.have_nerd_font,
        -- Show a plain › for groups instead of an icon when no nerd font
        group = vim.g.have_nerd_font and '' or '›',
      },

      sort = { 'local', 'order', 'group', 'alphanum' },

      spec = {
        -- Quick access
        { '<leader><space>', desc = 'Find files' },
        { '<leader>f', desc = 'Find lines in current file' },
        { '<leader>d', desc = 'Open diagnostic list' },

        -- s → search
        { '<leader>s', group = 'Search' },
        { '<leader>S', desc = 'Grep repository' },
        { '<leader>sk', desc = 'Keymaps' },
        { '<leader>st', desc = 'TODO / FIX / HACK' },

        -- c → code / LSP
        { '<leader>c', group = 'Code' },
        { '<leader>C', desc = 'Code action' },
        { '<leader>cr', desc = 'Rename symbol' },
        { '<leader>cf', desc = 'Format buffer' },
        { '<leader>cs', desc = 'Document symbols' },
        { '<leader>cS', desc = 'Workspace symbols' },

        -- b → buffer search (frequent, lowercase)
        -- B → buffer management
        { '<leader>b', desc = 'Buffer search' },
        { '<leader>B', group = 'Buffers' },
        { '<leader>Bn', desc = 'Next buffer' },
        { '<leader>Bp', desc = 'Prev buffer' },
        { '<leader>Bd', desc = 'Delete buffer' },
        { '<leader>BD', desc = 'Delete buffer (force)' },
        { '<leader>Ba', desc = 'Close all buffers' },
        { '<leader>Bo', desc = 'Close other buffers' },

        -- g → git
        { '<leader>g', group = 'Git' },
        { '<leader>gd', desc = 'Diff' },
        { '<leader>gh', desc = 'File history' },
        { '<leader>gp', desc = 'Preview hunk' },
        { '<leader>gs', desc = 'Stage hunk' },
        { '<leader>gS', desc = 'Stage buffer' },
        { '<leader>gb', desc = 'Blame line' },
        { '<leader>gB', desc = 'Blame line (full)' },
        { '<leader>gr', desc = 'Reset hunk' },

        -- a → AI
        { '<leader>a', group = 'AI' },
        { '<leader>A', desc = 'Inline' },
        { '<leader>ac', desc = 'Chat toggle' },
        { '<leader>aa', desc = 'Actions' },
        { '<leader>as', desc = 'Add selection' },
        { '<leader>ax', desc = 'New chat' },
        { '<leader>ar', desc = 'Refresh cache' },

        -- t → toggles
        { '<leader>t', group = 'Toggles' },
        { '<leader>th', desc = 'Inlay hints' },

        -- Surround (no leader)
        { 's', group = 'Surround' },
        { 'sa', desc = 'Add surrounding' },
        { 'sd', desc = 'Delete surrounding' },
        { 'sr', desc = 'Replace surrounding' },
        { 'sf', desc = 'Find surrounding (forward)' },
        { 'sF', desc = 'Find surrounding (backward)' },
      },
    },
  },

  -- -------------------------------------------------------
  -- COLORSCHEME
  -- -------------------------------------------------------

  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme 'gruvbox-material'

      -- make background clear
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE' })
    end,
  },

  -- -------------------------------------------------------
  -- buffer bar
  -- -------------------------------------------------------

  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- git status in the tab bar
      -- icons come from mini.icons via MiniIcons.mock_nvim_web_devicons()
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {},
    version = '^1.0.0',
  },

  -- -------------------------------------------------------
  -- TODO COMMENTS  (keyword highlighting in buffers)
  -- -------------------------------------------------------

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

  -- -------------------------------------------------------
  -- smart panes (window integration with tmux)
  -- -------------------------------------------------------

  {
    'mrjones2014/smart-splits.nvim',
    lazy = false, -- needs to set @pane-is-vim for tmux immediately on load
    opts = {
      default_amount = 3,
      at_edge = 'wrap',
    },
    keys = {
      -- Movement (owns <C-hjkl>; the old plain window-nav binds are gone)
      { '<C-h>', function() require('smart-splits').move_cursor_left() end, desc = 'Move to left split' },
      { '<C-j>', function() require('smart-splits').move_cursor_down() end, desc = 'Move to split below' },
      { '<C-k>', function() require('smart-splits').move_cursor_up() end, desc = 'Move to split above' },
      { '<C-l>', function() require('smart-splits').move_cursor_right() end, desc = 'Move to right split' },
      -- Resize (Alt+hjkl, mirrors the tmux config)
      { '<A-h>', function() require('smart-splits').resize_left() end, desc = 'Resize left' },
      { '<A-j>', function() require('smart-splits').resize_down() end, desc = 'Resize down' },
      { '<A-k>', function() require('smart-splits').resize_up() end, desc = 'Resize up' },
      { '<A-l>', function() require('smart-splits').resize_right() end, desc = 'Resize right' },
    },
  },
}
