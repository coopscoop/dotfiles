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
-- default binds anyways, these are depreiated functions
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })

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
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
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

        -- f → file-local search
        { '<leader>f', group = 'File' },
        { '<leader>f', desc = 'Find lines in current file' },

        -- s → project-wide search
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

        -- b → buffer management
        { '<leader>b', group = 'Buffers' },
        { '<leader>B', desc = 'Buffer search' },
        { '<leader>bn', desc = 'Next buffer' },
        { '<leader>bp', desc = 'Prev buffer' },
        { '<leader>bd', desc = 'Delete buffer' },
        { '<leader>bD', desc = 'Delete buffer (force)' },
        { '<leader>ba', desc = 'Close all buffers' },
        { '<leader>bo', desc = 'Close other buffers' },

        -- g → git
        { '<leader>g', group = 'Git' },
        { '<leader>gd', desc = 'Diff' },
        { '<leader>gh', desc = 'File history' },
        { '<leader>gp', desc = 'Preview hunk' },
        { '<leader>gs', desc = 'Stage hunk' },
        { '<leader>gu', desc = 'Undo stage hunk' },
        { '<leader>gS', desc = 'Stage buffer' },
        { '<leader>gb', desc = 'Blame line' },
        { '<leader>gB', desc = 'Blame line (full)' },
        { '<leader>gR', desc = 'Reset hunk' },

        -- a → AI
        { '<leader>a', group = 'AI' },
        { '<leader>A', desc = 'Inline' },
        { '<leader>ac', desc = 'Chat toggle' },
        { '<leader>aa', desc = 'Actions' },
        { '<leader>as', desc = 'Add selection' },
        { '<leader>ax', desc = 'New chat' },
        { '<leader>ar', desc = 'Refresh cache' },

        -- d → diagnostics
        { '<leader>d', group = 'Diagnostics' },
        { '<leader>D', desc = 'Open diagnostic list' },

        -- h → Harpoon
        { '<leader>h', group = 'Harpoon' },
        { '<leader>H', desc = 'Harpoon menu' },
        { '<leader>ha', desc = 'Add file' },
        { '<leader>hn', desc = 'Next file' },
        { '<leader>hp', desc = 'Previous file' },

        -- n → project notes
        { '<leader>N', desc = 'Toggle project todo' },

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
  -- LSP
  -- -------------------------------------------------------

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} }, ---@diagnostic disable-line: missing-fields
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
          map('<leader>C', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
          map('<leader>cs', vim.lsp.buf.document_symbol, 'Document symbols')
          map('<leader>cS', vim.lsp.buf.workspace_symbol, 'Workspace symbols')
          map('gD', vim.lsp.buf.declaration, 'Goto declaration')
          map('gd', vim.lsp.buf.definition, 'Goto definition')
          map('gr', vim.lsp.buf.references, 'References')
          map('K', vim.lsp.buf.hover, 'Hover docs')

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

      -- LSP UPDATE ON FILE SAVE
      vim.lsp.config('*', {
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      })
      ---@type table<string, vim.lsp.Config>
      local servers = {
        lua_ls = {
          on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
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
        ts_ls = {},

        eslint = {},
      }

      require('mason-tool-installer').setup {
        ensure_installed = {
          'lua-language-server',
          'typescript-language-server',
          'eslint-lsp',
          'stylua',
          'prettier',
        },
      }

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
        lua = { 'stylua' },

        -- javascript = { 'prettier' },
        -- javascriptreact = { 'prettier' },
        -- typescript = { 'prettier' },
        -- typescriptreact = { 'prettier' },

        json = { 'prettier' },
        jsonc = { 'prettier' },

        css = { 'prettier' },
      },
    },
  },

  -- -------------------------------------------------------
  -- COMPLETION
  -- -------------------------------------------------------
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
      },
    },
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
        documentation = { auto_show = true },
        ghost_text = { enabled = true },
        list = {
          selection = { preselect = true, auto_insert = false },
        },
      },
      snippets = {
        preset = 'luasnip',
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
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
        modes = { insert = true, command = false, terminal = false },
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

      vim.api.nvim_set_hl(0, 'HarpoonActive', {
        link = 'Title',
      })

      local original_filename = statusline.section_filename

      statusline.section_filename = function(args)
        local harpoon = require 'harpoon'
        local items = harpoon:list().items
        local current = vim.api.nvim_buf_get_name(0)
        local parts = {}

        for i = 1, math.min(#items, 4) do
          local path = items[i].value
          local name = vim.fn.fnamemodify(path, ':t')

          if path == current then
            table.insert(parts, string.format('%%#HarpoonActive#[%d] %s%%*', i, name))
          else
            table.insert(parts, string.format('%%#MiniStatuslineFilename#[%d] %s%%*', i, name))
          end
        end

        local marks = table.concat(parts, '  ')
        local filename = original_filename(args)

        if marks == '' then return filename end

        return marks .. '  ' .. filename
      end
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

  -- {
  --   'rebelot/kanagawa.nvim',
  --   config = function()
  --     require('kanagawa').setup {
  --       colors = {
  --         palette = {
  --           dragonRed = '#e87b73',
  --           dragonGreen = '#86d386',
  --           dragonGreen2 = '#9ec975',
  --           dragonYellow = '#e6cc91',
  --           dragonOrange = '#dda27d',
  --           dragonOrange2 = '#df9a7d',
  --           dragonBlue2 = '#8cbfd8',
  --           dragonViolet = '#889ed1',
  --           dragonPink = '#ca90ce',
  --           dragonAqua = '#8ccfc9',
  --           dragonTeal = '#97aedb',
  --           dragonAsh = '#65b365',
  --           dragonGray = '#cfcf9b',
  --           dragonGray2 = '#caba90',
  --           dragonGray3 = '#6fb7af',
  --           dragonWhite = '#cfe7cf',
  --           dragonBlack0 = '#121111',
  --           dragonBlack1 = '#181814',
  --           dragonBlack2 = '#22211e',
  --           dragonBlack3 = '#1d1b1b',
  --           dragonBlack4 = '#2d2c2c',
  --           dragonBlack5 = '#3e3d3b',
  --           dragonBlack6 = '#67635f',
  --         },
  --       },
  --     }
  --     vim.cmd 'colorscheme kanagawa-dragon'
  --     vim.api.nvim_set_hl(0, 'Comment', { fg = '#7a8f7a', italic = false })
  --
  --     -- make background clear
  --     vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
  --     vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })
  --     vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
  --     vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE' })
  --   end,
  -- },

  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
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
      -- Movement (replaces your <C-hjkl> window nav binds)
      { '<C-h>', function() require('smart-splits').move_cursor_left() end, desc = 'Move to left split' },
      { '<C-j>', function() require('smart-splits').move_cursor_down() end, desc = 'Move to split below' },
      { '<C-k>', function() require('smart-splits').move_cursor_up() end, desc = 'Move to split above' },
      { '<C-l>', function() require('smart-splits').move_cursor_right() end, desc = 'Move to right split' },
      -- Resize (Alt+hjkl, mirrors the tmux config below)
      { '<A-h>', function() require('smart-splits').resize_left() end, desc = 'Resize left' },
      { '<A-j>', function() require('smart-splits').resize_down() end, desc = 'Resize down' },
      { '<A-k>', function() require('smart-splits').resize_up() end, desc = 'Resize up' },
      { '<A-l>', function() require('smart-splits').resize_right() end, desc = 'Resize right' },
    },
  },

  -- -------------------------------------------------------
  -- SNACKS  (picker + dashboard)
  -- -------------------------------------------------------
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = { hidden = true },
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
    },

    opts = {
      adapters = {
        http = {
          llama = function()
            return require('codecompanion.adapters').extend('openai_compatible', {
              env = {
                url = 'http://127.0.0.1:8080',
                api_key = 'local',
                chat_url = '/v1/chat/completions',
              },

              schema = {
                model = {
                  default = 'Qwen3.5-9B',
                },
              },
            })
          end,
        },
      },

      interactions = {
        chat = {
          adapter = 'llama',

          opts = {
            -- Automatically manage the conversation as it approaches
            -- the model's context limit.
            context_management = {
              enabled = true,

              editing = {
                trigger = 0.65,
                keep_cycles = 3,
              },

              compaction = {
                trigger = 0.85,
              },
            },
          },
        },

        inline = {
          adapter = 'llama',
        },
      },

      -- Project-wide instructions.
      rules = {
        default = {
          description = 'Project coding rules',
          files = {
            'AGENTS.md',
          },
        },

        opts = {
          chat = {
            autoload = 'default',
            enabled = true,
          },
        },
      },

      display = {
        chat = {
          start_in_insert_mode = true,
          show_header_separator = false,
          show_token_count = true,
        },

        diff = {
          enabled = true,
        },
      },
    },

    keys = {
      {
        '<leader>ac',
        '<cmd>CodeCompanionChat Toggle<cr>',
        mode = { 'n', 'v' },
        desc = 'CodeCompanion Chat',
      },

      {
        '<leader>aa',
        '<cmd>CodeCompanionActions<cr>',
        mode = { 'n', 'v' },
        desc = 'CodeCompanion Actions',
      },

      {
        '<leader>A',
        '<cmd>CodeCompanion<cr>',
        mode = { 'n', 'v' },
        desc = 'CodeCompanion Inline',
      },

      {
        '<leader>as',
        '<cmd>CodeCompanionChat Add<cr>',
        mode = 'v',
        desc = 'Add selection to CodeCompanion',
      },

      {
        '<leader>ax',
        '<cmd>CodeCompanionChat<cr>',
        mode = 'n',
        desc = 'New CodeCompanion Chat',
      },

      {
        '<leader>ar',
        '<cmd>CodeCompanionChat RefreshCache<cr>',
        mode = 'n',
        desc = 'Refresh CodeCompanion',
      },
    },
  },

  -- -------------------------------------------------------
  -- RENDER MARKDOWN - pretty markdown preview
  -- -------------------------------------------------------
  --
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
    opts = {},
  },

  -- -------------------------------------------------------
  -- HARPOON  (quick file marks)
  -- -------------------------------------------------------

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    keys = {
      { '<leader>ha', function() require('harpoon'):list():add() end, desc = 'Harpoon add file' },
      {
        '<leader>H',
        function()
          local harpoon = require 'harpoon'
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'Harpoon menu',
      },
      { '<leader>1', function() require('harpoon'):list():select(1) end, desc = 'Harpoon file 1' },
      { '<leader>2', function() require('harpoon'):list():select(2) end, desc = 'Harpoon file 2' },
      { '<leader>3', function() require('harpoon'):list():select(3) end, desc = 'Harpoon file 3' },
      { '<leader>4', function() require('harpoon'):list():select(4) end, desc = 'Harpoon file 4' },
    },
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
-- CODE COMPANION INLINE NOTIF
-- =========================================================
local cc_notifier

