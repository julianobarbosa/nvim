-- Buffer manipulation helper module
local api = vim.api
local M = {}

-- Create a new buffer with options
M.create = function(opts)
  opts = opts or {}
  local bufnr = api.nvim_create_buf(false, true)
  
  -- Set buffer options
  for option, value in pairs(opts) do
    api.nvim_buf_set_option(bufnr, option, value)
  end

  -- Track buffer in test state
  table.insert(_G.test_state.buffers, bufnr)

  -- Set as current if requested
  if opts.set_current then
    api.nvim_set_current_buf(bufnr)
  end

  return bufnr
end

-- Delete a buffer
M.cleanup = function(bufnr)
  if not bufnr then return end
  
  -- Remove from tracked buffers
  for i, tracked_bufnr in ipairs(_G.test_state.buffers) do
    if tracked_bufnr == bufnr then
      table.remove(_G.test_state.buffers, i)
      break
    end
  end

  -- Delete if still valid
  if api.nvim_buf_is_valid(bufnr) then
    api.nvim_buf_delete(bufnr, { force = true })
  end
end

-- Set buffer lines
M.set_lines = function(bufnr, content, start_line, end_line)
  -- Handle string input
  if type(content) == 'string' then
    content = vim.split(content, '\n')
  end

  -- Default to whole buffer
  start_line = start_line or 0
  end_line = end_line or -1

  api.nvim_buf_set_lines(bufnr, start_line, end_line, false, content)
end

-- Get buffer lines
M.get_lines = function(bufnr, start_line, end_line)
  return api.nvim_buf_get_lines(bufnr, start_line or 0, end_line or -1, false)
end

-- Get buffer content as string
M.get_content = function(bufnr)
  local lines = M.get_lines(bufnr)
  return table.concat(lines, '\n')
end

-- Assert buffer content
M.assert_content = function(bufnr, expected)
  local content = M.get_content(bufnr)
  assert.equals(expected, content, "Buffer content does not match expected")
end

-- Find text in buffer
M.find_text = function(bufnr, pattern)
  local lines = M.get_lines(bufnr)
  for line_nr, line in ipairs(lines) do
    if line:match(pattern) then
      return line_nr - 1, line:find(pattern)
    end
  end
  return nil
end

-- Replace text in buffer
M.replace_text = function(bufnr, pattern, replacement)
  local lines = M.get_lines(bufnr)
  local found = false
  
  for i, line in ipairs(lines) do
    if line:match(pattern) then
      lines[i] = line:gsub(pattern, replacement)
      found = true
    end
  end

  if found then
    M.set_lines(bufnr, lines)
  end
  
  return found
end

-- Set cursor position
M.set_cursor = function(bufnr, row, col)
  if bufnr == 0 or api.nvim_get_current_buf() == bufnr then
    api.nvim_win_set_cursor(0, {row, col})
  else
    -- Find or create window for buffer
    local win = vim.fn.bufwinid(bufnr)
    if win == -1 then
      vim.cmd('split')
      win = api.nvim_get_current_win()
      api.nvim_win_set_buf(win, bufnr)
    end
    api.nvim_win_set_cursor(win, {row, col})
  end
end

return M