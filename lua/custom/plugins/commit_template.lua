-- Plugin specification wrapper
return {
  "nvim-lua/plenary.nvim", -- Add a dependency to avoid plugin load errors
  name = "commit-template",
  dependencies = {
    "folke/which-key.nvim", -- Add which-key as dependency to ensure proper loading
  },
  event = "VeryLazy",
  config = function()
    -- Original module content
    local M = {
      -- Commit type emojis
      type_emojis = {
        feat = "✨",
        fix = "🐛",
        docs = "📝",
        style = "💄",
        refactor = "♻️",
        test = "✅",
        chore = "🔧"
      },
      -- Category-specific emojis
      category_emojis = {
        technical = {
          "🔧", -- Infrastructure
          "🛠️", -- Implementation
          "⚙️"  -- System
        },
        user = {
          "💡", -- Experience
          "👥", -- Interface
          "🎯"  -- Workflow
        },
        performance = {
          "⚡", -- Speed
          "🚀", -- Optimization
          "📊"  -- Metrics
        }
      }
    }
    
    -- Validate first line format and length
    local function validate_first_line(line)
      -- Check length (≤50 chars)
      if #line > 50 then
        return false, "First line must be ≤50 characters"
      end
      -- Check conventional commit format
      local pattern = "^(%w+)%(?[%w%-]*%)?:%s+[" .. table.concat(vim.tbl_values(M.type_emojis)) .. "]%s+.+$"
      if not line:match(pattern) then
        return false, "Invalid commit format. Expected: type(scope): 🎯 description"
      end
      return true, nil
    end
    
    -- Validate bullet point format
    local function validate_bullet_point(line)
      -- Check length (≤72 chars)
      if #line > 72 then
        return false, "Bullet points must be ≤72 characters"
      end
      -- Get all category emojis
      local all_emojis = {}
      for _, category in pairs(M.category_emojis) do
        for _, emoji in ipairs(category) do
          table.insert(all_emojis, emoji)
        end
      end
      -- Check bullet format with emoji
      local pattern = "^%s*•%s+[" .. table.concat(all_emojis) .. "]%s+.+$"
      if not line:match(pattern) then
        return false, "Invalid bullet point format. Expected: • 🔧 description"
      end
      return true, nil
    end
    
    -- Generate commit message template
    function M.generate_template()
      local template = [[
type(scope): 🎯 Brief description
Technical:
  • 🔧 Implementation detail
User Impact:
  • 💡 User-facing change
Performance:
  • ⚡ Performance impact
-JMB]]
      return template
    end
    
    -- Insert template into current buffer
    function M.insert_template()
      local template = M.generate_template()
      local lines = vim.split(template, "\n")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    end
    
    -- Validate commit message
    function M.validate_message(message)
      local lines = vim.split(message, "\n")
      local errors = {}
      
      -- Validate first line
      local ok, err = validate_first_line(lines[1])
      if not ok then
        table.insert(errors, err)
      end
      -- Track categories found
      local categories = {technical = false, user = false, performance = false}
      local bullet_count = 0
      -- Validate bullet points and categories
      for i = 3, #lines do
        local line = lines[i]
        if line:match("^%s*•") then
          bullet_count = bullet_count + 1
          local ok, err = validate_bullet_point(line)
          if not ok then
            table.insert(errors, err)
          end
        elseif line:match("^Technical:") then
          categories.technical = true
        elseif line:match("^User Impact:") then
          categories.user = true
        elseif line:match("^Performance:") then
          categories.performance = true
        end
      end
      -- Validate category presence and bullet count
      if bullet_count < 2 or bullet_count > 3 then
        table.insert(errors, "Must include 2-3 bullet points")
      end
      -- Validate signature
      if not message:match("%-JMB%s*$") then
        table.insert(errors, "Must end with -JMB signature")
      end
      return #errors == 0, errors
    end
    
    -- Validate and show notification
    function M.validate_and_notify(message)
      local valid, errors = M.validate_message(message)
      if valid then
        vim.notify("Commit message is valid", vim.log.levels.INFO)
      else
        vim.notify(table.concat(errors, "\n"), vim.log.levels.ERROR)
      end
    end
    
    -- Create direct keymappings with descriptions that don't interfere
    local keymap = vim.keymap.set
    keymap('n', '<leader>gc', function() M.insert_template() end, { desc = "Insert commit template" })
    keymap('n', '<leader>gv', function() 
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local message = table.concat(lines, "\n")
      M.validate_and_notify(message)
    end, { desc = "Validate commit message" })
    
    -- Make the module globally accessible without _G pollution
    _G.CommitTemplate = M
    
    -- Register with which-key properly with proper delay to avoid racing conditions
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyDone",
      callback = function()
        pcall(function()
          local wk = require("which-key")
          wk.register({
            g = {
              c = { "Insert commit template" },
              v = { "Validate commit message" }
            }
          }, { prefix = "<leader>" })
        end)
      end
    })
  end
}