vim.api.nvim_create_autocmd('User', {
  pattern = 'CodeCompanionRequestStarted',
  callback = function()
    cc_notifier = Snacks.notify('󰚩 Working...', {
      title = 'CodeCompanion',
      timeout = 100000,
    })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'CodeCompanionRequestFinished',
  callback = function()
    if cc_notifier then
      Snacks.notifier.hide(cc_notifier)
      cc_notifier = nil
    end
  end,
})

-- =========================================================
-- CUSTOM KEYMAPS
-- (shared/custom keymaps live here, after lazy.setup)
-- =========================================================

local snacks = require 'snacks'

-- ── Files ────────────────────────────────────────────────────
vim.keymap.set('n', '<leader><space>', function() snacks.picker.files() end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>f', function() snacks.picker.lines() end, { desc = 'Find lines in current file' })

-- ── Search ──────────────────────────────────────────────────
vim.keymap.set('n', '<leader>S', function() snacks.picker.grep() end, { desc = 'Grep repository' })
vim.keymap.set('n', '<leader>sk', function() snacks.picker.keymaps() end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>st', function()
  snacks.picker.grep {
    search = 'TODO|FIXME|HACK|WARN|PERF|NOTE|TEST', -- KEYWORDS TO SEARCH FOR
    regex = true,
  }
end, { desc = 'Search TODO / FIX / HACK' })

-- ── Buffers ─────────────────────────────────────────────────
vim.keymap.set('n', '<leader>B', function() snacks.picker.buffers() end, { desc = 'Buffer search' })
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bd<cr>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bD', '<cmd>bd!<cr>', { desc = 'Delete buffer (force)' })
vim.keymap.set('n', '<leader>ba', '<cmd>%bd<cr>', { desc = 'Close all buffers' })
vim.keymap.set('n', '<leader>bo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Close other buffers' })

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

