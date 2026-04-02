-- gtest_debug.lua
-- Parse GTest name at cursor and launch DAP debug session.
--
-- Project config file: .gtest-debug.json at project root, e.g.:
-- {
--   "program": "build/rcv_test.app/Contents/MacOS/rcv_test",
--   "preLaunchCommand": "sh ci/clear_ut_data.sh"
-- }

local M = {}

local config_filename = ".gtest-debug.json"

--- Find project root by searching upward for .gtest-debug.json or .git
local function find_project_root()
  local path = vim.fn.expand("%:p:h")
  while path and path ~= "/" do
    if vim.fn.filereadable(path .. "/" .. config_filename) == 1 then
      return path
    end
    if vim.fn.isdirectory(path .. "/.git") == 1 then
      return path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return vim.fn.getcwd()
end

--- Read config from .gtest-debug.json
local function read_config(root)
  local filepath = root .. "/" .. config_filename
  if vim.fn.filereadable(filepath) ~= 1 then
    return nil, "Config file not found: " .. filepath
  end
  local content = table.concat(vim.fn.readfile(filepath), "\n")
  local ok, config = pcall(vim.json.decode, content)
  if not ok then
    return nil, "Failed to parse " .. filepath .. ": " .. tostring(config)
  end
  return config
end

--- Parse GTest name (ClassName.methodName) from cursor context.
--- Searches backward from cursor for TEST_F/TEST/TEST_P/TYPED_TEST macro.
local function parse_test_name()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1] -- 1-indexed
  local total_lines = vim.api.nvim_buf_line_count(bufnr)

  local pattern = "TEST[_%w]*%s*%(%s*([%w_]+)%s*,%s*([%w_]+)"

  for row = cursor_row, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
    local class_name, method_name = line:match(pattern)
    if class_name and method_name then
      return class_name .. "." .. method_name
    end
    -- Handle macro args spanning multiple lines
    if line:match("TEST[_%w]*%s*%(") then
      local combined = line
      for next_row = row + 1, math.min(row + 5, total_lines) do
        local next_line = vim.api.nvim_buf_get_lines(bufnr, next_row - 1, next_row, false)[1]
        combined = combined .. " " .. next_line
        class_name, method_name = combined:match(pattern)
        if class_name and method_name then
          return class_name .. "." .. method_name
        end
      end
    end
    -- Stop at previous test's closing brace
    if row < cursor_row and line:match("^%s*}") then
      break
    end
  end
  return nil
end

--- Launch DAP with gtest filter
function M.debug_test()
  local root = find_project_root()
  local config, err = read_config(root)
  if not config then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  local program = config.program
  if not program then
    vim.notify("'program' not set in " .. config_filename, vim.log.levels.ERROR)
    return
  end

  -- Resolve relative path against project root
  if not program:match("^/") then
    program = root .. "/" .. program
  end

  if vim.fn.filereadable(program) ~= 1 then
    vim.notify("Executable not found: " .. program, vim.log.levels.ERROR)
    return
  end

  local test_name = parse_test_name()
  if not test_name then
    vim.notify("No GTest found at cursor position", vim.log.levels.WARN)
    return
  end

  -- Run preLaunchCommand if configured (e.g., clean .gcda files)
  if config.preLaunchCommand then
    vim.fn.system("cd " .. vim.fn.shellescape(root) .. " && " .. config.preLaunchCommand)
  end

  vim.notify("Debugging: " .. test_name, vim.log.levels.INFO)

  local dap = require("dap")
  local session = dap.session()
  if session then
    dap.terminate(nil, nil, function()
      vim.defer_fn(function()
        dap.run({
          type = "lldb",
          request = "launch",
          name = "GTest: " .. test_name,
          program = program,
          args = {},
          cwd = config.cwd or root,
          stopOnEntry = false,
          env = {
            GTEST_FILTER = test_name,
          },
        })
      end, 500)
    end)
    return
  end
  dap.run({
    type = "lldb",
    request = "launch",
    name = "GTest: " .. test_name,
    program = program,
    args = {},
    cwd = config.cwd or root,
    stopOnEntry = false,
    env = {
      GTEST_FILTER = test_name,
    },
  })
end

--- Print test name at cursor (for verification)
function M.show_test_name()
  local test_name = parse_test_name()
  if test_name then
    vim.notify("Test: " .. test_name, vim.log.levels.INFO)
  else
    vim.notify("No GTest found at cursor position", vim.log.levels.WARN)
  end
end

return M
