return {
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'folke/which-key.nvim',
    },
    config = function()
      -- Set up which-key integration
      local wk = require('which-key')
      wk.register({
        g = {
          name = '[G]it',
          s = { "<cmd>Git<cr>", "Status" },
          p = { "<cmd>Git push<cr>", "Push" },
          P = { "<cmd>Git pull<cr>", "Pull" },
          b = { "<cmd>Git blame<cr>", "Blame" },
          B = { "<cmd>Telescope git_branches<cr>", "Branches" },
          c = { "<cmd>Git commit<cr>", "Commit" },
          d = { "<cmd>Gvdiffsplit<cr>", "Diff" },
          l = { "<cmd>Telescope git_commits<cr>", "Log" },
          h = { "<cmd>0Gclog<cr>", "File History" },
          S = { "<cmd>Git stash<cr>", "Stash" },
          f = { "<cmd>Telescope git_files<cr>", "Git Files" },
        },
      }, { prefix = "<leader>" })

      -- Configure statusline Git integration with mini.statusline
      local M = {}
      
      -- Safe require for mini.statusline
      local ok_mini, statusline = pcall(require, 'mini.statusline')
      if not ok_mini then
        return
      end

      -- Store original git section function
      local default_section_git = statusline.section_git

      -- New safe git section implementation
      statusline.section_git = function()
        -- Guard against missing default function
        if type(default_section_git) ~= 'function' then
          return ''
        end

        -- Safely get git info
        local git_info = ''
        local ok_git, result = pcall(default_section_git)
        if ok_git and result then
          git_info = result
        end

        -- Early return if no git info
        if git_info == '' then
          return ''
        end

        -- Safely get branch name
        local branch = ''
        local ok_head, head = pcall(vim.fn.FugitiveHead)
        if ok_head and head and head ~= '' then
          branch = head
        end

        -- Return formatted string
        return string.format(' %s', branch ~= '' and branch or git_info)
      end

      -- Set up additional Telescope Git pickers
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>gC', builtin.git_bcommits, { desc = 'Git Buffer Commits' })
      vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Git Status' })
      vim.keymap.set('n', '<leader>gS', builtin.git_stash, { desc = 'Git Stash' })

      -- Custom Git command aliases
      vim.api.nvim_create_user_command('Gpush', 'Git push', {})
      vim.api.nvim_create_user_command('Gpull', 'Git pull', {})
      vim.api.nvim_create_user_command('Gfetch', 'Git fetch', {})
      vim.api.nvim_create_user_command('Gcommit', 'Git commit', {})
    end,
  },
}