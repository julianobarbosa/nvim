-- Enhanced assertions for testing
local eq = assert.are.equal
local api = vim.api
local M = {}

-- Enhanced equality assertion with detailed diffs
M.equals = function(expected, actual, msg)
  msg = msg or 'Values are not equal'
  
  -- Handle nil values
  if expected == nil and actual == nil then return true end
  if expected == nil or actual == nil then
    error(string.format('%s\nExpected: %s\nActual: %s', 
      msg, vim.inspect(expected), vim.inspect(actual)))
  end

  -- Handle different types
  if type(expected) ~= type(actual) then
    error(string.format('%s\nType mismatch:\nExpected: %s (%s)\nActual: %s (%s)',
      msg, vim.inspect(expected), type(expected), 
      vim.inspect(actual), type(actual)))
  end

  -- Table comparison with detailed diff
  if type(expected) == 'table' then
    local diff = {}
    local function check_table(exp, act, path)
      for k, v in pairs(exp) do
        local current_path = path and (path .. '.' .. k) or k
        if act[k] == nil then
          table.insert(diff, string.format('Missing key at %s', current_path))
        elseif type(v) == 'table' then
          check_table(v, act[k], current_path)
        elseif v ~= act[k] then
          table.insert(diff, string.format('Mismatch at %s:\nExpected: %s\nActual: %s',
            current_path, vim.inspect(v), vim.inspect(act[k])))
        end
      end
      for k, _ in pairs(act) do
        if exp[k] == nil then
          local current_path = path and (path .. '.' .. k) or k
          table.insert(diff, string.format('Extra key at %s', current_path))
        end
      end
    end

    check_table(expected, actual, '')
    if #diff > 0 then
      error(string.format('%s\nDifferences found:\n%s',
        msg, table.concat(diff, '\n')))
    end
    return true
  end

  -- Simple value comparison
  if expected ~= actual then
    error(string.format('%s\nExpected: %s\nActual: %s',
      msg, vim.inspect(expected), vim.inspect(actual)))
  end
  return true
end

-- Buffer content assertion
M.buffer_equals = function(bufnr, expected, msg)
  msg = msg or 'Buffer content does not match'
  local actual = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  
  -- Handle string input
  if type(expected) == 'string' then
    expected = vim.split(expected, '\n')
  end

  local content_matches = vim.deep_equal(expected, actual)
  if not content_matches then
    error(string.format('%s\nExpected:\n%s\n\nActual:\n%s',
      msg, table.concat(expected, '\n'), table.concat(actual, '\n')))
  end
  return true
end

-- Match pattern in string or buffer
M.matches = function(pattern, text, msg)
  msg = msg or string.format("Pattern '%s' not found", pattern)
  
  -- Handle buffer input
  if type(text) == 'number' then
    local lines = api.nvim_buf_get_lines(text, 0, -1, false)
    text = table.concat(lines, '\n')
  end

  if not text:match(pattern) then
    error(string.format('%s\nText:\n%s', msg, text))
  end
  return true
end

-- Snapshot testing
M.matches_snapshot = function(value, name)
  local snapshots = _G.test_state.snapshots or {}
  _G.test_state.snapshots = snapshots
  
  -- Convert value to string representation
  local stringified = vim.inspect(value)

  -- Compare with existing snapshot
  if snapshots[name] then
    local matches = snapshots[name] == stringified
    if not matches then
      error(string.format('Snapshot mismatch for "%s":\nExpected:\n%s\n\nActual:\n%s',
        name, snapshots[name], stringified))
    end
    return true
  end

  -- Store new snapshot
  snapshots[name] = stringified
  return true
end

-- Contains emoji
M.contains_emoji = function(text, msg)
  msg = msg or 'No emoji found in text'
  
  -- Basic emoji pattern
  local emoji_pattern = '[\u{1F300}-\u{1F9FF}]'
  
  if not text:match(emoji_pattern) then
    error(string.format('%s:\n%s', msg, text))
  end
  return true
end

-- Function was called
M.was_called = function(fn_name, times)
  local calls = _G.test_state.calls and _G.test_state.calls[fn_name] or {}
  if times then
    local actual = #calls
    if actual ~= times then
      error(string.format("Function '%s' was called %d times, expected %d",
        fn_name, actual, times))
    end
  elseif #calls == 0 then
    error(string.format("Function '%s' was never called", fn_name))
  end
  return true
end

return M