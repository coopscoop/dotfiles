-- =========================================================
-- AUTOCOMMANDS
-- (global ones only; plugin-specific autocmds live with their
--  plugins: LSP -> plugins/lsp.lua, treesitter -> plugins/treesitter.lua,
--  codecompanion notifier -> plugins/ai.lua)
-- =========================================================

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
