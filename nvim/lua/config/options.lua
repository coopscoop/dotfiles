-- =========================================================
-- OPTIONS
-- =========================================================

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 150
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.opt.scrolloff = (math.floor(vim.o.lines / 2) - 3)
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = false
vim.o.laststatus = 3
vim.o.jumpoptions = 'view'

vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Sync clipboard after UI loads (avoids startup slowdown)
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- =========================================================
-- DIAGNOSTICS
-- =========================================================

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
}
