local map = vim.keymap.set

map('n', '<Esc>', '<cmd>write<CR>', { desc = 'Save' })
map('n', '<C-a>', 'ggVG', { desc = 'Select all' })
map('x', 'p', [['_dP]], { desc = 'Paste without replacing the register' })

map('n', '[d', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Previous diagnostic' })

map('n', ']d', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Next diagnostic' })
