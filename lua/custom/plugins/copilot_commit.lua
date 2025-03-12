-- Plugin specification wrapper
return {
  "github/copilot.vim", -- Add dependency on copilot
  name = "copilot-commit",
  config = function()
    -- Original module content
    local M = {}
    
    -- Setup function
    local function setup()
      -- Create augroup for commit message handling
      local commit_group = vim.api.nvim_create_augroup('CopilotCommit', { clear = true })
      -- Auto-setup commit message template
      vim.api.nvim_create_autocmd('FileType', {
        group = commit_group,
        pattern = 'gitcommit',
        callback = function()
          -- Use the global CommitTemplate module that we set up in commit_template.lua
          local template = _G.CommitTemplate
          if not template then
            vim.notify("CommitTemplate module not found", vim.log.levels.ERROR)
            return
          end
          
          local buf = vim.api.nvim_get_current_buf()
          
          -- Only insert template if buffer is empty
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          if #lines == 1 and lines[1] == '' then
            local template_text = template.generate_template()
            local template_lines = vim.split(template_text, '\n')
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, template_lines)
          end
          -- Add buffer-local keymaps
          vim.keymap.set('n', '<leader>cv', function()
            local current_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            local message = table.concat(current_lines, '\n')
            local valid, errors = template.validate_message(message)
            
            if valid then
              vim.notify('Commit message format is valid', vim.log.levels.INFO)
            else
              vim.notify('Commit message format errors:\n' .. table.concat(errors, '\n'), vim.log.levels.ERROR)
            end
          end, { buffer = buf, desc = 'Validate commit message' })
          -- Pre-write validation
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = commit_group,
            buffer = buf,
            callback = function()
              local current_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
              local message = table.concat(current_lines, '\n')
              local valid, errors = template.validate_message(message)
              
              if not valid then
                vim.notify('Warning: Commit message format issues:\n' .. table.concat(errors, '\n'), vim.log.levels.WARN)
              end
            end
          })
        end
      })
      -- Register commit-specific completions with nvim-cmp
      local has_cmp, cmp = pcall(require, 'cmp')
      if has_cmp then
        local commit_source = {
          name = 'commit_template',
          priority = 100,
          get_trigger_characters = function()
            return { ':' }
          end,
          complete = function(self, request, callback)
            -- Use the global CommitTemplate module
            local template = _G.CommitTemplate
            if not template then
              callback({ items = {} })
              return
            end
            
            local items = {}
            
            -- Add commit types
            for type, emoji in pairs(template.type_emojis) do
              table.insert(items, {
                label = type .. ': ' .. emoji,
                documentation = {
                  kind = 'markdown',
                  value = string.format('Commit type: %s\nEmoji: %s', type, emoji)
                }
              })
            end
            callback({ items = items })
          end
        }
        cmp.register_source('commit_template', commit_source)
        
        -- Setup commit-specific completion
        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = 'commit_template' },
            { name = 'copilot' }
          })
        })
      end
    end
    
    -- Run the setup function
    setup()
  end,
  dependencies = {
    "commit-template" -- Reference the commit-template plugin we fixed earlier
  }
}