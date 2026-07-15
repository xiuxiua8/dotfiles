return {
  {
    'stevearc/oil.nvim',
    opts = { view_options = { show_hidden = true } },
    keys = {
      { '<leader>e', '<cmd>Oil<CR>', desc = 'File browser' },
    },
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        enabled = true,
        sources = {
          files = { hidden = true, ignored = true },
          grep = { hidden = true, ignored = true },
        },
      },
      scroll = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },
      dashboard = { enabled = true },
    },
    keys = {
      { '<leader>f', function() Snacks.picker.files() end, desc = 'Find files' },
      { '<leader>s', function() Snacks.picker.grep() end, desc = 'Search text' },
      { '<leader>H', function() Snacks.picker.recent() end, desc = 'Recent files' },
      { '<leader>b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      { '<leader>!', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
      { '<leader>Y', function() Snacks.picker.registers() end, desc = 'Registers' },
      { '<leader>u', function() Snacks.picker.undo() end, desc = 'Undo history' },
      { '<leader>`', function() Snacks.dashboard.open() end, desc = 'Dashboard' },
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Go to definition' },
    },
  },
}
