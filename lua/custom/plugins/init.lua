-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<F5>', desc = 'Start/Continue Debug' },
      { '<F10>', desc = 'Step Over' },
      { '<F11>', desc = 'Step Into' },
      { '<F12>', desc = 'Step Out' },
      { '<Leader>b', desc = 'Toggle Breakpoint' },
      { '<Leader>B', desc = 'Conditional Breakpoint' },
      { '<Leader>lp', desc = 'Log Point' },
    },
    dependencies = {
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      local dap = require('dap')
      local framework_config = require('custom.plugins.dap_framework_config')
      
      -- Initialize base DAP setup
      require('custom.plugins.dap').setup()
      
      -- Add framework-specific configurations to Python configurations
      for name, config in pairs(framework_config.frameworks) do
        if type(config) == 'table' and config.template then
          table.insert(dap.configurations.python, config.template)
        end
      end
    end,
  }
}
