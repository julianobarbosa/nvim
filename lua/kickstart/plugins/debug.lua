-- debug.lua
--
-- Debugger configuration with focus on Python support while maintaining
-- existing Go debugging capabilities
--

return {
  -- Core DAP plugin
  'mfussenegger/nvim-dap',
  -- Dependencies
  dependencies = {
    -- Beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    -- Required for nvim-dap-ui
    'nvim-neotest/nvim-nio',
    -- Debugger installation manager
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    -- Language specific debuggers
    'mfussenegger/nvim-dap-python',  -- Python
    'leoluz/nvim-dap-go',            -- Go
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    -- Mason-nvim-dap setup
    require('mason-nvim-dap').setup({
      automatic_installation = true,
      ensure_installed = {
        'debugpy',  -- Python debugger
        'delve',    -- Go debugger
      },
      handlers = {
        function(config)
          -- All sources with no handler get passed here
          require('mason-nvim-dap').default_setup(config)
        end,
        python = function(config)
          -- Load custom Python configuration
          require('custom.plugins.dap').setup()
        end,
      },
    })

    -- DAP UI setup with consistent styling
    dapui.setup({
      -- Set icons to characters that work in every terminal
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      layouts = {
        {
          elements = {
            'scopes',
            'breakpoints',
            'stacks',
            'watches',
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            'repl',
            'console',
          },
          size = 10,
          position = 'bottom',
        },
      },
    })

    -- Event listeners for UI
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Go debugger setup (preserved from original)
    require('dap-go').setup({
      delve = {
        detached = vim.fn.has('win32') == 0,
      },
    })

    -- Keymaps for debugging
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Override F-keys to avoid conflicts with Python debugger
    keymap('n', '<F5>', dap.continue, opts)
    keymap('n', '<F10>', dap.step_over, opts)
    keymap('n', '<F11>', dap.step_into, opts)
    keymap('n', '<F12>', dap.step_out, opts)
    
    -- Additional debug commands
    keymap('n', '<Leader>b', dap.toggle_breakpoint, opts)
    keymap('n', '<Leader>B', function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, opts)
    keymap('n', '<F7>', dapui.toggle, opts)
  end,
}
