local map = vim.keymap.set

map({ 'n', 'x' }, 'Q', '<Nop>')
map({ 'n', 'x' }, '<C-a>', '<Nop>')
map({ 'n', 'x' }, '<C-x>', '<Nop>')
map('x', 'p', [['_dP]], { desc = 'Paste without replacing the register' })

map('n', 'j', 'gj', { desc = 'Move down by display line' })
map('n', 'k', 'gk', { desc = 'Move up by display line' })
map({ 'n', 'x', 'o' }, 'H', '^', { desc = 'Start of line' })
map({ 'n', 'x', 'o' }, 'L', '$', { desc = 'End of line' })
map('x', '<Tab>', '>gv', { desc = 'Indent selection' })
map('x', '<S-Tab>', '<gv', { desc = 'Unindent selection' })
map('n', 'K', '<cmd>move-2<CR>==', { desc = 'Move line up' })
map('n', 'J', '<cmd>move+<CR>==', { desc = 'Move line down' })
map('x', 'K', ":move '<-2<CR>gv=gv", { desc = 'Move selection up' })
map('x', 'J', ":move '>+1<CR>gv=gv", { desc = 'Move selection down' })

for _, key in ipairs({ 'n', 'N', '*', '#', 'g*' }) do
  map('n', key, key .. 'zz', { desc = 'Search and center' })
end
map('n', '<C-o>', '<C-o>zz', { desc = 'Jump back and center' })
map('n', '<C-i>', '<C-i>zz', { desc = 'Jump forward and center' })

for _, mode in ipairs({ 'n', 'i', 'x' }) do
  for _, key in ipairs({ '<Down>', '<Left>', '<Right>', '<Up>' }) do
    map(mode, key, '<Nop>')
  end
end

map('x', '@', function()
  local register = vim.fn.getcharstr()
  vim.cmd("'<,'>normal @" .. register)
end, { desc = 'Run macro over selection' })

map('n', '[d', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Previous diagnostic' })

map('n', ']d', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Next diagnostic' })

map('n', '<leader><leader>', '<C-^>', { desc = 'Alternate buffer' })
map('n', '<leader>-', '<cmd>split<CR>', { desc = 'Horizontal split' })
map('n', '<leader>|', '<cmd>vsplit<CR>', { desc = 'Vertical split' })
map('n', '<leader>w', '<cmd>write<CR>', { desc = 'Save' })
map('n', '<leader>q', '<cmd>quit<CR>', { desc = 'Quit' })
map('n', '<leader>wq', '<cmd>wq<CR>', { desc = 'Save and quit' })
map('n', '<leader>Q', '<cmd>quit!<CR>', { desc = 'Force quit' })

map({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map({ 'n', 'x' }, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })
map({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste after from system clipboard' })
map({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })

for tab = 1, 9 do
  map('n', '<leader>' .. tab, tab .. 'gt', { desc = 'Go to tab ' .. tab })
end
map('n', '<leader>n', '<cmd>tabnew<CR>', { desc = 'New tab' })
map('n', '<leader>x', '<cmd>tabclose<CR>', { desc = 'Close tab' })

local function toggle_zoom()
  local state = vim.t.zoom_restore
  if state then
    vim.cmd(state.command)
    vim.t.zoom_restore = nil
  else
    vim.t.zoom_restore = {
      command = vim.fn.winrestcmd(),
      window = vim.api.nvim_get_current_win(),
    }
    vim.cmd('wincmd _')
    vim.cmd('wincmd |')
  end
end

local zoom_group = vim.api.nvim_create_augroup('legacy_zoom_restore', { clear = true })
vim.api.nvim_create_autocmd('WinEnter', {
  group = zoom_group,
  callback = function()
    local state = vim.t.zoom_restore
    if state and state.window ~= vim.api.nvim_get_current_win() then
      vim.cmd(state.command)
      vim.t.zoom_restore = nil
    end
  end,
})

map('n', '<leader>+', toggle_zoom, { desc = 'Toggle window zoom' })

map('n', '<leader>`z', function()
  vim.cmd('vsplit ' .. vim.fn.fnameescape(vim.fn.expand('~/.zshrc')))
end, { desc = 'Edit zsh config' })