-- ── Harpoon ──────────────────────────────────────────────────
local function harpoon_redraw() vim.cmd 'redrawstatus' end

vim.keymap.set('n', '<leader>ha', function()
  local harpoon = require 'harpoon'
  harpoon:list():add()
  harpoon_redraw()
end, { desc = 'Harpoon add file' })

vim.keymap.set('n', '<leader>hd', function()
  local harpoon = require 'harpoon'
  harpoon:list():remove()
  harpoon_redraw()
end, { desc = 'Harpoon delete current file' })

vim.keymap.set('n', '<leader>hD', function()
  local harpoon = require 'harpoon'
  harpoon:list():clear()
  harpoon_redraw()
end, { desc = 'Harpoon delete all files' })

for i = 1, 4 do
  vim.keymap.set('n', '<leader>' .. i, function() require('harpoon'):list():select(i) end, { desc = 'Harpoon jump to ' .. i })
end

-- ── Project notes ────────────────────────────────────────────
local TODO_FILENAME = '.todo.md'

local function toggle_todo()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)

    if vim.fn.fnamemodify(name, ':t') == TODO_FILENAME then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  local root = vim.fs.root(0, { '.git' }) or vim.fn.getcwd()
  local todo = root .. '/' .. TODO_FILENAME

  if vim.fn.filereadable(todo) == 0 then vim.fn.writefile({}, todo) end

  vim.cmd 'vsplit'
  vim.cmd('edit ' .. vim.fn.fnameescape(todo))
end

vim.keymap.set('n', '<leader>N', toggle_todo, { desc = 'Toggle project todo' })

-- ── Diagnostics ──────────────────────────────────────────────
vim.keymap.set('n', '<leader>D', function() vim.diagnostic.setloclist { open = true } end, { desc = 'Open diagnostic list' })

-- quick move left/right in insert mode
vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'Move cursor left' })
vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move cursor right' })
