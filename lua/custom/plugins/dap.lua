return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'
      -- Basic DAP setup
      dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

      -- Performance monitoring configuration
      dap.defaults.fallback.focus_terminal = true
      dap.defaults.fallback.auto_continue_if_many_stopped = false

      -- Initialize configurations table if not exists
      dap.configurations = dap.configurations or {}
      dap.configurations.python = dap.configurations.python or {}
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      local dapui = require 'dapui'
      dapui.setup {
        layouts = {
          {
            elements = {
              -- Performance monitoring elements
              { id = 'scopes', size = 0.25 },
              { id = 'breakpoints', size = 0.25 },
              { id = 'stacks', size = 0.25 },
              { id = 'watches', size = 0.25 },
            },
            position = 'left',
            size = 40,
          },
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            position = 'bottom',
            size = 10,
          },
        },
      }

      -- Auto-open UI on debug events
      local dap = require 'dap'
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      local dap = require 'dap'
      local dap_python = require 'dap-python'

      -- Setup Python debugger with performance monitoring
      dap_python.setup()

      -- Framework configurations with performance settings
      local frameworks = {
        django = {
          type = 'python',
          request = 'launch',
          name = 'Django',
          program = '${workspaceFolder}/manage.py',
          args = { 'runserver', '--noreload' },
          pythonPath = function()
            return vim.fn.exepath 'python'
          end,
          django = true,
          console = 'integratedTerminal',
          justMyCode = false, -- Enable debugging of library code
          env = {
            DJANGO_SETTINGS_MODULE = '${workspaceFolderBasename}.settings',
            PYTHONUNBUFFERED = '1',
          },
        },
        fastapi = {
          type = 'python',
          request = 'launch',
          name = 'FastAPI',
          program = '${file}',
          args = { '--reload' },
          pythonPath = function()
            return vim.fn.exepath 'python'
          end,
          console = 'integratedTerminal',
          justMyCode = false, -- Enable debugging of library code
          env = {
            PYTHONPATH = '${workspaceFolder}',
          },
        },
      }

      -- Add framework configurations
      for _, config in pairs(frameworks) do
        table.insert(dap.configurations.python, config)
      end

      -- Add performance monitoring configuration
      table.insert(dap.configurations.python, {
        type = 'python',
        request = 'launch',
        name = 'Python: Profile Current File',
        program = '${file}',
        pythonPath = function()
          return vim.fn.exepath 'python'
        end,
        console = 'integratedTerminal',
        justMyCode = false,
        env = {
          PYTHONPROFILEIMPORTTIME = '1',
        },
      })
    end,
  },
}

