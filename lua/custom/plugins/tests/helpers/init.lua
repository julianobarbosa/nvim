-- Main test helper module
local M = {}

-- Import submodules
M.buffer = require('tests.helpers.buffer')
M.assert = require('tests.helpers.assert')
M.mock = require('tests.helpers.mock')

-- Global test state
_G.test_state = _G.test_state or {
  buffers = {},
  notifications = {},
  mocks = {
    notify = {},
    commands = {},
    keymaps = {}
  },
  snapshots = {},
  original = {}
}

-- Initialize test environment
M.setup = function(opts)
  opts = opts or {}
  local state = _G.test_state

  -- Store original functions
  if not state.original.notify then
    state.original.notify = vim.notify
  end

  -- Mock vim.notify
  vim.notify = function(msg, level, opts)
    table.insert(state.notifications, {
      msg = msg,
      level = level,
      opts = opts
    })
  end

  -- Clear previous state
  state.notifications = {}
  state.mocks = {
    notify = {},
    commands = {},
    keymaps = {}
  }

  -- Create test buffer if needed
  if not state.current_buffer or not vim.api.nvim_buf_is_valid(state.current_buffer) then
    state.current_buffer = M.buffer.create({
      buftype = 'nofile',
      modifiable = true
    })
  end
end

-- Clean up test environment
M.cleanup = function()
  local state = _G.test_state

  -- Restore original functions
  if state.original.notify then
    vim.notify = state.original.notify
  end

  -- Clean up test buffers
  for _, bufnr in ipairs(state.buffers) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end

  -- Reset state
  state.buffers = {}
  state.notifications = {}
  state.mocks = {
    notify = {},
    commands = {},
    keymaps = {}
  }
  state.snapshots = {}
  state.current_buffer = nil
end

-- Helper to wait for condition
M.wait = function(condition, timeout)
  timeout = timeout or 1000
  local start = vim.loop.now()
  while not condition() do
    vim.cmd('sleep 10m')
    if vim.loop.now() - start > timeout then
      error('Timeout waiting for condition')
    end
  end
end

-- Helper to run async tests
M.async_test = function(test_fn)
  return function(done)
    local success, result = pcall(test_fn)
    if not success then
      done(result)
    else
      done()
    end
  end
end

-- Helper to get notifications
M.get_notifications = function()
  return _G.test_state.notifications
end

-- Helper to clear notifications
M.clear_notifications = function()
  _G.test_state.notifications = {}
end

-- Helper to verify notification
M.assert_notification = function(pattern, level)
  local notifications = M.get_notifications()
  for _, notif in ipairs(notifications) do
    if notif.msg:match(pattern) and (not level or notif.level == level) then
      return true
    end
  end
  error(string.format("Notification matching '%s' not found", pattern))
end

return M