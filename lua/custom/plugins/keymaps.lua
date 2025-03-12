return {
  -- Custom keymaps with which-key integration
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      plugins = {
        marks = true,
        registers = true,
        spelling = { enabled = false },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      window = {
        border = 'single',
        position = 'bottom',
      },
      show_help = true,
      show_keys = true,
    },
    config = function(_, opts)
      local wk = require 'which-key'
      wk.setup(opts)

      -- Register all our mapping groups
      wk.register {
        ['<leader>'] = {
          f = { name = '+file' },
          b = { name = '+buffer' },
          w = { name = '+window' },
          g = { name = '+git' },
          l = { name = '+lsp' },
          s = { name = '+search' },
          c = { name = '+code', mode = { 'n', 'v' } },
          d = { name = '+document' },
          t = { name = '+toggle' },
          h = { name = '+hunk', mode = { 'n', 'v' } },
        },
      }

      -- Add custom keybindings for buffer cycling
      wk.register {
        ['<leader>'] = {
          b = {
            name = '+buffer',
            h = { '<S-h>', description = 'Cycle through previous buffers' }, -- Shift+H
            p = { '<S-p>', description = 'Cycle through next buffers' }, -- Shift+P
          },
        },
      }
    end,
  },
}

