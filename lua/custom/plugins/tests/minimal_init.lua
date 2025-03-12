-- Minimal config for test environment
local api = vim.api
local test_root = debug.getinfo(1, 'S').source:sub(2):match('(.*)/'):gsub('/tests', '')
local plugin_root = test_root .. '/pack/vendor/start'

-- Add test directories to runtimepath
vim.opt.rtp:append(plugin_root .. '/plenary.nvim')
vim.opt.rtp:append(test_root)

-- Load test dependencies
local ok, plenary = pcall(require, 'plenary')
if not ok then
  error('Please run "make deps" to install test dependencies')
end

-- Configure paths
_G.TEST_ROOT = test_root
_G.PLENARY_ROOT = plugin_root .. '/plenary.nvim'

-- Test setup function
_G.test_setup = function()
  -- Preserve original functions
  _G.test_state = _G.test_state or {}
  _G.test_state.original = _G.test_state.original or {}
  local orig = _G.test_state.original

  -- Store original notify
  orig.notify = vim.notify
  vim.notify = function(msg, level, opts)
    table.insert(_G.test_state.notifications or {}, {
      msg = msg,
      level = level,
      opts = opts
    })
  end

  -- Create test buffer
  local buf = api.nvim_create_buf(false, true)
  api.nvim_set_current_buf(buf)
  _G.test_state.buffer = buf

  -- Reset notifications
  _G.test_state.notifications = {}
end

-- Test cleanup function
_G.test_cleanup = function()
  -- Restore original functions
  local orig = _G.test_state.original
  if orig then
    vim.notify = orig.notify
  end

  -- Clean up test buffer
  local buf = _G.test_state.buffer
  if buf and api.nvim_buf_is_valid(buf) then
    api.nvim_buf_delete(buf, { force = true })
  end

  -- Reset state
  _G.test_state = {}
end

-- Set up before/after hooks
before_each(_G.test_setup)
after_each(_G.test_cleanup)

-- Configure test environment
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false
vim.opt.hidden = true

-- Initialize workspace
vim.cmd [[
  set noswapfile
  set nobackup
  set nowritebackup
  set noundofile
  set hidden
]]

-- Return environment info for debugging
return {
  plugin_root = plugin_root,
  test_root = test_root,
  plenary_root = _G.PLENARY_ROOT
}
