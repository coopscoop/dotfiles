-- =========================================================
-- AI  (CodeCompanion → local Ollama)
-- Purgatory wing: the whole feature is this one file.
-- Delete (or gut) it when the context grabber lands.
-- =========================================================

return {
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

    config = function(_, opts)
      require('codecompanion').setup(opts)

      -- Snacks notify wrapper for the request lifecycle
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
    end,
  },
}
