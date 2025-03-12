-- Mock system for testing
local api = vim.api
local M = {}

-- Track original functions
local originals = {}

-- Mock vim.notify
M.notify = function()
  -- Store original if not already stored
  if not originals.notify then
    originals.notify = vim.notify
  end

  local notifications = {}
  vim.notify = function(msg, level, opts)
    table.insert(notifications, {
      msg = msg,
      level = level,
      opts = opts
    })
  end

  -- Return controller
  return {
    calls = notifications,
    restore = function()
      vim.notify = originals.notify
    end,
    clear = function()
      notifications = {}
    end,
    get_last = function()
      return notifications[#notifications]
    end,
    assert_called = function(pattern, level)
      for _, notif in ipairs(notifications) do
        if notif.msg:match(pattern) and (not level or notif.level == level) then
          return true
        end
      end
      error(string.format("Expected notification matching '%s' not found", pattern))
    end
  }
end

-- Mock vim command
M.command = function(name, impl)
  -- Store original if exists
  local original = nil
  pcall(function()
    original = vim.api.nvim_get_commands({})[name]
  end)

  -- Track calls
  local calls = {}
  
  -- Create command
  vim.api.nvim_create_user_command(name, function(opts)
    table.insert(calls, opts)
    if type(impl) == 'function' then
      impl(opts)
    end
  end, {})

  -- Return controller
  return {
    calls = calls,
    restore = function()
      vim.api.nvim_del_user_command(name)
      if original then
        vim.api.nvim_create_user_command(name, original.callback, original)
      end
    end,
    clear = function()
      calls = {}
    end,
    assert_called = function(args)
      for _, call in ipairs(calls) do
        if not args or vim.deep_equal(call.args, args) then
          return true
        end
      end
      error(string.format("Command '%s' not called with expected args", name))
    end
  }
end

-- Mock keymap
M.keymap = function(mode, lhs, rhs)
  -- Store original mapping
  local original = nil
  pcall(function()
    original = vim.fn.maparg(lhs, mode, false, true)
  end)

  -- Track calls
  local calls = {}

  -- Create mapping
  vim.keymap.set(mode, lhs, function()
    table.insert(calls, {
      mode = mode,
      lhs = lhs,
      time = vim.loop.now()
    })
    if type(rhs) == 'function' then
      rhs()
    end
  end)

  -- Return controller
  return {
    calls = calls,
    restore = function()
      vim.keymap.del(mode, lhs)
      if original and original.rhs then
        vim.keymap.set(mode, lhs, original.rhs, original)
      end
    end,
    clear = function()
      calls = {}
    end,
    assert_called = function()
      if #calls == 0 then
        error(string.format("Keymap '%s' in mode '%s' not called", lhs, mode))
      end
      return true
    end
  }
end

-- Mock autocmd
M.autocmd = function(event, pattern, callback)
  local calls = {}
  
  -- Create autocmd
  local id = vim.api.nvim_create_autocmd(event, {
    pattern = pattern,
    callback = function(args)
      table.insert(calls, {
        event = args.event,
        buf = args.buf,
        file = args.file,
        match = args.match,
        time = vim.loop.now()
      })
      if callback then
        return callback(args)
      end
    end
  })

  -- Return controller
  return {
    calls = calls,
    restore = function()
      pcall(vim.api.nvim_del_autocmd, id)
    end,
    clear = function()
      calls = {}
    end,
    assert_called = function()
      if #calls == 0 then
        error(string.format("Autocmd for '%s' with pattern '%s' not triggered", event, pattern))
      end
      return true
    end
  }
end

return M