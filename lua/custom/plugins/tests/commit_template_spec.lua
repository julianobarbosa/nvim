local helpers = require('tests.helpers')
local commit_template = require('custom.plugins.commit_template')
local assert = helpers.assert

-- Test data
local valid_message = [[
feat(auth): ✨ Add OAuth support

Technical:
  • 🔧 Configure OAuth client
User Impact:
  • 💡 Add social login
Performance:
  • ⚡ Optimize token handling

-JMB]]

local invalid_messages = {
  no_type = "Add feature",
  no_emoji = "feat: Add feature",
  long_first_line = "feat: " .. string.rep("a", 100),
  wrong_bullet = "* Wrong bullet format",
  no_signature = [[
feat: ✨ Feature

Technical:
  • 🔧 Detail
User Impact:
  • 💡 Impact]]
}

describe("commit_template", function()
  local buffer

  before_each(function()
    helpers.setup()
    buffer = helpers.buffer.create({ modifiable = true })
  end)

  after_each(function()
    helpers.cleanup()
  end)

  describe("emoji mappings", function()
    it("has all required commit types", function()
      local required_types = {"feat", "fix", "docs", "style", "refactor", "test", "chore"}
      for _, type in ipairs(required_types) do
        assert.equals(true, commit_template.type_emojis[type] ~= nil,
          string.format("Missing emoji for commit type: %s", type))
      end
    end)

    it("has all category emojis", function()
      local categories = {"technical", "user", "performance"}
      for _, category in ipairs(categories) do
        local emojis = commit_template.category_emojis[category]
        assert.equals(true, emojis ~= nil,
          string.format("Missing emojis for category: %s", category))
        assert.equals(true, #emojis > 0,
          string.format("No emojis defined for category: %s", category))
      end
    end)
  end)

  describe("template generation", function()
    it("generates valid template", function()
      local template = commit_template.generate_template()
      
      -- Basic structure
      assert.matches("type%(scope%)", template)
      assert.matches("Technical:", template)
      assert.matches("User Impact:", template)
      assert.matches("Performance:", template)
      
      -- Formatting
      assert.matches("^type%(scope%):", template:match("^[^\n]+"))
      assert.matches("  • 🔧", template)
      assert.matches("  • 💡", template)
      assert.matches("  • ⚡", template)
      
      -- Signature
      assert.matches("%-JMB%s*$", template)
    end)

    it("inserts template into buffer", function()
      vim.api.nvim_buf_set_lines(buffer, 0, -1, false, {})
      commit_template.insert_template()
      
      local content = helpers.buffer.get_content(buffer)
      assert.matches("type%(scope%)", content)
      assert.matches("Technical:", content)
      assert.matches("User Impact:", content)
      assert.matches("%-JMB%s*$", content)
    end)
  end)

  describe("message validation", function()
    it("accepts valid commit messages", function()
      local valid, errors = commit_template.validate_message(valid_message)
      assert.equals(true, valid)
      assert.equals(0, #errors)
    end)

    it("requires conventional commit format", function()
      local valid, errors = commit_template.validate_message(invalid_messages.no_type)
      assert.equals(false, valid)
      assert.matches("Invalid commit format", errors[1])
    end)

    it("requires emoji in first line", function()
      local valid, errors = commit_template.validate_message(invalid_messages.no_emoji)
      assert.equals(false, valid)
      assert.matches("Invalid commit format", errors[1])
    end)

    it("enforces first line length", function()
      local valid, errors = commit_template.validate_message(invalid_messages.long_first_line)
      assert.equals(false, valid)
      assert.matches("≤50 characters", errors[1])
    end)

    it("validates bullet point format", function()
      local valid, errors = commit_template.validate_message(invalid_messages.wrong_bullet)
      assert.equals(false, valid)
      assert.matches("Invalid bullet point format", errors[1])
    end)

    it("requires signature", function()
      local valid, errors = commit_template.validate_message(invalid_messages.no_signature)
      assert.equals(false, valid)
      assert.matches("Must end with %-JMB", errors[1])
    end)
  end)

  describe("notification handling", function()
    it("shows error on validation failure", function()
      local notify = helpers.mock.notify()
      commit_template.validate_and_notify(invalid_messages.no_type)
      
      notify.assert_called("Invalid commit format", vim.log.levels.ERROR)
    end)

    it("shows success on valid message", function()
      local notify = helpers.mock.notify()
      commit_template.validate_and_notify(valid_message)
      
      notify.assert_called("Commit message is valid", vim.log.levels.INFO)
    end)
  end)
end)