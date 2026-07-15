local M = {}

local custom_compile_command

local function current_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then
    vim.notify('Save the C++ buffer before compiling it', vim.log.levels.WARN)
    return nil
  end
  return file
end

local function open_terminal(command, cwd)
  vim.cmd('botright 15new')
  local terminal_buffer = vim.api.nvim_get_current_buf()
  local job_id = vim.fn.termopen(command, { cwd = cwd })

  if job_id <= 0 then
    vim.api.nvim_buf_delete(terminal_buffer, { force = true })
    vim.notify('Unable to start the C++ compile command', vim.log.levels.ERROR)
    return
  end

  vim.cmd('startinsert')
end

function M.set_compile_command()
  vim.ui.input({
    prompt = 'C++ compile command: ',
    default = custom_compile_command or '',
  }, function(command)
    if command and command ~= '' then
      custom_compile_command = command
      vim.notify('C++ compile command updated')
    end
  end)
end

function M.run()
  local file = current_file()
  if not file then
    return
  end

  vim.cmd('silent write')

  local cwd = vim.fn.fnamemodify(file, ':h')
  local command
  if custom_compile_command then
    command = vim.fn.expandcmd(custom_compile_command)
  else
    local output = vim.fn.fnamemodify(file, ':r')
    command = table.concat({
      'g++ -std=c++20',
      vim.fn.shellescape(file),
      '-o',
      vim.fn.shellescape(output),
      '&&',
      vim.fn.shellescape(output),
    }, ' ')
  end

  open_terminal(command, cwd)
end

function M.setup()
  local group = vim.api.nvim_create_augroup('cpp_compile_run', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'cpp',
    callback = function(event)
      vim.keymap.set('n', '<leader>5', M.run, {
        buffer = event.buf,
        desc = 'Compile and run C++',
      })
      vim.keymap.set('n', '<leader>6', M.set_compile_command, {
        buffer = event.buf,
        desc = 'Set C++ compile command',
      })
    end,
  })
end

return M
