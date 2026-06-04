-- Set <space> as the leader key
-- NOTE: Must happen before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

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
vim.o.scrolloff = 20
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Sync clipboard after UI loads (avoids startup slowdown)
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Disable vim lsp sig handler (nvim-cmp handles signature help via cmp-nvim-lsp)
vim.lsp.handlers['textDocument/signatureHelp'] = function() end

-- =========================================================
-- BASIC KEYMAPS
-- =========================================================

-- Clear search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Terminal: easier escape
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Up/Down QOL - auto ZZ after <C-d/u>
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Auto Center after <C-d>' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Auto Center after <C-u>' })

-- Keep Visual block selection after indent
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })

-- =========================================================
-- DIAGNOSTICS
-- =========================================================

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
}

-- Navigate diagnostics
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })

-- =========================================================
-- AUTOCOMMANDS
-- =========================================================

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- =========================================================
-- PLUGIN MANAGER (lazy.nvim)
-- =========================================================

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- =========================================================
-- PLUGINS
-- =========================================================

require('lazy').setup({

  -- -------------------------------------------------------
  -- GIT
  -- -------------------------------------------------------

  {
    -- Gutter signs + hunk/blame actions
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    opts = {
      signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
      },
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local map = function(keys, fn, desc) vim.keymap.set('n', keys, fn, { buffer = bufnr, desc = desc }) end

        -- Hunk navigation (feels natural alongside ]d/[d for diagnostics)
        map(']h', gs.next_hunk, 'Next hunk')
        map('[h', gs.prev_hunk, 'Prev hunk')

        -- Hunk actions under <leader>g
        map('<leader>gp', gs.preview_hunk, 'Preview hunk')
        map('<leader>gs', gs.stage_hunk, 'Stage hunk')
        map('<leader>gu', gs.undo_stage_hunk, 'Undo stage hunk')
        map('<leader>gS', gs.stage_buffer, 'Stage buffer')
        map('<leader>gb', gs.blame_line, 'Blame line')
        map('<leader>gB', function() gs.blame_line { full = true } end, 'Blame line (full)')
        map('<leader>gR', gs.reset_hunk, 'Reset hunk')
      end,
    },
  },

  {
    -- Side-by-side diff + file history viewer
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },

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
        spacing = 3,
      },

      icons = {
        mappings = vim.g.have_nerd_font,
        -- Show a plain › for groups instead of an icon when no nerd font
        group = vim.g.have_nerd_font and '' or '›',
      },

      sort = { 'local', 'order', 'group', 'alphanum' },

      spec = {
        -- Quick access (no sub-menu, sits at top level)
        { '<leader><space>', desc = 'Find files' },
        { '-', desc = 'NeoTree' },

        -- f → local/buffer search
        { '<leader>f', group = 'Find (local)' },
        { '<leader>ff', desc = 'Find in buffer (lines)' },
        { '<leader>fb', desc = 'Buffers' },
        { '<leader>fh', desc = 'Help tags' },
        { '<leader>fk', desc = 'Keymaps' },

        -- s → system-wide / project search
        { '<leader>s', group = 'Search (project)' },
        { '<leader>sr', desc = 'Recent files' },
        { '<leader>sw', desc = 'Grep word under cursor' },
        { '<leader>sn', desc = 'Search nvim config' },

        -- a → AI (CodeCompanion)
        { '<leader>a', group = 'AI' },
        { '<leader>ac', desc = 'Chat toggle' },
        { '<leader>aa', desc = 'Actions' },
        { '<leader>ai', desc = 'Send selection to chat' },

        -- c → code (LSP, format, refactor)
        { '<leader>c', group = 'Code' },
        { '<leader>ca', desc = 'Code action' },
        { '<leader>cr', desc = 'Rename symbol' },
        { '<leader>cf', desc = 'Format buffer' },
        { '<leader>cs', desc = 'Document symbols' },
        { '<leader>cS', desc = 'Workspace symbols' },

        -- b → buffer management
        { '<leader>b', group = 'Buffers' },
        { '<leader>bn', desc = 'Next buffer' },
        { '<leader>bp', desc = 'Prev buffer' },
        { '<leader>bd', desc = 'Delete buffer' },
        { '<leader>bD', desc = 'Delete buffer (force)' },
        { '<leader>ba', desc = 'Close all buffers' },
        { '<leader>bo', desc = 'Close other buffers' },

        -- g → git (diffview + gitsigns)
        { '<leader>g', group = 'Git' },
        { '<leader>gd', desc = 'Toggle Diffview' },
        { '<leader>gh', desc = 'File history' },
        { '<leader>gp', desc = 'Preview hunk' },
        { '<leader>gs', desc = 'Stage hunk' },
        { '<leader>gu', desc = 'Undo stage hunk' },
        { '<leader>gS', desc = 'Stage buffer' },
        { '<leader>gb', desc = 'Blame line' },
        { '<leader>gB', desc = 'Blame line (full)' },
        { '<leader>gR', desc = 'Reset hunk' },

        -- h → harpoon
        { '<leader>h', group = 'Harpoon' },
        { '<leader>ha', desc = 'Add file' },
        { '<leader>hh', desc = 'Menu' },
        { '<leader>hn', desc = 'Next mark' },
        { '<leader>hp', desc = 'Prev mark' },
        { '<leader>h1', desc = 'Jump to mark 1' },
        { '<leader>h2', desc = 'Jump to mark 2' },
        { '<leader>h3', desc = 'Jump to mark 3' },
        { '<leader>h4', desc = 'Jump to mark 4' },

        -- m -> marks
        { '<leader>m', group = 'Marks' },
        { '<leader>ml', desc = 'List marks' },
        { '<leader>mc', desc = 'Clear marks' },

        -- t → toggles
        { '<leader>t', group = 'Toggles' },
        { '<leader>th', desc = 'Inlay hints' },

        -- x → diagnostics / trouble
        { '<leader>x', group = 'Diagnostics' },
        { '<leader>xx', desc = 'Workspace diagnostics' },
        { '<leader>xb', desc = 'Buffer diagnostics' },
        { '<leader>xq', desc = 'Quickfix list' },
        { '<leader>xd', desc = 'Diagnostics picker' },
        { '<leader>xl', desc = 'Quickfix list (Trouble)' },

        -- s -> surround
        { 's', group = 'Surround' },
        { 'sa', desc = 'Add surrounding' },
        { 'sd', desc = 'Delete surrounding' },
        { 'sr', desc = 'Replace surrounding' },
        { 'sf', desc = 'Find surrounding (forward)' },
        { 'sF', desc = 'Find surrounding (backward)' },

        -- Tab -> tab management
        { '<leader><tab>', group = 'Tabs' },
        { '<leader><tab>n', desc = 'New tab' },
        { '<leader><tab>z', desc = 'Zoom window' },
        { '<leader><tab>]', desc = 'Next tab' },
        { '<leader><tab>[', desc = 'Prev tab' },
        { '<leader><tab>c', desc = 'Close tab' },

        -- Surround (no leader — mini.surround uses bare s* binds)
        -- Listed here so which-key shows them when you press s in normal mode
        -- sa = add, sd = delete, sr = replace, sf/sF = find
        { '<s>', group = 'Surround' },
        { '<sa>', desc = 'Add' },
        { '<sd>', desc = 'Delete' },
        { '<sr>', desc = 'Replace' },
        { '<sf>', desc = 'find (forwards)' },
        { '<sF>', desc = 'find (backwards)' },
      },
    },
  },

  -- -------------------------------------------------------
  -- HYDRA - avoids mashing the same key combo 900 times, mostly just for window management
  -- -------------------------------------------------------

  {
    'anuvyklack/hydra.nvim',
    config = function()
      local hydra = require 'hydra'
      hydra {
        name = 'Windows',
        mode = 'n',
        body = '<leader>w',
        heads = {
          { 'h', '<C-w>h', { desc = 'focus left' } },
          { 'j', '<C-w>j', { desc = 'focus down' } },
          { 'k', '<C-w>k', { desc = 'focus up' } },
          { 'l', '<C-w>l', { desc = 'focus right' } },
          { '>', '2<C-w>>', { desc = 'wider' } },
          { '<', '2<C-w><', { desc = 'narrower' } },
          { '+', '2<C-w>+', { desc = 'taller' } },
          { '-', '2<C-w>-', { desc = 'shorter' } },
          { '=', '<C-w>=', { desc = 'equalise' } },
          { 'v', '<C-w>v', { desc = 'vsplit' } },
          { 's', '<C-w>s', { desc = 'hsplit' } },
          { 'q', '<C-w>q', { desc = 'close', exit = true } },
          { '<Esc>', nil, { exit = true } },
        },
      }
    end,
  },

  -- -------------------------------------------------------
  -- LSP
  -- -------------------------------------------------------

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} }, ---@diagnostic disable-line: missing-fields
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Go-to actions (use built-in gr* defaults from Neovim 0.11+)
          map('<leader>cr', vim.lsp.buf.rename, 'Rename symbol')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
          map('<leader>cs', vim.lsp.buf.document_symbol, 'Document symbols')
          map('<leader>cS', vim.lsp.buf.workspace_symbol, 'Workspace symbols')
          map('gD', vim.lsp.buf.declaration, 'Goto declaration')
          map('gd', vim.lsp.buf.definition, 'Goto definition')
          map('gr', vim.lsp.buf.references, 'References')
          map('K', vim.lsp.buf.hover, 'Hover docs')

          -- Leader code binds (mirrors which-key spec above)

          -- Highlight references on cursor hold
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local hl_group = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = hl_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = hl_group,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Toggle inlay hints if supported
          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Toggle inlay hints')
          end
        end,
      })

      ---@type table<string, vim.lsp.Config>
      local servers = {
        tsgo = {},
        stylua = {},
        lua_ls = {
          on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
              workspace = {
                checkThirdParty = false,
                library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                }),
              },
            })
          end,
          ---@type lspconfig.settings.lua_ls
          settings = {
            Lua = { format = { enable = false } },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },

  -- -------------------------------------------------------
  -- FORMATTING
  -- -------------------------------------------------------

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function() require('conform').format { async = true } end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local enabled_filetypes = {
          -- lua = true,
          -- python = true,
        }
        if enabled_filetypes[vim.bo[bufnr].filetype] then
          return { timeout_ms = 500 }
        else
          return nil
        end
      end,
      default_format_opts = { lsp_format = 'fallback' },
      formatters_by_ft = {
        -- rust       = { 'rustfmt' },
        -- python     = { 'isort', 'black' },
        -- javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  -- -------------------------------------------------------
  -- COMPLETION
  -- -------------------------------------------------------

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Sources
      'hrsh7th/cmp-nvim-lsp', -- LSP completions
      'hrsh7th/cmp-path', -- filesystem paths
      -- Snippets
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip', -- luasnip source for cmp
      -- Supermaven: registers itself as a cmp source automatically
      { 'supermaven-inc/supermaven-nvim', opts = {} },
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.confirm { select = true },
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
        },
        sources = cmp.config.sources {
          { name = 'supermaven', priority = 100 }, -- AI suggestions first
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
        window = {
          completion = cmp.config.window.bordered { max_height = 5 },
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = function(entry, item)
            item.menu = nil -- removes the [supermaven] / [LSP] label on the right
            item.abbr = item.abbr:sub(1, 50) -- truncate long completions to one line
            return item
          end,
        },
        -- Show ghost text preview of selected item
        experimental = { ghost_text = false },
      }
    end,
  },

  -- -------------------------------------------------------
  -- TREESITTER
  -- -------------------------------------------------------

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(parsers)

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        if not vim.treesitter.language.add(language) then return end
        vim.treesitter.start(buf, language)
        local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
        if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
          if vim.tbl_contains(installed_parsers, language) then
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
          else
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },

  -- -------------------------------------------------------
  -- MINI.NVIM  (icons + ai textobjects + surround + statusline)
  -- -------------------------------------------------------

  {
    'nvim-mini/mini.nvim',
    config = function()
      -- Icons: mocks nvim-web-devicons so neo-tree/bufferline use mini.icons instead
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
          add = 'sa', -- Add surrounding
          delete = 'sd', -- Delete surrounding
          replace = 'sr', -- Replace surrounding
          find = 'sf', -- Find surrounding (forward)
          find_left = 'sF', -- Find surrounding (backward)
          highlight = 'sh', -- Highlight surrounding
          update_n_lines = 'sn', -- Update n_lines
        },
      }

      require('mini.pairs').setup {
        modes = { insert = true, command = false, terminal = false },
        -- don't pair in these contexts
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

  -- -------------------------------------------------------
  -- COLORSCHEME
  -- -------------------------------------------------------

  -- {
  --   'folke/tokyonight.nvim',
  --   priority = 1000,
  --   config = function()
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('tokyonight').setup {
  --       styles = { comments = { italic = false } },
  --     }
  --     vim.cmd.colorscheme 'tokyonight-night'
  --   end,
  -- },

  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   priority = 1000,
  --   opts = {
  --     flavour = 'mocha',
  --     transparent_background = false,
  --   },
  --   config = function(_, opts)
  --     require('catppuccin').setup(opts)
  --     vim.cmd.colorscheme 'catppuccin'
  --   end,
  -- },

  {
    'rebelot/kanagawa.nvim',
    config = function()
      require('kanagawa').setup {
        colors = {
          palette = {
            dragonRed = '#e87b73',
            dragonGreen = '#86d386',
            dragonGreen2 = '#9ec975',
            dragonYellow = '#e6cc91',
            dragonOrange = '#dda27d',
            dragonOrange2 = '#df9a7d',
            dragonBlue2 = '#8cbfd8',
            dragonViolet = '#889ed1',
            dragonPink = '#ca90ce',
            dragonAqua = '#8ccfc9',
            dragonTeal = '#97aedb',
            dragonAsh = '#65b365',
            dragonGray = '#cfcf9b',
            dragonGray2 = '#caba90',
            dragonGray3 = '#6fb7af',
            dragonWhite = '#cfe7cf',
            dragonBlack0 = '#121111',
            dragonBlack1 = '#181814',
            dragonBlack2 = '#22211e',
            dragonBlack3 = '#1d1b1b',
            dragonBlack4 = '#2d2c2c',
            dragonBlack5 = '#3e3d3b',
            dragonBlack6 = '#67635f',
          },
        },
      }
      vim.cmd 'colorscheme kanagawa-dragon'
      vim.api.nvim_set_hl(0, 'Comment', { fg = '#7a8f7a', italic = false })
    end,
  },

  -- -------------------------------------------------------
  -- SNACKS  (picker + dashboard)
  -- -------------------------------------------------------
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },

      scroll = {
        enabled = true,
        animate = {
          duration = { step = 10, total = 100 }, -- shorter than default
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
          sections = {
            { section = 'header' },
            { section = 'keys' },
            { section = 'recent_files' },
            { section = 'projects' },
          },
        },

        keys = {
          { key = 'f', desc = 'Find files', action = function() require('snacks').picker.files() end },
          { key = 'g', desc = 'Live grep', action = function() require('snacks').picker.grep() end },
          { key = 'b', desc = 'Buffers', action = function() require('snacks').picker.buffers() end },
          { key = 'r', desc = 'Recent files', action = function() require('snacks').picker.recent() end },
          { key = '/', desc = 'Search in file', action = function() require('snacks').picker.lines() end },
        },
      },
    },
  },

  -- -------------------------------------------------------
  -- TROUBLE  (diagnostics UI)
  -- -------------------------------------------------------

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  -- -------------------------------------------------------
  -- TODO COMMENTS
  -- -------------------------------------------------------

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

  -- -------------------------------------------------------
  -- AI  (CodeCompanion → local Ollama)
  -- -------------------------------------------------------

  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'ollama',
          slash_commands = {
            buffer = {
              opts = { provider = 'default' },
            },
          },
        },
        inline = { adapter = 'ollama' },
      },
      adapters = {
        ollama = function()
          return require('codecompanion.adapters').extend('ollama', {
            schema = {
              model = { default = 'qwen2.5-coder:7b' },
            },
          })
        end,
      },
    },
  },

  -- -------------------------------------------------------
  -- BUFFERLINE
  -- -------------------------------------------------------

  {
    'akinsho/bufferline.nvim',

    opts = {

      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        show_buffer_close_icons = true,
        show_close_icon = false,
      },
    },
  },

  -- -------------------------------------------------------
  -- NEOTREE (quick file manager)
  -- -------------------------------------------------------

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      filesystem = {
        hijack_netrw_behavior = 'open_current',
        filtered_items = {
          visible = true,
        },
      },
      window = {
        width = 35,
        mappings = {
          -- vim movement are default binds (enter also works)
          ['v'] = 'open_vsplit',
          ['x'] = 'open_split',
        },
      },
      event_handlers = {
        {
          event = 'file_opened',
          handler = function() require('neo-tree.command').execute { action = 'close' } end,
        },
      },
    },
  },

  -- -------------------------------------------------------
  -- HARPOON  (quick file marks)
  -- -------------------------------------------------------

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
}, {
  -- Lazy UI icons (fallback for non-nerd-font setups)
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- =========================================================
-- CUSTOM KEYMAPS
-- (all plugin keymaps live here, after lazy.setup)
-- =========================================================

local snacks = require 'snacks'

-- ── Quick access ──────────────────────────────────────────
vim.keymap.set('n', '<leader><space>', function() snacks.picker.files() end, { desc = 'Find files' })

-- ── f → Find (local / buffer) ─────────────────────────────
vim.keymap.set('n', '<leader>ff', function() snacks.picker.lines() end, { desc = 'Find in buffer (lines)' })
vim.keymap.set('n', '<leader>fb', function() snacks.picker.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fc', function() snacks.picker.commands() end, { desc = 'Commands' })
vim.keymap.set('n', '<leader>fe', '<cmd>Oil<cr>', { desc = 'Explore (Oil)' })
vim.keymap.set('n', '<leader>fh', function() snacks.picker.help() end, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fk', function() snacks.picker.keymaps() end, { desc = 'Keymaps' })

-- ── s → Search (project-wide) ─────────────────────────────
vim.keymap.set('n', '<leader>sg', function() snacks.picker.grep() end, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>sr', function() snacks.picker.recent() end, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>sw', function() snacks.picker.grep_word() end, { desc = 'Grep word under cursor' })
vim.keymap.set('n', '<leader>sn', function() snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = 'Search nvim config' })

-- ── a → AI (CodeCompanion) ────────────────────────────────
vim.keymap.set({ 'n', 'v' }, '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'Chat toggle' })
vim.keymap.set({ 'n', 'v' }, '<leader>aa', '<cmd>CodeCompanionActions<cr>', { desc = 'Actions' })
-- check if the buffer exists or not, handles dupe code blocks on init load
vim.keymap.set('v', '<leader>ai', function()
  local has_chat = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == 'codecompanion' then
      has_chat = true
      break
    end
  end
  if has_chat then
    vim.cmd 'CodeCompanionChat Add'
  else
    vim.cmd 'CodeCompanionChat Toggle'
  end
end, { desc = 'Send selection to chat' })
vim.keymap.set('v', '<leader>ae', '<cmd>CodeCompanionChat Explain<cr>', { desc = 'Explain selection' })
vim.keymap.set('v', '<leader>af', '<cmd>CodeCompanionChat Fix<cr>', { desc = 'Fix selection' })

-- ── e → NeoTree ───────────────────────────────────────────
vim.keymap.set('n', '-', '<cmd>Neotree toggle<cr>', { desc = 'Neo-tree toggle' })

-- ── b → Buffers ───────────────────────────────────────────
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bd<cr>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bD', '<cmd>bd!<cr>', { desc = 'Delete buffer (force)' })

-- ── g → Git ───────────────────────────────────────────────
-- Diffview
-- toggles open/close without two binds
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
end, { desc = 'File [H]istory (current file)' })
-- Gitsigns binds are set buffer-locally in gitsigns on_attach above

-- ── h → Harpoon ───────────────────────────────────────────
local function harpoon_map(keys, fn, desc) vim.keymap.set('n', keys, fn, { desc = desc }) end

harpoon_map('<leader>ha', function() require('harpoon'):list():add() end, 'Add file')
harpoon_map('<leader>hh', function()
  local h = require 'harpoon'
  h.ui:toggle_quick_menu(h:list())
end, 'Menu')
harpoon_map('<leader>hn', function() require('harpoon'):list():next() end, 'Next mark')
harpoon_map('<leader>hp', function() require('harpoon'):list():prev() end, 'Prev mark')
harpoon_map('<leader>h1', function() require('harpoon'):list():select(1) end, 'Jump to mark 1')
harpoon_map('<leader>h2', function() require('harpoon'):list():select(2) end, 'Jump to mark 2')
harpoon_map('<leader>h3', function() require('harpoon'):list():select(3) end, 'Jump to mark 3')
harpoon_map('<leader>h4', function() require('harpoon'):list():select(4) end, 'Jump to mark 4')

-- ── m → Marks ───────────────────────────────────────────
vim.keymap.set('n', '<leader>ml', '<cmd>marks<cr>', { desc = '[M]arks [L]ist' })
vim.keymap.set('n', '<leader>mc', function() vim.cmd 'delmarks!' end, { desc = '[M]arks [C]lear' })

-- ── x → Diagnostics / Trouble ─────────────────────────────
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Workspace diagnostics' })
vim.keymap.set('n', '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer diagnostics' })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble quickfix toggle<cr>', { desc = 'Quickfix list' })
vim.keymap.set('n', '<leader>xd', function() snacks.picker.diagnostics() end, { desc = 'Diagnostics picker' })
vim.keymap.set('n', '<leader>n', function() Snacks.scratch() end, { desc = 'Scratch buffer' })

-- ── Disable tabline (bufferline handles this) ─────────────
vim.opt.showtabline = 2

-- ── Tab management ──────────────────────────────────────────
vim.keymap.set('n', '<leader><tab>n', '<cmd>tabnew<cr>', { desc = 'New tab' })
vim.keymap.set('n', '<leader><tab>z', '<cmd>tab split<cr>', { desc = 'Zoom tab' })
vim.keymap.set('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next tab' })
vim.keymap.set('n', '<leader><tab>[', '<cmd>tabprev<cr>', { desc = 'Prev tab' })
vim.keymap.set('n', '<leader><tab>c', '<cmd>tabclose<cr>', { desc = 'Close tab' })

-- Buffer cleanup
vim.keymap.set('n', '<leader>ba', '<cmd>%bd<cr>', { desc = 'Close all buffers' })
vim.keymap.set('n', '<leader>bo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Close other buffers' })

-- vim: ts=2 sts=2 sw=2 et
