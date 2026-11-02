-- =========================================================
-- KEYMAPS
-- (global keymaps; buffer-local maps live with their plugins:
--  LSP -> plugins/lsp.lua, gitsigns -> plugins/git.lua)
--
-- Bind rules:
--   1. phonetic where possible (b=buffers, g=git, f=find, ...)
--   2. lowercase single-letter = frequent (two keypresses total)
--   3. no double letters
-- =========================================================

-- Clear search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keep Visual block selection after indent
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right' })

-- ── Files ────────────────────────────────────────────────────
vim.keymap.set('n', '<leader><space>', function() require('snacks').picker.files() end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>f', function() require('snacks').picker.lines() end, { desc = 'Find lines in current file' })

-- ── Search ───────────────────────────────────────────────────
vim.keymap.set('n', '<leader>s', function() require('snacks').picker.grep() end, { desc = 'Grep repository' })
vim.keymap.set('n', '<leader>Sk', function() require('snacks').picker.keymaps() end, { desc = 'Keymaps' })

-- ── Buffers ──────────────────────────────────────────────────
-- Frequent = lowercase (rule 2): fuzzy buffer search on <leader>b.
-- Management lives under <leader>B.
vim.keymap.set('n', '<leader>b', function() require('snacks').picker.buffers() end, { desc = 'Buffer search' })
vim.keymap.set('n', '<leader>Bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>Bp', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<leader>Bd', '<cmd>bd<cr>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>BD', '<cmd>bd!<cr>', { desc = 'Delete buffer (force)' })
vim.keymap.set('n', '<leader>Ba', '<cmd>%bd<cr>', { desc = 'Close all buffers' })
vim.keymap.set('n', '<leader>Bo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Close other buffers' })

-- ── Git ──────────────────────────────────────────────────────
vim.keymap.set('n', '<leader>gd', function()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd 'DiffviewClose'
  else
    vim.cmd 'DiffviewOpen'
  end
end, { desc = 'Diffview toggle' })

vim.keymap.set('n', '<leader>gh', function()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd 'DiffviewClose'
  else
    vim.cmd 'DiffviewFileHistory %'
  end
end, { desc = 'File history (current file)' })

-- ── Diagnostics ──────────────────────────────────────────────
vim.keymap.set('n', '<leader>d', function() vim.diagnostic.setloclist { open = true } end, { desc = 'Open diagnostic list' })

-- ── Insert mode quick cursor moves ───────────────────────────
-- (note: this trades away insert-mode <C-h> = backspace)
vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'Move cursor left' })
vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move cursor right' })
