return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    opts = {},
    keys = {
      { '<leader>g', function() require('neogit').open() end, desc = 'Neogit' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufWinEnter',
    opts = { current_line_blame = true },
    keys = {
      { 'ghs', function() require('gitsigns').stage_hunk() end, desc = 'Stage hunk' },
      { 'ghu', function() require('gitsigns').reset_hunk() end, desc = 'Reset hunk' },
      { 'ghp', function() require('gitsigns').preview_hunk() end, desc = 'Preview hunk' },
      { '<leader>U', function() require('gitsigns').reset_hunk() end, desc = 'Reset hunk' },
      {
        '<leader>ob',
        function() require('gitsigns').toggle_current_line_blame() end,
        desc = 'Toggle line blame',
      },
      { '<leader>og', function() require('gitsigns').toggle_signs() end, desc = 'Toggle Git signs' },
      { '[c', function() require('gitsigns').nav_hunk('prev') end, desc = 'Previous Git hunk' },
      { ']c', function() require('gitsigns').nav_hunk('next') end, desc = 'Next Git hunk' },
      {
        'ig',
        function() require('gitsigns').select_hunk() end,
        mode = { 'o', 'x' },
        desc = 'Select Git hunk',
      },
      {
        'ag',
        function() require('gitsigns').select_hunk() end,
        mode = { 'o', 'x' },
        desc = 'Select Git hunk',
      },
    },
  },
}
