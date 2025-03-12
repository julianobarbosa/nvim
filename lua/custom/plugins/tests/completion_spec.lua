local helpers = require('tests.helpers')
local commit_template = require('custom.plugins.commit_template')
local cmp_ok, cmp = pcall(require, 'cmp')

if not cmp_ok then
  print("Skipping completion tests - nvim-cmp not available")
  return
end

describe("copilot commit completion", function()
  local source, buf, original_config

  before_each(function()
    helpers.setup()
    
    -- Store original cmp config
    original_config = cmp.get_config()
    
    -- Create test buffer
    buf = helpers.buffer.create({
      modifiable = true,
      filetype = 'gitcommit'
    })

    -- Get source instance
    source = cmp.get_config().sources[1]
  end)

  after_each(function()
    -- Restore original config
    cmp.setup(original_config)
    helpers.cleanup()
  end)

  describe("source configuration", function()
    it("registers commit_template source", function()
      local found = false
      for _, src in ipairs(cmp.get_config().sources) do
        if src.name == 'commit_template' then
          found = true
          break
        end
      end
      assert.equals(true, found, "Completion source not registered")
    end)

    it("sets correct priority", function()
      local source_config
      for _, src in ipairs(cmp.get_config().sources) do
        if src.name == 'commit_template' then
          source_config = src
          break
        end
      end
      assert.equals(100, source_config.priority, "Incorrect source priority")
    end)

    it("configures trigger characters", function()
      local chars = source:get_trigger_characters()
      assert.equals(2, #chars, "Wrong number of trigger characters")
      assert.matches(":", chars[1], "Missing ':' trigger")
      assert.matches(" ", chars[2], "Missing space trigger")
    end)
  end)

  describe("completion items", function()
    local items

    before_each(function()
      items = source:complete(
        { option = {} },
        function(result) return result end
      ).items
    end)

    it("provides items for all commit types", function()
      local found_types = {}
      for _, item in ipairs(items) do
        local type = item.label:match("^(%w+):")
        if type then
          found_types[type] = true
        end
      end

      -- Check all commit types have completions
      for type, _ in pairs(commit_template.type_emojis) do
        assert.equals(true, found_types[type], 
          string.format("Missing completion for type: %s", type))
      end
    end)

    it("formats items correctly", function()
      for _, item in ipairs(items) do
        -- Check label format (type: emoji)
        assert.matches("^%w+:%s+[" .. table.concat(vim.tbl_values(commit_template.type_emojis)) .. "]$", 
          item.label, "Invalid completion label format")

        -- Check documentation
        assert.equals(true, item.documentation ~= nil, "Missing documentation")
        assert.equals('markdown', item.documentation.kind, "Wrong documentation type")
        assert.matches("Commit type:", item.documentation.value, "Missing type description")
      end
    end)

    it("includes emoji in documentation", function()
      for _, item in ipairs(items) do
        local type = item.label:match("^(%w+):")
        if type then
          local emoji = commit_template.type_emojis[type]
          assert.matches(emoji, item.documentation.value, 
            string.format("Missing emoji %s in documentation for type %s", emoji, type))
        end
      end
    end)
  end)

  describe("integration behavior", function()
    it("activates for gitcommit files", function()
      local config = cmp.get_config()
      local gitcommit_config = config.filetype_config and config.filetype_config.gitcommit

      assert.equals(true, gitcommit_config ~= nil, "Missing gitcommit config")
      assert.equals(true, #gitcommit_config.sources > 0, "No sources configured")

      local has_source = false
      for _, src in ipairs(gitcommit_config.sources) do
        if src.name == 'commit_template' then
          has_source = true
          break
        end
      end
      assert.equals(true, has_source, "commit_template source not active")
    end)

    it("integrates with copilot source", function()
      local config = cmp.get_config()
      local gitcommit_config = config.filetype_config and config.filetype_config.gitcommit

      local found_template = false
      local found_copilot = false

      for _, src in ipairs(gitcommit_config.sources) do
        if src.name == 'commit_template' then found_template = true end
        if src.name == 'copilot' then found_copilot = true end
      end

      assert.equals(true, found_template, "commit_template source missing")
      assert.equals(true, found_copilot, "copilot source missing")
    end)
  end)
end)