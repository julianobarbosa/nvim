return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      -- Basic Copilot configuration
      vim.g.copilot_enabled = true
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""

      -- Configure which-key integration
      local wk = require('which-key')
      wk.register({
        c = {
          name = "[C]opilot",
          t = { "<cmd>Copilot toggle<CR>", "Toggle Copilot" },
          s = { "<cmd>Copilot suggest<CR>", "Suggest" },
          n = { "<cmd>Copilot next<CR>", "Next suggestion" },
          p = { "<cmd>Copilot prev<CR>", "Previous suggestion" },
          r = { "<cmd>Copilot refresh<CR>", "Refresh suggestions" },
          d = { "<cmd>Copilot dismiss<CR>", "Dismiss suggestion" },
          a = { "<cmd>Copilot accept<CR>", "Accept suggestion" },
        },
      }, { prefix = "<leader>" })

      -- Setup statusline integration
      local statusline = require('mini.statusline')
      local default_section_status = statusline.section_status
      statusline.section_status = function()
        local status = default_section_status()
        if vim.g.copilot_enabled then
          return status .. ' 🤖'
        end
        return status
      end

      -- Setup copilot-cmp integration
      require('copilot_cmp').setup({
        method = 'getCompletionsCycling',
        formatters = {
          label = require('copilot_cmp.format').format_label_text,
          insert_text = require('copilot_cmp.format').format_insert_text,
          preview = require('copilot_cmp.format').format_preview_text,
        },
      })

      -- Add custom keymaps for suggestion control
      vim.keymap.set('i', '<C-j>', 'copilot#Accept("<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = 'Accept Copilot suggestion',
      })
      vim.keymap.set('i', '<C-h>', '<Plug>(copilot-dismiss)',
        { desc = 'Dismiss Copilot suggestion' })
      vim.keymap.set('i', '<C-n>', '<Plug>(copilot-next)',
        { desc = 'Next Copilot suggestion' })
      vim.keymap.set('i', '<C-p>', '<Plug>(copilot-previous)',
        { desc = 'Previous Copilot suggestion' })
      vim.keymap.set('i', '<C-s>', '<Plug>(copilot-suggest)',
        { desc = 'Trigger Copilot suggestion' })

      -- Create user commands for common operations
      vim.api.nvim_create_user_command('CopilotToggle', function()
        vim.g.copilot_enabled = not vim.g.copilot_enabled
        if vim.g.copilot_enabled then
          print('Copilot enabled')
        else
          print('Copilot disabled')
        end
      end, {})

      -- Add Copilot source to nvim-cmp
      local cmp = require('cmp')
      cmp.setup({
        sources = cmp.config.sources({
          { name = 'copilot', group_index = 2 },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }),
      })
    end,
  }
}