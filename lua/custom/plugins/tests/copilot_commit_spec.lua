local helpers = require('tests.helpers')
local copilot_commit = require('custom.plugins.copilot_commit')
local commit_template = require('custom.plugins.commit_template')

describe("copilot_commit", function()
  local buf

  before_each(function()
    helpers.setup()
    buf = helpers.buffer.create({
      modifiable = true,
      filetype = 'gitcommit'
    })
  end)

  after_each(function()
    helpers.cleanup()
  end)

  describe("setup", function()
    before_each(function()
      copilot_commit.setup()
    end)

    it("creates the commit message augroup", function()
      local group = vim.api.nvim_get_autocmds({ group = "CopilotCommit" })
      assert.equals(true, group ~= nil, "Augroup not created")
    end)

    it("registers FileType autocmd for gitcommit", function()
      local autocmds = vim.api.nvim_get_autocmds({
        group = "CopilotCommit",
        event = "FileType",
        pattern = "gitcommit"
      })
      assert.equals(1, #autocmds, "Autocmd not registered")
    end)
  end)

  describe("template insertion", function()
    before_each(function()
      copilot_commit.setup()
    end)

    it("inserts template in empty buffer", function()
      -- Check initial state
      local content = helpers.buffer.get_content(buf)
      assert.equals("", content, "Buffer should be empty")

      -- Trigger FileType autocmd
      vim.cmd("doautocmd FileType gitcommit")

      -- Verify template was inserted
      content = helpers.buffer.get_content(buf)
      assert.matches("type%(scope%)", content, "Template not inserted")
      assert.matches("Technical:", content, "Missing technical section")
      assert.matches("User Impact:", content, "Missing user impact section")
    end)

    it("doesn't insert template in non-empty buffer", function()
      -- Add content to buffer
      local message = "feat: Test commit"
      helpers.buffer.set_lines(buf, {message})

      -- Trigger FileType autocmd
      vim.cmd("doautocmd FileType gitcommit")

      -- Check content wasn't changed
      local content = helpers.buffer.get_content(buf)
      assert.equals(message, content, "Buffer content was modified")
    end)
  end)

  describe("validation", function()
    local notify

    before_each(function()
      copilot_commit.setup()
      notify = helpers.mock.notify()
    end)

    it("validates commit message on save", function()
      -- Set invalid message
      helpers.buffer.set_lines(buf, {"Invalid commit message"})

      -- Trigger BufWritePre
      vim.cmd("doautocmd BufWritePre")

      -- Check notification
      notify.assert_called("format issues", vim.log.levels.WARN)
    end)

    it("shows success for valid message", function()
      -- Set valid message
      local content = commit_template.generate_template()
      local lines = vim.split(content, "\n")
      helpers.buffer.set_lines(buf, lines)

      -- Manually trigger validation
      vim.api.nvim_buf_call(buf, function()
        vim.fn.execute("normal \\cv")
      end)

      -- Check notification
      notify.assert_called("format is valid", vim.log.levels.INFO)
    end)
  end)

  describe("completion integration", function()
    local has_cmp = pcall(require, 'cmp')
    if not has_cmp then
      pending("nvim-cmp not available")
      return
    end

    it("registers completion source", function()
      copilot_commit.setup()
      local sources = require('cmp').get_config().sources

      local found = false
      for _, source in ipairs(sources) do
        if source.name == 'commit_template' then
          found = true
          break
        end
      end
      assert.equals(true, found, "Completion source not registered")
    end)

    it("provides commit type completions", function()
      local source = require('cmp.source').get('commit_template')
      local items = source:complete(
        { option = {} },
        function(result) return result end
      )

      -- Check basic structure
      assert.equals(true, items ~= nil, "No completion items returned")
      assert.equals(true, #items > 0, "Empty completion items")

      -- Check item format
      local item = items[1]
      assert.equals(true, item.label ~= nil, "Missing label")
      assert.equals(true, item.documentation ~= nil, "Missing documentation")
      assert.matches(": ", item.label, "Invalid label format")
    end)
  end)
end)